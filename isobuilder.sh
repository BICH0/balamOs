#!/bin/bash
REPO="BICH0/balamOs/master/"
WORKDIR="."
function checkOutput {
	if [[ $? -eq 0 ]]
	then
		echo -en " [\e[0;32mOK"
	else
		echo -en " [ \e[0;31mERROR $?"
	fi
	echo -e "\e[0m]"
	return $?
}
function info {
	echo -e "\n[\e[0;35mINFO\e[0m] $1"
}
function bulkMove {
	source=$1
	dest=$2
	files=$(find $source -maxdepth 1 2>/dev/null | tail +2)
	if [ -z "$files" ]
	then
		echo -e " - $source \e[0;33m[NOT FOUND]\e[0m"
		return 1
	fi
	for file in $files
	do
		destfile=$(echo $dest/${file##*/} | tr -s "/")
		echo -n " - Moving $file -> $destfile"
		cp -rT $file $destfile
		checkOutput
	done
	return 0
}
info "Checking build environment"
if [ ! $(whoami) == "root" ]
then
	echo -e "\e[0;31m[ERROR] Isobuilder must be executed as root\e[0m"
	exit
fi
mkdir ${WORKDIR}/liveiso 2>/dev/null
mkdir -p ${WORKDIR}/liveiso/airootfs/etc/skel
mkdir -p ${WORKDIR}/liveiso/airootfs/usr/share/balamos-install/data/
ABS_PATH=$(cd ${WORKDIR}; pwd)

info "Copying releng into liveiso"
for ((i=0;i<=1;i++))
do
	bulkMove "${WORKDIR}/releng/" "${WORKDIR}/liveiso/"
	if [ $? -ne 0 ]
	then
		releng="/usr/share/archiso/configs/releng"
		if [ -d $releng ]
		then
			echo -n " - Copying releng from /usr/share"
			cp -r $releng ${WORKDIR}/releng
			checkOutput $?
			if [ $? -eq 0 ]
			then
				continue	
			fi
		fi
		echo -e "\e[0;31m[ERROR] Unable to locate or copy releng, verify archiso is installed\e[0m"
		exit 1
	fi
done

info "Setting liveiso makefiles"
bulkMove "${WORKDIR}/isomakefiles/" "${WORKDIR}/liveiso/"

info "Setting skel "
bulkMove "${WORKDIR}/skel/" "${WORKDIR}/liveiso/airootfs/etc/skel/"
if [ $? -eq 0 ]
then
	cp -r ${WORKDIR}/liveiso/airootfs/etc/skel/ ${WORKDIR}/liveiso/airootfs/usr/share/balamos-install/data/skel/
fi

info "Adding skel to root"
bulkMove ${WORKDIR}/liveiso/airootfs/etc/skel/ ${WORKDIR}/liveiso/airootfs/root/
if [ $? -eq 0 ]
then
	cp -r ${WORKDIR}/liveiso/airootfs/etc/skel/ ${WORKDIR}/liveiso/airootfs/usr/share/balamos-install/data/root/
fi

info "Adding skel to users"
users=$(grep -v "root" ${WORKDIR}/custfiles/etc/passwd 2>/dev/null | cut -f6 -d:)
if [ -n "$users" ]
then
	for path in "${users}"
	do
		echo -n " - Creating $path"
		mkdir -p ${WORKDIR}/liveiso/airootfs/$path &>/dev/null
		checkOutput $?
		bulkMove ${WORKDIR}/liveiso/airootfs/etc/skel/ ${WORKDIR}/liveiso/airootfs/$path
	done
fi

if [[ -d ${WORKDIR}/custfiles ]]
then
	info "Custom files detected (custfiles), copying to system root"
	bulkMove "${WORKDIR}/custfiles/" "${WORKDIR}/liveiso/airootfs/"
fi

info "Looking for scripts in skel"
for file in $(find ${WORKDIR}/liveiso/airootfs/root/ -type f -name "*.sh")
do
	echo -n "  - Setting $file as 744 "
	chmod 744 $file
	checkOutput
done

info "Injecting installer"
installerLocations=( ${WORKDIR}"/../setup-scripts/installer.sh" ${WORKDIR}"/installer.sh" )
installerLoc=""
echo -n " - Locating installer"
for installer in ${installerLocations[@]}
do
	if [ -f $installer ]
	then
		installerLoc=$installer
		break
	fi
done
if [ -z $installerLoc ]
then
	$(exit 1)
fi
checkOutput
installerPath="${WORKDIR}/liveiso/airootfs/usr/bin/"
mkdir -p $installerPath
installerPath="${installerPath}/balamos-install"
echo -n " - Moving installer"
cp $installer $installerPath
checkOutput
echo -n " - Setting permissions"
chmod 755 $installerPath
checkOutput

info "Adding oh-my-zsh themes"
for file in 'balamos.zsh-theme' 'balamosr.zsh-theme'
do
	if [ ! -f "${WORKDIR}/$file" ]
	then
		echo -n " - Downloading $file"
		curl "https://raw.githubusercontent.com/$REPO/$file" > ${WORKDIR}/$file
		checkOutput $?
		if [ $? -ne 0 ]
		then
			echo -e "\e[0;31m[ERROR]\e[0m Could not fetch $file"
		fi
	fi
	echo -n " - Copying $file"
	cp "${WORKDIR}/$file" "${WORKDIR}/liveiso/airootfs/usr/share/oh-my-zsh/themes/"
	checkOutput $?
done

info "Patching custom-repo"
if [ ! -d "${WORKDIR}/customrepo" ]
then
	echo -e "\e[0;31m[ERROR] Custom repo doesn't exist, installation will fail\e[0m"
	exit 1
fi
echo -n " - Applying path"
sed -i "s|\${WORKDIR}|$ABS_PATH|g" ${WORKDIR}/liveiso/pacman.conf 
checkOutput $?
echo " - Fixing links"
for link in 'micro-aur.db' 'micro-aur.files'
do
	target="${WORKDIR}/customrepo/${link}"
	if [ ! -L "$target" ]
	then
		echo -n "   - $link"
		if [ -e "$target" ]
		then
			rm $target
		fi
		ln -s $ABS_PATH/customrepo/micro-aur.db.tar.gz $target
		checkOutput $?
	fi
done

info "Fetching packages"
>./packages.x86_64
while read -r line
do
	if [[ ! $line =~ ^\;\; ]]
	then
		echo $(echo $line | awk -F'[[:space:]];;' '{print $1}')>>packages.x86_64
	fi
done < ./cust-packages.x86_64
echo "Os Packages: " $(cat packages.x86_64 | wc -l)
while [[ ! $res =~ ^[sn]$ ]]
do
	echo "Move package list file? s/n"
	read res
	res=${res,,}
done
if [[ $res == "s" ]]
then
	echo -n "Moving file "
	mv ./packages.x86_64 ./liveiso/
	checkOutput
fi 
info "Starting building process"
sudo mkarchiso -v -r -w ${WORKDIR}/workdir -o ${WORKDIR}/out ${WORKDIR}/liveiso
rm -rf ${WORKDIR}/liveiso
