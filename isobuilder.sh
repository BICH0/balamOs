#!/bin/bash
REPO="BICH0/balamOs"
BRANCH="master"
WORKDIR="."

res="y"
if [ "$1" == "--paranoid" ]
then
	res=""
fi

trap cleanup SIGINT

function cleanup {
	echo "[WARNING] CLEANING UP, PLEASE WAIT"
	cd $ABS_PATH
	rm -rf ${WORKDIR}/workdir 2>/dev/null
	rm -rf ${WORKDIR}/liveiso 2>/dev/null
	for mpoint in "$(mount -l | grep $ABS_PATH | cut -f3 -d" ")"
	do
		if [ -d "$mpoint" ]
		then
			echo -n " - Umounting $mpoint"
			umount $mpoint &>/dev/null
			checkOutput
		fi
	done
	exit 1
}

function checkOutput {
	if [ -z "$1" ]
	then
		ecode=$?
	else
		ecode=$1
	fi
	if [[ $ecode -eq 0 ]]
	then
		echo -en " [\e[0;32mOK"
	else
		echo -en " [\e[0;31mERROR $ecode"
	fi
	echo -e "\e[0m]"
	return $ecode
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

# Trust in rvm gpg keys
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB 1>/dev/null
gpg --edit-key 409B6B1796C275462A1703113804BB82D39DC0E3 trust # mpapis@gmail.com
gpg --edit-key 7D2BAF1CF37B13E2069D6956105BD0E739499BDB trust # piotr.kuczynski@gmail.com

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
			checkOutput
			if [ $? -eq 0 ]
			then
				continue	
			fi
		fi
		echo -e "\e[0;31m[ERROR] Unable to locate or copy releng, verify archiso is installed\e[0m"
		exit 1
	fi
done

info "Updating submodules"
if [ ! -f ${WORKDIR}/isomakefiles/grub/themes/balam-grub/theme.txt ]
then
	git submodule init --quiet
fi
echo -n " - Updating"
git submodule update --quiet --remote --recursive
checkOutput

if [ ! -f ${WORKDIR}/isomakefiles/syslinux/splash.png ]
then
	info "Adding splash to syslinux"
	mv ${WORKDIR}/isomakefiles/grub/themes/balam-grub/splash.png ${WORKDIR}/isomakefiles/syslinux/splash.png
fi

info "Setting liveiso makefiles"
bulkMove "${WORKDIR}/isomakefiles/" "${WORKDIR}/liveiso/"

info "Setting skel "
bulkMove "${WORKDIR}/skel/" "${WORKDIR}/liveiso/airootfs/etc/skel/"
mv "${WORKDIR}/liveiso/airootfs/etc/skel/.zshrc" "${WORKDIR}/liveiso/airootfs/etc/skel/.zshrc.bak" #Without this build will fail due to grml-zsh-config
if [ $? -eq 0 ]
then
	cp -r ${WORKDIR}/liveiso/airootfs/etc/skel/ ${WORKDIR}/liveiso/airootfs/usr/share/balamos-install/data/skel/
	mv ${WORKDIR}/liveiso/airootfs/usr/share/balamos-install/data/skel/.zshrc.bak ${WORKDIR}/liveiso/airootfs/usr/share/balamos-install/data/skel/.zshrc
fi

info "Adding skel to root"
bulkMove ${WORKDIR}/liveiso/airootfs/etc/skel/ ${WORKDIR}/liveiso/airootfs/root/
rm ${WORKDIR}/liveiso/airootfs/root/.zshrc.bak 2>/dev/null #Line 110 for more info
echo -n " - Trimming unnecesary files"
rm ${WORKDIR}/liveiso/airootfs/root/.config/{i3,dunst,polybar,rofi} ${WORKDIR}/liveiso/airootfs/root/.mozilla ${WORKDIR}/liveiso/airootfs/root/.conkyrc 2>/dev/null
checkOutput
if [ $? -eq 0 ]
then
	cp -r ${WORKDIR}/liveiso/airootfs/root/ ${WORKDIR}/liveiso/airootfs/usr/share/balamos-install/data/root/
fi

info "Adding skel to users"
users=$(grep -v "root" ${WORKDIR}/custfiles/etc/passwd 2>/dev/null | cut -f6 -d:)
if [ -n "$users" ]
then
	for path in "${users}"
	do
		echo -n " - Creating $path"
		mkdir -p ${WORKDIR}/liveiso/airootfs/$path &>/dev/null
		checkOutput
		bulkMove ${WORKDIR}/liveiso/airootfs/etc/skel/ ${WORKDIR}/liveiso/airootfs/$path
		mv ${WORKDIR}/liveiso/airootfs/$path/.zshrc.bak ${WORKDIR}/liveiso/airootfs/$path/.zshrc #Line 110 for more info
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
if [ ! -d ${WORKDIR}/liveiso/airootfs/usr/share/oh-my-zsh/themes/ ]
then
	mkdir -p ${WORKDIR}/liveiso/airootfs/usr/share/oh-my-zsh/themes/
fi
for file in 'balamos.zsh-theme' 'balamosr.zsh-theme'
do
	if [ ! -f "${WORKDIR}/$file" ]
	then
		echo -n " - Downloading $file"
		curl "https://raw.githubusercontent.com/$REPO/$BRANCH/$file" > ${WORKDIR}/$file
		checkOutput
		if [ $? -ne 0 ]
		then
			echo -e "\e[0;31m[ERROR]\e[0m Could not fetch $file"
		fi
	fi
	echo -n " - Copying $file"
	cp "${WORKDIR}/$file" "${WORKDIR}/liveiso/airootfs/usr/share/oh-my-zsh/themes/"
	checkOutput
done

info "Adding oh-my-zsh modules"
echo -n " - Adding msfvenom-completition"
git clone https://github.com/BICH0/msfvenom-zsh-completion.git "${WORKDIR}/liveiso/airootfs/usr/share/oh-my-zsh/plugins/msfvenom/" --quiet
checkOutput

info "Patching custom-repo"
if [ ! -d "${WORKDIR}/customrepo" ]
then
	echo -e "\e[0;31m[ERROR] Custom repo doesn't exist, installation will fail\e[0m"
	exit 1
fi
echo -n " - Applying path"
sed -i "s|\${WORKDIR}|$ABS_PATH|g" ${WORKDIR}/liveiso/pacman.conf 
checkOutput
echo " - Fixing links"
for link in 'micro-aur.db' 'micro-aur.files'
do
	target="${WORKDIR}/customrepo/${link}"
	echo -n "   - $link"
	if [ ! -L "$target" ]
	then
		if [ -e "$target" ]
		then
			rm $target
		fi
		ln -s $ABS_PATH/customrepo/micro-aur.db.tar.gz $target
		checkOutput
	else
		checkOutput
	fi
done

info "Creating build user"
echo -n " - Adding user"
useradd balambuild -M -r -s /bin/bash &>/dev/null
checkOutput
echo -n " - Changing password"
echo "build" | passwd balambuild --stdin
checkOutput
info "Downloading and building customrepo packages"
cd ${WORKDIR}/customrepo
for pkg in $(cat ./packages.list)
do
	if [[ ! "$pkg" =~ ^.+\.git$ ]]
	then
		echo "   - Skipping $pkg, wrong format, must be git repo"
		continue
	fi
	name=${pkg##*/}
	name=${name%%.*}
	pkgpath="$(pwd)/${name}"
	if [ ! -z "$(find . -regex ".*\/$name-.+\.pkg\.tar\.zst")" ]
	then
		echo "   - Skipping $pkg, compiled package already exists."
		continue
	fi
	if [ -d $pkgpath ]
	then
		echo -n "   - Previous build directory found, deleting it"
		rm -rf $pkgpath
		checkOutput

	fi
	echo -en "  [${name}]\n    - Cloning repo"
	git clone --quiet $pkg
	checkOutput
	if [ ! -d $pkgpath ]
	then
		echo " \-> Unable to download, verify that $pkg is correctly written"
		continue
	fi 
	echo -n "    - Changing user permissions"
	chown -R balambuild: $pkgpath
	owner=$(ls -l $pkgpath | tail +2 | cut -f3 -d" " | head -1)
	if [ "$owner" != "balambuild" ]
	then
		echo -e " \e[0;31m[ERROR]\n         \-> Unable to change permissions (Owned by $owner), verify that the partition isn't ntfs\e[0m"
		ntfsusers=()
		for user in $(grep : $(df . | tr -s " " | tail +2 | cut -f6 -d" ")/.NTFS-3G/UserMapping 2>/dev/null | cut -f1 -d:)
		do
			if [ ! -z "$user" ] && [ ! -z "$(grep $user /etc/passwd)" ]
			then
				ntfsusers+=($user)
			fi
		done
		if [ -z $ntfsusers ]
		then
			rm -r $pkgpath
			continue
		fi
		if [ "${#ntfsusers[@]}" -eq 1 ]
		then
			builduser=${ntfsusers[0]}
		else
			builduser="0"
		fi
		while [[ ! ${ntfsusers[@]} =~ $builduser ]]
		do
			echo -n "Choose a ntfs-3g mapped user [${ntfsusers[@]}]: "
			read -r builduser
		done
		chown -R $builduser: $pkgpath
		if [ "$(ls -l $pkgpath | tail +2 | cut -f3 -d" " | head -1)" == "$builduser" ]
		then
			echo -e "           \->\e[0;32mFixed\e[0m (using $builduser for building)"
		else
			rm -r $pkgpath
			continue
		fi
	else
		builduser="balambuild"
		checkOutput 0
	fi
	echo -n "    - Changing to build directory"
	pushd $pkgpath &>/dev/null
	checkOutput
	if [ $? -ne 0 ]
	then
		rm -r $pkgpath
		echo -e "\e[0;31mUnable to access environment, exiting\e[0m"
		continue
	fi
	echo "    - Building package"
	su $builduser -c "makepkg -sr 1>/dev/null"
	ecode=$?
	echo -n " ---- BUILD EXIT STATUS"
	checkOutput $ecode
	if [ $? -eq 0 ]
	then
		echo "      - Updating micro-aur database"
		files=$(find . -regex .+\.pkg\.tar\.zst)
		if [ $(echo "$files" | wc -l) -gt 1 ]
		then
			files=$(echo "$files" | head -1)
			echo -e "\e[0;32m[WARN]\e[0m\n      More than one file found, using first one $files\n      - Adding package"
		fi
		mv $files ../
		repo-add "../micro-aur.db.tar.gz" "../${files:2}"
		checkOutput
	fi
	echo -n "   - Cleaning build dir"
	rm -rf $pkgpath
	checkOutput
	popd &>/dev/null
done
info "Cleaning build environment"
userdel balambuild
rm *.old 2>/dev/null
cd ..
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
while [[ ! $res =~ ^[yn]$ ]]
do
	echo "Move package list file? y/n"
	read res
	res=${res,,}
done
if [[ $res == "y" ]]
then
	echo -n "Moving file "
	mv ./packages.x86_64 ./liveiso/
	checkOutput
fi
info "Fetching wordlists"
echo -n " - Creating wordlists directory"
mkdir -p ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/{passwords,discovery}
checkOutput
echo -n " - Downloading rockyou.txt.tgz"
curl https://download.weakpass.com/wordlists/90/rockyou.txt.gz > ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/passwords/rockyou.txt.gz
checkOutput
echo -n " - Downloading directory-list-2.3-big.txt"
curl https://raw.githubusercontent.com/igorhvr/zaproxy/master/src/dirbuster/directory-list-2.3-big.txt > ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/discovery/directory-list-2.3-big.txt
checkOutput
echo -n "   - Compressing"
tar -I 'gzip -9' -czf ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/discovery/directory-list-2.3-big.txt.tgz ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/discovery/directory-list-2.3-big.txt
checkOutput
echo -n " - Downloading dsstorewordlist.txt"
curl https://raw.githubusercontent.com/aels/subdirectories-discover/main/dsstorewordlist.txt > ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/discovery/dsstorewordlist.txt
checkOutput
echo -n "   - Compressing"
tar -I 'gzip -9' -czf ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/discovery/dsstorewordlist.txt.tgz ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/discovery/dsstorewordlist.txt
echo " - Cleaning up"
for file in $(find ${WORKDIR}/liveiso/airootfs/usr/share/wordlists/ -regex .+.txt$)
do
	rm $file 1>/dev/null
done
checkOutput 0

info "Injecting fixer.sh"
echo -n " - Adding to balam user"
cp "${WORKDIR}/fixer.sh" "${WORKDIR}/liveiso/airootfs/home/balam/fixer.sh"
checkOutput
echo -n " - Adding execution to i3 startup"
echo "exec_always --no-startup-id /home/balam/fixer.sh" >> ${WORKDIR}/liveiso/airootfs/home/balam/.config/i3/config

info "Injecting updater.sh"
cp "${WORKDIR}/updater.sh" "${WORKDIR}/liveiso/airootfs/usr/bin/balamos-update"
grep "UPDATER_VERSION=" "${WORKDIR}/updater.sh" | sed "s/.+='//g;s/'//g" > "${WORKDIR}/liveiso/airootfs/usr/share/balamos_lastpatch"

info "Starting building process"
sudo mkarchiso -v -r -w ${WORKDIR}/workdir -o ${WORKDIR}/out ${WORKDIR}/liveiso
cleanup