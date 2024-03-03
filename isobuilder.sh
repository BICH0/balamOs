#!/bin/bash
WORKDIR="."
function checkOutput {
	if [[ $? -eq 0 ]]
	then
		echo -en " [\e[0;32mOK"
	else
		echo -en " [ \e[0;31mERROR $?"
	fi
	echo -e "\e[0m]"
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

info "Copying releng into liveiso"
bulkMove "${WORKDIR}/releng/" "${WORKDIR}/liveiso/"

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

info "Patching custom-repo path"
sed -i "s|\${WORKDIR}|$(cd ${WORKDIR};pwd)|g" ${WORKDIR}/liveiso/pacman.conf 

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
