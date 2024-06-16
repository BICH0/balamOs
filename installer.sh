#!/usr/bin/env bash
################################################################################
#                                                                              #
# BalamOs-installer - Official Installer for BalamOs                           #
#                                                                              #
# OG AUTHOR  (Forked from BlackArch Installer)                                 #
# noptrix@nullsecurity.net                                                     #
#                                                                              #
################################################################################


# blackarch-installer version
VERSION='1.2.24'
VERSION2='1.0.4'
LAST_PATCH='0.0.0'

################ BASE PACKAGES #############

KERNEL_PKGS='linux-headers'
ARCH_PKGS='arch-install-scripts pkgfile'
BT_PKGS='bluez bluez-hid2hci bluez-tools bluez-utils'
BROWSER_PKGS='firefox'
EDITOR_PKGS='hexedit nano nano-syntax-highlighting neovim'
FS_PKGS='cifs-utils dmraid dosfstools exfat-utils f2fs-tools 
gpart gptfdisk mtools nilfs-utils ntfs-3g partclone parted partimage'
FONT_PKGS='ttf-dejavu ttf-indic-otf ttf-liberation xorg-fonts-misc ttf-hack ttf-hack-nerd noto-fonts-emoji'
AUDIO_PKGS='pipewire pipewire-pulse pipewire-audio pavucontrol'
MISC_PKGS='acpi alsa-utils b43-fwcutter bash-completion libnotify bc cmake ctags expac 
feh vlc gpm haveged hdparm htop inotify-tools ipython irssi 
linux-atm lsof mercurial mesa mlocate moreutils mpv p7zip rsync 
rtorrent screen scrot smartmontools strace tmux udisks2 unace unrar 
unzip upower usb_modeswitch usbutils zip man-db cargo python python-pip npm tftp-hpa'
NETWORK_PKGS='atftp bind-tools bridge-utils curl darkhttpd dhclient dhcpcd dialog
dnscrypt-proxy dnsmasq dnsutils fwbuilder gnu-netcat iw 
iwd lftp nfs-utils ntp openconnect openssh openvpn ppp pptpclient rfkill 
rp-pppoe socat vpnc wget wireless_tools wpa_supplicant wvdial xl2tpd net-tools iputils macchanger'
XORG_PKGS='alacritty xf86-video-dummy xf86-video-fbdev xf86-video-sisusb 
xf86-video-vesa xorg-server xorg-xbacklight xorg-xinit dex breeze-gtk'
AUR_PKGS='https://aur.archlinux.org/intel-opencl-runtime.git https://aur.archlinux.org/rvm.git'
################ EXTRA PACKAGES #############

DM_PKGS=('ly')
WM_PKGS=( 'i3-wm' 'polybar' 'xss-lock' 'https://aur.archlinux.org/i3lock-color.git' 'dunst' 'rofi' 'https://aur.archlinux.org/rofi-greenclip.git' 'network-manager-applet' 'ranger' 'w3m' 'flameshot')

# blackarch keyring version
BA_KEYRING="https://blackarch.org/blackarch/blackarch/os/x86_64/blackarch-keyring-20180925-5-any.pkg.tar.zst"

# grub theme
GRUB_THEME="https://github.com/BiCH0/balam-grub.git"

# path to blackarch-installer
BI_PATH='/usr/share/balamos-data'

# true / false
TRUE=0
FALSE=1

# return codes
SUCCESS=0
FAILURE=1

# verbose mode - default: quiet
VERBOSE='/tmp/balamos-install_verbose.log'

# colors
WHITE="$(tput setaf 7)"
# WHITEB="$(tput bold ; tput setaf 7)"
# BLUE="$(tput setaf 4)"
#BLUEB="$(tput bold ; tput setaf 4)"
CYAN="$(tput setaf 6)"
#CYANB="$(tput bold ; tput setaf 6)"
GREEN="$(tput setaf 2)"
# GREENB="$(tput bold ; tput setaf 2)"
PURPLE="$(tput setaf 13)"
#PURPLEB="$(tput bold ; tput setaf 13)"
RED="$(tput setaf 1)"
RED2="$(tput setaf 9)"
RED2B="$(tput bold ; tput setaf 9)"
# REDB="$(tput bold; tput setaf 1)"
YELLOW="$(tput setaf 11)"
# YELLOWB="$(tput bold ; tput setaf 3)"
BLINK="$(tput blink)"
NC="$(tput sgr0)"

# chosen locale
LOCALE=''

# set locale
SET_LOCALE='1'

# list locales
LIST_LOCALE='2'

# chosen keymap
KEYMAP=''

# set keymap
SET_KEYMAP='1'

# list keymaps
LIST_KEYMAP='2'

# network interfaces
NET_IFS=''

# chosen network interface
NET_IF=''

# network configuration mode
NET_CONF_MODE=''

# network configuration modes
NET_CONF_AUTO='1'
NET_CONF_WLAN='2'
NET_CONF_MANUAL='3'
NET_CONF_SKIP='4'

# hostname
HOST_NAME=''

# host ipv4 address
HOST_IPV4=''

# gateway ipv4 address
GATEWAY=''

# subnet mask
SUBNETMASK=''

# broadcast address
BROADCAST=''

# nameserver address
NAMESERVER=''

# DualBoot flag
DUALBOOT=''

# LUKS flag
LUKS=''

# avalable hard drive
HD_DEVS=''

# chosen hard drive device
HD_DEV=''

# Partitions
PARTITIONS=''

# partition label: gpt or dos
PART_LABEL=''

# boot partition
BOOT_PART=''

# root partition
ROOT_PART=''

# crypted root
CRYPT_ROOT='r00t'

# swap partition
SWAP_PART=''

#available fs
AVAILABLE_FS=('ext2' 'ext3' 'ext4' 'btrfs' 'zfs' 'ntfs')

#other mountpoints
DISK_MOUNTS=()

# boot fs type - default: ext4
BOOT_FS_TYPE=''

# root fs type - default: ext4
ROOT_FS_TYPE=''

# chroot directory / blackarch linux installation
CHROOT='/mnt'

# normal system user
NORMAL_USER=''

# default BlackArch Linux repository URL
#BA_REPO_URL='https://www.mirrorservice.org/sites/blackarch.org/blackarch/$repo/os/$arch'
BA_REPO_URL='https://blackarch.unixpeople.org/$repo/os/$arch'
#BA_REPO_URL='https://ftp.halifax.rwth-aachen.de/blackarch/$repo/os/$arch'

# default ArchLinux repository URL
AR_REPO_URL='https://mirror.rackspace.com/archlinux/$repo/os/$arch https://mirror.moson.org/arch/$repo/os/$arch https://archmirror.it/repos/$repo/os/$arch'

# VirtualBox setup - default: false
VBOX_SETUP=$FALSE

# VMware setup - default: false
VMWARE_SETUP=$FALSE

# BlackArch Linux tools setup - default: false
BA_TOOLS_SETUP=$TRUE

# wlan ssid
WLAN_SSID=''

# wlan passphrase
WLAN_PASSPHRASE=''

# check boot mode
BOOT_MODE=''

# check if its bios with gpt parttable
BIOS_GPT=''

#log file path
LOGFILE="/tmp/balamos-install"

# confirmation messages
CNF_MSGS=('I think you should really think about it' 'Fr fr, give it a thought' 'Im warning you brother, this is bad, not good practice' "Okay, as you wish, but i wouldn't do that" 'Nah just joking, keep trying, i have all day long' 'No, l00s3r')

# just a counter
JUST_A_COUNTER=0

# Exit on CTRL + c
clear_log(){
  grep -v -E 'BalamOs|----|... /' ${LOGFILE}.tmp > ${LOGFILE}2.tmp
  mv ${LOGFILE}2.tmp ${LOGFILE}.log
  sed -Ei 's/\x1B\[[0-9;]*[JKmsu]//g; s/\x1B\[[()]?[0-9;]*[^HJKmsu]//g; s/\x1B\[1m//g; s/\r//g' ${LOGFILE}.log
}

ctrl_c() {
  echo 
  err "Keyboard Interrupt detected, leaving..."
  clear_log
  umount_filesystems
  exit $FAILURE
}

trap ctrl_c 2

# check exit status
check()
{
  es=$1
  func="$2"
  info="$3"

  if [ "$es" -ne 0 ]
  then
    local jobs=$(jobs | grep "\[~\]")
    if [ -n "$jobs" ]
    then
      for job in $(echo "$jobs")
      do
        kill %$(echo $job cut -f1 -d"]" | cut -f2 -d"[") 2>/dev/null
      done
    fi
    echo
    warn "Something went wrong with $func. $info."
    sleep 5
    return 1
  fi
  return 0
}


# print formatted output
wprintf()
{
  fmt="${1}"

  shift
  printf "%s$fmt%s" "$WHITE" "$@" "$NC"

  return $SUCCESS
}


# print warning
warn()
{
  printf "%s[!] WARNING: %s%s\n" "$YELLOW" "$@" "$NC"

  return $SUCCESS
}


# print error and return failure
err()
{
  printf "%s[-] ERROR: %s%s\n" "$RED" "$@" "$NC"
  sleep 5
  return $FAILURE
}

# leet banner (very important, very 1337)
banner()
{
  columns="$(tput cols)"
  str="--==[ BalamOs Linux v$VERSION2 ($VERSION) ]==--"

  printf "${RED}%*s${NC}\n" "$columns" | tr ' ' '-'

  echo "$str" |
  while IFS= read -r line
  do
    printf "%s%*s\n%s" "$RED2B" $(( (${#line} + columns) / 2)) \
      "$line" "$NC"
  done

  printf "${RED}%*s${NC}\n\n" "$columns" | tr ' ' '-'

  return $SUCCESS
}


# check boot mode
check_boot_mode()
{
  ls /sys/firmware/efi/efivars > /dev/null 2>&1
  if [ $? -eq "0" ]
  then
     BOOT_MODE="uefi"
  fi

  return $SUCCESS
}

# draw a dynamic multi column menu
menu_draw(){
  local list=($*)
  local count=0
  local maxlen=0
  local entry
  local whitespace
  for entry in ${list[@]}
  do
    if [ ${#entry} -gt $maxlen ]
    then
      maxlen=${#entry}
    fi
  done
  local colnum=$(( $(tput cols) / $(($maxlen+5)) ))
  for entry in ${list[@]}
  do
    whitespace=""
    while [ $((${#entry} + ${#whitespace})) -lt $maxlen ]
    do
      whitespace=$whitespace" "
    done
    if [ "$count" -lt $colnum ]
    then
      echo -n "$entry$whitespace  "
      ((count++))
    else
      echo $entry
      count=0
    fi
  done
}

# confirm user inputted yYnN
confirm()
{
  header="$1"
  ask="$2"
  default="$3"
  while true
  do
    title "$header"
    wprintf "$ask"
    read -r input
    input=${input,,}
    if [[ -z $input ]]
    then
      input=$default
    fi
    case $input in
      y|yes) return $TRUE ;;
      n|no) return $FALSE ;;
      *) clear ; continue ;;
    esac
  done

  return $SUCCESS
}

install_keyrings()
{
  pacman -Syy --noconfirm archlinux-keyring blackarch-keyring
  check $? 'installing keyring'
  if [ "$?" -ne 0 ]
  then
    err "The installer couldn't install the keyrings"
    exit
  else
    clear
  fi
}


# print menu title
title()
{
  clear
  banner
  printf "${PURPLE}>> %s${NC}\n\n\n" "${@}"

  return "${SUCCESS}"
}


# check for environment issues
check_env()
{
  if [ -f '/var/lib/pacman/db.lck' ]
  then
    err 'pacman locked - Please remove /var/lib/pacman/db.lck'
  fi
}


# check user id
check_uid()
{
  if [ "$(id -u)" != '0' ]
  then
    err 'You must be root to run the installer!'
    exit 1
  fi

  return $SUCCESS
}

animation(){
  if [ "$VERBOSE" == "/dev/stdout" ]
  then
    return
  fi
  local animation=("|" "/" "-" "\\")
  local delay=0.1
  while true
  do
    for frame in "${animation[@]}"; do
          printf "\r[~] %s... %s" "$1" "$frame"
          sleep "$delay"
    done
  done
}

kill_job(){
  if [ "$VERBOSE" == '/dev/stdout' ]
  then
    return 0
  fi
  local jobid=$(jobs | grep "animation \"$1" | cut -f1 -d"]" | cut -f2 -d"[")
  if [ -n "$jobid" ]
  then
    local lin
    for lin in "$jobid"
    do
      echo "Killing animation at %$jobid" >> $VERBOSE
      kill %$jobid
    done
  fi
  echo "Running jobs:" >> $VERBOSE
  jobs >> $VERBOSE
}

dependency_parser(){
  echo "[+] Parsing dependencies"
  local mainPkg=""
  if [ -n "$2" ]
  then
    mainPkg=$2
  fi
  if [ ! -f "$1/PKGBUILD" ]
  then
	  return 1
  fi
  local line
  local rl=0
  local dependencies=()
  while read line
  do
	  case "${line%%(*}" in
      "depends=")
      ;&
      "optdepends=")
      ;&
      "makedepends=")
        if [ -n "${line##*(}" ]
        then
          for dep in $(echo ${line##*(} | sed -E "s/:[a-zA-Z0-9\ -]+/'/g" | cut -f1 -d")")
          do
            dep=${dep//\'/}
            if [[ $dep =~ [\>\=] ]]
            then
                dep=\"$dep\"
            fi
            dependencies+=($dep)
          done
          rl=0
        else
          rl=1
        fi
      ;;
      ")")
        rl=0
      ;;
      *)
        if [ "$rl" -eq 1 ]
        then
          if [[ ! $line =~ [\>\=] ]]
          then
                line=${line//\'/}
          fi
          dependencies+=(${line%:*})
        fi
    esac
  done < "$1/PKGBUILD"
  animation "Installing dependencies" &
  echo "[DEPENDENCIES of $mainPkg]: ${dependencies[*]}" >> $VERBOSE
  local out=$(chroot $CHROOT pacman -Sy ${dependencies[*]} --needed --noconfirm 2>&1)
  kill_job "Installing"
  out=$(echo "$out" | grep "target not found" | cut -f3 -d: | sed 's/ //g;')
  if [ -n "$mainPkg" ] && [ "$(echo "$out" | grep -v $mainPkg)" != "$out" ]
  then
    err "Dependency cycle detected, skipping ${1##*/}"
    return 1
  fi
  echo "[MISSING DEPENDENCIES]: $out" >> $VERBOSE
  if [ -n "$out" ]
  then
	  local ecode=0
    for pkg in $(echo "$out")
    do
      chroot $CHROOT pacman -Q $pkg &>/dev/null && continue
      rm -rf $CHROOT/tmp/$pkg
      git_build $pkg https://aur.archlinux.org/$pkg.git $mainPkg
      if [ $? -ne 0 ]
      then
        ecode=$?
      fi
      dependencies=("${dependencies[@]/$pkg}")
    done
    if [ $ecode -eq 0 ]
    then
      animation "Installing dependencies" &
      chroot $CHROOT pacman -Sy ${dependencies[*]} --needed --noconfirm >> $VERBOSE 2>&1
      ecode=$?
      kill_job "Installing"
      return $ecode
    fi
  fi
  return 0
}

git_build(){
  local mainPkg="$1"
  if [ -n "$3" ]
  then
    mainPkg=$3
  fi
  local build_path="/tmp/$1"
  echo "[+] Downloading $1"
  chroot $CHROOT su $NORMAL_USER -c "git clone $2 $build_path" >> $VERBOSE 2>&1
  echo "[+] Looking for keys"
  if [ -n "$(grep validpgpkeys $CHROOT/$build_path/PKGBUILD)" ]
  then
    local validKeys=$(grep validpgpkeys $CHROOT/$build_path/PKGBUILD | sed -E 's/.+\(//g;s/\).+//g')
    if [ -z "$validKeys" ]
    then
      local readLine=0
      for line in $(cat $CHROOT/$build_path/PKGBUILD)
      do
        if [ "$line" == "validpgpkeys=(" ]
        then
          readLine=1
        elif [ "$line" == ")" ]
        then
          readLine=0
        else
          if [ $readLine -eq 1 ]
          then
            validKeys+="${line//\'/} "
          fi
        fi
      done
    fi
    echo "[+] Installing keys"
    chroot $CHROOT su $NORMAL_USER -c "gpg --recv-keys $validKeys" >> $VERBOSE 2>&1
  fi
  animation "Building $1" &
  chroot $CHROOT su $NORMAL_USER -c "cd $build_path && makepkg --noconfirm" >> $VERBOSE 2>&1
  ecode=$?
  kill_job "Building"
  if [ "$ecode" -ne 0 ]
  then
    printf "\r[~] %s ${RED}[ERR]${NC}  \n" "Building $1"
    if [ "$ecode" -eq 8 ]
    then
      dependency_parser "$CHROOT/$build_path" "$mainPkg"
      if [ $? -eq 0 ]
      then
        animation "Rebuilding $1" &
        chroot $CHROOT su $NORMAL_USER -c "cd $build_path && makepkg --noconfirm" >> $VERBOSE 2>&1
        kill_job "Rebuilding"
      else
        err "Failed to build $1"
        return 1
      fi
    else
      err "Failed to build $1"
      return 1
    fi
  else
    printf "\r[~] %s ${GREEN}[OK]${NC}  \n" "Building $1"
  fi
  animation "Installing $1" &
  local file_path=$(chroot $CHROOT sh -c "find $build_path -regex '.*\.pkg\.tar\.zst' | sort | head -1")
  chroot $CHROOT sh -c "pacman -U $file_path --noconfirm --needed" >> $VERBOSE 2>&1
  kill_job "Installing"
  printf "\r[~] %s ${GREEN}[OK]${NC}  \n" "Installing $1"
  return 0
}

print_pkgs(){
  printf "\n"
  for pkg in $*
  do
    echo "      - ${pkg##*/}"
  done
}

# ask for output mode
ask_output_mode()
{
  title 'Environment > Output Mode'
  wprintf '[+] Available output modes:'
  printf "\n
  1. Quiet (default)
  2. Verbose (output of system commands: mkfs, pacman, etc.)\n\n"
  wprintf "[?] Make a choice: "
  read -r output_opt
  if [ "$output_opt" = 2 ]
  then
    VERBOSE='/dev/stdout'
  fi

  return $SUCCESS
}


# ask for locale to use
ask_locale()
{
  while [ "$locale_opt" != "$SET_LOCALE" ] && \
    [ "$locale_opt" != "$LIST_LOCALE" ]
  do
    title 'Environment > Locale Setup'
    wprintf '[+] Available locale options:'
    printf "\n
  1. Set a locale
  2. List available locales\n\n"
    wprintf "[?] Make a choice: "
    read -r locale_opt
    if [ "$locale_opt" = "$SET_LOCALE" ]
    then
      break
    elif [ "$locale_opt" = "$LIST_LOCALE" ]
    then
      menu_draw $(tail +$(grep -nE '^#$' -m50 /etc/locale.gen | tail -1 | cut -f1 -d:) /etc/locale.gen | sed 's/\#//g')
      echo
      read smtg
    else
      continue
    fi
  done

  return $SUCCESS
}


# set locale to use
set_locale()
{
  title 'Environment > Locale Setup'
  wprintf '[?] Set locale [en_US.UTF-8]: '
  read -r LOCALE

  # default locale
  if [ -z "$LOCALE" ]
  then
    echo
    warn 'Setting default locale: en_US.UTF-8'
    sleep 1
    LOCALE='en_US.UTF-8'
  fi
  localectl set-locale "LANG=$LOCALE"
  check $? 'setting locale'
  if [ "$?" -ne 0 ]
  then
    set_locale
  fi
  return $SUCCESS
}


# ask for keymap to use
ask_keymap()
{
  while [ "$keymap_opt" != "$SET_KEYMAP" ] && \
    [ "$keymap_opt" != "$LIST_KEYMAP" ]
  do
    title 'Environment > Keymap Setup'
    wprintf '[+] Available keymap options:'
    printf "\n
  1. Set a keymap
  2. List available keymaps\n\n"
    wprintf '[?] Make a choice: '
    read -r keymap_opt

    if [ "$keymap_opt" = "$SET_KEYMAP" ]
    then
      break
    elif [ "$keymap_opt" = "$LIST_KEYMAP" ]
    then
      menu_draw $(localectl list-keymaps)
      echo
      read smtg
    else
      continue
    fi
  done
  return $SUCCESS
}


# set keymap to use
set_keymap()
{
  title 'Environment > Keymap Setup'
  wprintf '[?] Set keymap [us]: '
  read -r KEYMAP

  # default keymap
  if [ -z "$KEYMAP" ]
  then
    echo
    warn 'Setting default keymap: us'
    sleep 1
    KEYMAP='us'
  fi
  localectl set-keymap --no-convert "$KEYMAP"
  check $? 'setting keymap'
  if [ "$?" -ne 0 ]
  then
    clear
    set_keymap
  fi
  setxkbmap $KEYMAP 2>/dev/null
  loadkeys "$KEYMAP" >> $VERBOSE 2>&1
  return $SUCCESS
}


# enable multilib in pacman.conf if x86_64 present
enable_pacman_multilib()
{
  path="$1"

  if [ "$path" = 'chroot' ]
  then
    path="$CHROOT"
  else
    path=""
  fi

  title 'Pacman Setup > Multilib'

  if [ "$(uname -m)" = "x86_64" ]
  then
    wprintf '[+] Enabling multilib support'
    printf "\n\n"
    if grep -q "#\[multilib\]" "$path/etc/pacman.conf"
    then
      # it exists but commented
      sed -i '/\[multilib\]/{ s/^#//; n; s/^#//; }' "$path/etc/pacman.conf"
    elif ! grep -q "\[multilib\]" "$path/etc/pacman.conf"
    then
      # it does not exist at all
      printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" \
        >> "$path/etc/pacman.conf"
    fi
  fi

  return $SUCCESS
}


# enable color mode in pacman.conf
enable_pacman_color()
{
  path="$1"

  if [ "$path" = 'chroot' ]
  then
    path="$CHROOT"
  else
    path=""
  fi

  title 'Pacman Setup > Color'

  wprintf '[+] Enabling color mode'
  printf "\n\n"

  sed -i 's/^#Color/Color/' "$path/etc/pacman.conf"

  return $SUCCESS
}


# enable misc options in pacman.conf
enable_pacman_misc()
{
  path="$1"

  if [ "$path" = 'chroot' ]
  then
    path="$CHROOT"
  else
    path=""
  fi

  title 'Pacman Setup > Misc Options'

  wprintf '[+] Enabling DisableDownloadTimeout'
  printf "\n\n"
  sed -i '37a DisableDownloadTimeout' "$path/etc/pacman.conf"

  # put here more misc options if necessary

  return $SUCCESS
}


# update pacman package database
update_pkg_database()
{
  title 'Pacman Setup > Package Database'

  wprintf '[+] Updating pacman database'
  printf "\n\n"
  animation "Updating database" &
  pacman -Syy --noconfirm >> $VERBOSE 2>&1
  check $? "pacman database update"
  ecode=$?
  kill %1 2>/dev/null
  if [ $ecode -ne 0 ]
  then
    clear_log
    exit 1
  fi
  return $SUCCESS
}


# update pacman.conf and database
update_pacman()
{
  enable_pacman_multilib
  enable_pacman_color
  enable_pacman_misc
  update_pkg_database

  return $SUCCESS
}


# ask user for hostname
ask_hostname()
{
  while [ -z "$HOST_NAME" ] || [[ ! $HOST_NAME =~ ^[a-zA-Z0-9]{3,}$ ]]
  do
    title 'Network Setup > Hostname'
    wprintf '[?] Set your hostname: '
    read -r HOST_NAME
  done

  return $SUCCESS
}

# get available network interfaces
get_net_ifs()
{
  NET_IFS="$(ip -o link show | awk -F': ' '{print $2}' |grep -v 'lo')"

  return $SUCCESS
}


# ask user for network interface
ask_net_if()
{
  while true
  do
    title 'Network Setup > Network Interface'
    wprintf '[+] Available network interfaces:'
    printf "\n\n"
    i=1
    local ifs=('none')
    for iface in $NET_IFS
    do
      echo "    $i. $iface"
      ifs+=($iface)
      ((i++))
    done
    printf "\n"
    wprintf '[?] Please choose a network interface (default: 1): '
    read -r NET_IF
    if [ -z "$NET_IF" ]
    then
      NET_IF=1
    fi
    NET_IF=${ifs[$NET_IF]}
    if echo "$NET_IFS" | grep "\<$NET_IF\>" > /dev/null
    then
      break
    fi
  done

  return $SUCCESS
}


# ask for networking configuration mode
ask_net_conf_mode()
{
  while [ "$NET_CONF_MODE" != "$NET_CONF_AUTO" ] && \
    [ "$NET_CONF_MODE" != "$NET_CONF_WLAN" ] && \
    [ "$NET_CONF_MODE" != "$NET_CONF_MANUAL" ] && \
    [ "$NET_CONF_MODE" != "$NET_CONF_SKIP" ]
  do
    title 'Network Setup > Network Interface'
    wprintf '[+] Network interface configuration:'
    printf "\n
  1. Auto DHCP (use this for auto connect via dhcp on selected interface)
  2. WiFi WPA Setup (use if you need to connect to a wlan before)
  3. Manual (use this if you are 1337)
  4. Skip (use this if you are already connected)\n\n"
    wprintf "[?] Please choose a mode: "
    read -r NET_CONF_MODE
  done

  return $SUCCESS
}


# ask for network addresses
ask_net_addr()
{
  while [ "$HOST_IPV4" = "" ] || \
    [ "$GATEWAY" = "" ] || [ "$SUBNETMASK" = "" ] || \
    [ "$BROADCAST" = "" ] || [ "$NAMESERVER" = "" ]
  do
    title 'Network Setup > Network Configuration (manual)'
    wprintf "[+] Configuring network interface $NET_IF via USER: "
    printf "\n
  > Host ipv4
  > Gateway ipv4
  > Subnetmask
  > Broadcast
  > Nameserver
    \n"
    wprintf '[?] Host IPv4: '
    read -r HOST_IPV4
    wprintf '[?] Gateway IPv4: '
    read -r GATEWAY
    wprintf '[?] Subnetmask: '
    read -r SUBNETMASK
    wprintf '[?] Broadcast: '
    read -r BROADCAST
    wprintf '[?] Nameserver: '
    read -r NAMESERVER
  done

  return $SUCCESS
}


# manual network interface configuration
net_conf_manual()
{
  title 'Network Setup > Network Configuration (manual)'
  wprintf "[+] Configuring network interface '$NET_IF' manually: "
  printf "\n\n"

  ip addr flush dev "$NET_IF"
  ip link set "$NET_IF" up
  ip addr add "$HOST_IPV4/$SUBNETMASK" broadcast "$BROADCAST" dev "$NET_IF"
  ip route add default via "$GATEWAY"
  echo "nameserver $NAMESERVER" > /etc/resolv.conf

  return $SUCCESS
}


# auto (dhcp) network interface configuration
net_conf_auto()
{
  opts='-h noleak -i noleak -v ,noleak -I noleak -t 10'

  title 'Network Setup > Network Configuration (auto)'
  wprintf "[+] Configuring network interface '$NET_IF' via DHCP: "
  printf "\n\n"

  dhcpcd "$opts" -i "$NET_IF" >> $VERBOSE 2>&1

  sleep 10

  return $SUCCESS
}


# ask for wlan data (ssid, wpa passphrase, etc.)
ask_wlan_data()
{
  while [ "$WLAN_SSID" = "" ] || [ "$WLAN_PASSPHRASE" = "" ]
  do
    title 'Network Setup > Network Configuration (WiFi)'
    wprintf "[+] Configuring network interface $NET_IF via W-LAN + DHCP: "
    printf "\n
  > W-LAN SSID
  > WPA Passphrase (will not echo)
    \n"
    wprintf "[?] W-LAN SSID: "
    read -r WLAN_SSID
    wprintf "[?] WPA Passphrase: "
    read -rs WLAN_PASSPHRASE
  done

  return $SUCCESS
}


# wifi and auto dhcp network interface configuration
net_conf_wlan()
{
  wpasup="$(mktemp)"
  dhcp_opts='-h noleak -i noleak -v ,noleak -I noleak -t 10'

  title 'Network Setup > Network Configuration (WiFi)'
  wprintf "[+] Configuring network interface $NET_IF via W-LAN + DHCP: "
  printf "\n\n"

  wpa_passphrase "$WLAN_SSID" "$WLAN_PASSPHRASE" > "$wpasup"
  wpa_supplicant -B -c "$wpasup" -i "$NET_IF" >> $VERBOSE 2>&1

  warn 'We need to wait a bit for wpa_supplicant and dhcpcd'

  sleep 10

  dhcpcd "$dhcp_opts" -i "$NET_IF" >> $VERBOSE 2>&1

  sleep 10

  return $SUCCESS
}


# check for internet connection
check_inet_conn()
{
  title 'Network Setup > Connection Check'
  wprintf '[+] Checking for Internet connection...'

  if ! curl -s http://www.yahoo.com/ >> $VERBOSE
  then
    err 'No Internet connection! Check your network (settings).'
    exit $FAILURE
  fi

}


# ask user for dualboot install
ask_dualboot()
{
  while [ "$DUALBOOT" = '' ]
  do
    if confirm 'Hard Drive Setup > DualBoot' '[?] Install BalamOs with Windows/Other OS [y/n]: '
    then
      DUALBOOT=$TRUE
    else
      DUALBOOT=$FALSE
    fi
  done
  return $SUCCESS
}


# ask user for luks encrypted partition
ask_luks()
{
  while [ "$LUKS" = '' ]
  do
    if confirm 'Hard Drive Setup > Crypto' '[?] Full encrypted root [y/N]: ' 'n'
    then
      LUKS=$TRUE
    else
      LUKS=$FALSE
      echo
      warn 'The root partition will NOT be encrypted'
      sleep 2
    fi
  done
  return $SUCCESS
}


# get available hard disks
get_hd_devs()
{
  HD_DEVS=$(lsblk | grep disk | awk '{print $1}')
  return $SUCCESS
}

#pretty padding
gen_padding(){
   local items=$*
   local max_size=0;
   for item in $items
   do
    local item_size=${#item}
    if [ $item_size -gt $max_size ]
    then
      max_size=$item_size
    fi
   done
   local parsed_items=()
   for item in $items
   do
    local parsed_item=$item
    while [ ${#parsed_item} -lt $max_size ]
    do
      parsed_item="${parsed_item};"
    done
    parsed_items+=($parsed_item)
   done
   echo ${parsed_items[@]}
}

# ask user for device to format and setup
ask_hd_dev()
{
  while true
  do
    title 'Hard Drive Setup'

    wprintf '[+] Available hard drives for installation:'
    printf "\n\n"
    i=1
    local padded_devs=$(gen_padding $HD_DEVS)
    for dev in $padded_devs
    do
      dev=${dev//;/ }
      local diskinfo="$(fdisk -l /dev/${dev// /} | head -2)"
      local disksize=$(echo "$diskinfo" | head -1 | awk '{gsub(",", ".", $3); sub(/,.*$/, "", $3); print $3,$4}')
      local diskmodel=$(echo "$diskinfo" | tail -1 | cut -f2 -d: | tr -s " ")
      echo "    ${i}. $dev  ${disksize::-1} (${diskmodel:1:-1})"
      ((i++))
    done
    echo
    wprintf '[?] Please choose the drive where / should be created (Default: 1): '
    read -r HD_DEV
    if [ -z "$HD_DEV" ]
    then
      HD_DEV=1
    fi
    HD_DEV=$(echo $HD_DEVS | cut -f$HD_DEV -d' ')
    if echo "$HD_DEVS" | grep "\<$HD_DEV\>" > /dev/null
    then
      NROOT_DEVS=()
      for dev in $HD_DEVS
      do
        if [ $dev != $HD_DEV ]
        then
          NROOT_DEVS+=($dev)
        fi
      done
      title 'Hard Drive Setup > Other drives'
      wprintf '[+] Other available hard drives'
      echo 
      if [ "${#NROOT_DEVS[@]}" -gt 0 ]
      then
        c=1
        echo
        for dev in $NROOT_DEVS
        do
          echo "   > $c.$dev"
          ((c++))
        done
        echo "   > 0.None"
        echo
        wprintf '[?] Choose which drives will you want to use for other mountpoints (Example: 1 3 4): '
        read -r NROOT_CHOSEN
        while [[ -z $NROOT_CHOSEN ]]
        do
          read -r NROOT_CHOSEN
        done
        if [ $NROOT_CHOSEN -eq 0 ]
        then
          NROOT_DEVS=()
        else
          for i in $NROOT_CHOSEN
          do
            NROOT_DEVS=("${NROOT_DEVS[@]/$NROOT_DEVS[$i]}")
          done
        fi
      fi
      HD_DEV="/dev/$HD_DEV"
      break
    fi
  done
  return $SUCCESS
}

# get available partitions on hard drive
get_partitions()
{
  local disk=$1
  echo $(fdisk -l $disk -o device,size,type | \
    grep "${disk}[[:alnum:]]" |awk '{print $1;}')
}

noroot_disks(){
  for disk in $NROOT_DEVS
  do
    local dev_partitions=$(get_partitions /dev/$disk)
    if confirm 'Hard Drive Setup > Partitions' "[?] Create partitions with cfdisk on $disk [Y/n]: " 'y'
    then
      zero_part /dev/$disk
    else
      if [ -z "$dev_partitions" ]
      then
        continue
      fi
    fi
    for partition in $dev_partitions
    do
      sure=""
      until [ "$sure" == "y" ]
      do
        title "Hard Drive Setup > Partition ${partition##*/} ($(numfmt --to=iec-i --suffix=B $(lsblk -b -o SIZE -n $partition)))"
        wprintf '[?] Select a mountpoint por this partition (leave empty to left it unmounted): '
        read -r mountpoint
        echo
        warn "FORMATTING IT WILL ERASE ALL DATA IN THE PARTITION"
        filesystem="1337"
        while [[ ! " ${AVAILABLE_FS[@]} " =~ " $filesystem " ]] && [ ! -z "$filesystem" ]
        do
          wprintf "[?] Select a fs or leave it empty to skip (${AVAILABLE_FS[*]}): "
          read -r filesystem
        done
        echo 
        echo "Partition: $partition ($filesystem) -> $mountpoint"
        wprintf "[?] Is this correct? y/n: "
        read -r sure
        sure=${sure,,}
      done
      if [ -z $filesystem ]
      then
        if [ -z $mountpoint ]
        then
          continue
        fi
      else 
        if confirm "Hard Drive Setup > Partitions ${partition}" "[?] Format partition? All data will be erased [y/n]: "
        then
          nroot_format $partition $filesystem
        else
          continue
        fi
      fi
      DISK_MOUNTS+=("$partition.$mountpoint")
    done
  done
}

# ask user to create partitions using cfdisk
ask_cfdisk()
{
  if confirm 'Hard Drive Setup > Partitions' '[?] Create partitions with cfdisk (root and boot, optional swap) [Y/n]: ' 'y'
  then
    zero_part $HD_DEV
  else
    echo
    warn 'No partitions chosed? Make sure you have them already configured.'
    PARTITIONS=$(get_partitions $HD_DEV)
  fi

  return $SUCCESS
}


# zero out partition if needed/chosen
zero_part()
{
  local disk=$1;
  local zeroed_part=0;
  if confirm 'Hard Drive Setup' '[?] Start with an in-memory zeroed partition table [y/N]: ' 'n'
  zeroed_part=1;
  then
    cfdisk -z "$disk"
    sync
  else
    cfdisk "$disk"
    sync
  fi
  local partitions=$(get_partitions);
  if [ ${#partitions[@]} -eq 0 ] && [ $zeroed_part -eq 1 ] ; then
    err 'You have not created partitions on your disk, make sure to write your changes before quiting cfdisk. Trying again...'
    sleep 2
    zero_part $disk
  fi
  local partinfo=$(fdisk -l "$HD_DEV" -o type)
  if [ -z "$BOOT_MODE" ] && echo $partinfo | grep -i ": gpt"; then
    BIOS_GPT=$TRUE
  fi
  if [ "$disk" == "$HD_DEV" ]
  then
    PARTITIONS=$partitions
    if [ "$BOOT_MODE" = 'uefi' ] && ! echo $partinfo | grep -i 'EFI' ; then
      title 'Hard Drive Setup > Partitions'
      err 'You are booting in UEFI mode but not EFI partition was created, make sure you select the "EFI System" type for your EFI partition.'
      sleep 4
      zero_part $disk
    elif ! echo $partinfo | grep -i "BIOS" && [ "$BIOS_GPT" == $TRUE ]; then
      title 'Hard Drive Setup > Partitions'
      err 'You are booting in BIOS mode but no BIOS partition was created, make sure to select the "BIOS boot" type for your BIOS partition.'
      sleep 4
      zero_part $disk
    fi
  fi
  return $SUCCESS
}


# get partition label
get_partition_label()
{
  PART_LABEL="$(fdisk -l "$HD_DEV" |grep "Disklabel" | awk '{print $3;}')"

  return $SUCCESS
}


# get partitions
ask_partitions()
{
  while [ "$BOOT_PART" = '' ] || \
    [ "$ROOT_PART" = '' ] || \
    [ "$BOOT_FS_TYPE" = '' ] || \
    [ "$ROOT_FS_TYPE" = '' ]
  do
    title 'Hard Drive Setup > Partitions'
    wprintf '[+] Created partitions:'
    printf "\n\n"

    fdisk -l "${HD_DEV}" -o device,size,type |grep "${HD_DEV}[[:alnum:]]"

    echo

    if [ "$BOOT_MODE" = 'uefi' ]  && [ "$PART_LABEL" = 'gpt' ]
    then
      while [ -z "$BOOT_PART" ]; do
        wprintf "[?] EFI System partition (${HD_DEV}X): "
        read -r BOOT_PART
        until [[ "$PARTITIONS" =~ $BOOT_PART ]]; do
          wprintf "[?] Your partition $BOOT_PART is not in the partitions list.\n"
          wprintf "[?] EFI System partition (${HD_DEV}X): "
          read -r BOOT_PART
        done
      done
      BOOT_FS_TYPE="fat32"
    else
      while [ -z "$BOOT_PART" ]; do
        wprintf "[?] Boot partition (${HD_DEV}X): "
        read -r BOOT_PART
        until [[ "$PARTITIONS" =~ $BOOT_PART ]]; do
          wprintf "[?] Your partition $BOOT_PART is not in the partitions list.\n"
          wprintf "[?] Boot partition (${HD_DEV}X): "
          read -r BOOT_PART
        done
      done
      #TODO if bios/gpt remove this
      wprintf '[?] Choose a filesystem to use in your boot partition (ext2, ext3, ext4)? (default: ext4): '
      read -r BOOT_FS_TYPE
      if [ -z "$BOOT_FS_TYPE" ]; then
        BOOT_FS_TYPE="ext4"
      fi
    fi
    while [ -z "$ROOT_PART" ]; do
      wprintf "[?] Root partition (${HD_DEV}X): "
      read -r ROOT_PART
      until [[ "$PARTITIONS" =~ $ROOT_PART ]]; do
          wprintf "[?] Your partition $ROOT_PART is not in the partitions list.\n"
          wprintf "[?] Root partition (${HD_DEV}X): "
          read -r ROOT_PART
      done
    done
    wprintf '[?] Choose a filesystem to use in your root partition (ext2, ext3, ext4, btrfs)? (default: ext4): '
    read -r ROOT_FS_TYPE
    if [ -z "$ROOT_FS_TYPE" ]; then
      ROOT_FS_TYPE="ext4"
    fi
    wprintf "[?] Swap partition (${HD_DEV}X - empty for none): "
    read -r SWAP_PART
    if [ -n "$SWAP_PART" ]; then
        until [[ "$PARTITIONS" =~ $SWAP_PART ]]; do
          wprintf "[?] Your partition $SWAP_PART is not in the partitions list.\n"
          wprintf "[?] Swap partition (${HD_DEV}X): "
          read -r SWAP_PART
        done
    fi

    if [ "$SWAP_PART" = '' ]
    then
      SWAP_PART='none'
    fi
  done

  return $SUCCESS
}


# print partitions and ask for confirmation
print_partitions()
{
  i=""

  while true
  do
    title 'Hard Drive Setup > Partitions'
    wprintf '[+] Current Partition table'
    printf "\n
  > /boot   : %s (%s)
  > /       : %s (%s)
  > swap    : %s (swap)
  \n" "$BOOT_PART" "$BOOT_FS_TYPE" \
      "$ROOT_PART" "$ROOT_FS_TYPE" \
      "$SWAP_PART"
    #ALL DISK PARTITIONS
    wprintf '[?] Partition table correct [y/n]: '
    read -r i
    if [ "$i" = 'y' ] || [ "$i" = 'Y' ]
    then
      break
    elif [ "$i" = 'n' ] || [ "$i" = 'N' ]
    then
      echo ""
      err 'Hard Drive Setup aborted.'
      BOOT_PART=''
      ROOT_PART=''
      BOOT_FS_TYPE=''
      ROOT_FS_TYPE=''
      ask_partitions
    else
      continue
    fi
  done

  return $SUCCESS
}


# ask user and get confirmation for formatting
ask_formatting()
{
  if confirm 'Hard Drive Setup > Partition Formatting' '[?] Formatting partitions. Are you sure? No crying afterwards? [y/n]: '
  then
    return $SUCCESS
  else
    echo ""
    err 'Seriously? No formatting no fun!'
    err 'Please format to continue or CTRL + c to cancel...'
    sleep 2
    ask_formatting
  fi

}


# create LUKS encrypted partition
make_luks_partition()
{
  part="$1"

  title 'Hard Drive Setup > Partition Creation (crypto)'

  wprintf '[+] Creating LUKS partition'
  printf "\n\n"

  cryptsetup -q -y -v --type luks2 luksFormat "$part" \
    >> $VERBOSE 2>&1 || { err 'Could not LUKS format, trying again.'; sleep 4; make_luks_partition "$@"; }

}


# open LUKS partition
open_luks_partition()
{
  part="$1"
  name="$2"

  title 'Hard Drive Setup > Partition Creation (crypto)'

  wprintf '[+] Opening LUKS partition'
  printf "\n\n"
  cryptsetup open "$part" "$name" >> $VERBOSE 2>&1 ||
    { err 'Could not open LUKS device, please try again and make sure that your password is correct.'; open_luks_partition "$@"; }

}


# create swap partition
make_swap_partition()
{
  title 'Hard Drive Setup > Partition Creation (swap)'

  wprintf '[+] Creating SWAP partition'
  printf "\n\n"
  mkswap $SWAP_PART >> $VERBOSE 2>&1 || { err 'Could not create filesystem'; exit $FAILURE; }

}


# make and format root partition
make_root_partition()
{
  if [ $LUKS = $TRUE ]
  then
    make_luks_partition "$ROOT_PART"
    open_luks_partition "$ROOT_PART" "$CRYPT_ROOT"
    title 'Hard Drive Setup > Partition Creation (root crypto)'
    wprintf '[+] Creating encrypted ROOT partition'
    printf "\n\n"
    if [ "$ROOT_FS_TYPE" == 'btrfs' ]
    then
      mkfs.$ROOT_FS_TYPE -f "/dev/mapper/$CRYPT_ROOT" >> $VERBOSE 2>&1 ||
        { err 'Could not create filesystem'; exit $FAILURE; }
    else
      mkfs.$ROOT_FS_TYPE -F "/dev/mapper/$CRYPT_ROOT" >> $VERBOSE 2>&1 ||
        { err 'Could not create filesystem'; exit $FAILURE; }
    fi
  else
    title 'Hard Drive Setup > Partition Creation (root)'
    wprintf '[+] Creating ROOT partition'
    printf "\n\n"
    if [ "$ROOT_FS_TYPE" == 'btrfs' ]
    then
      mkfs.$ROOT_FS_TYPE -f "$ROOT_PART" >> $VERBOSE 2>&1 ||
        { err 'Could not create filesystem'; exit $FAILURE; }
    else
      mkfs.$ROOT_FS_TYPE -F "$ROOT_PART" >> $VERBOSE 2>&1 ||
        { err 'Could not create filesystem'; exit $FAILURE; }
    fi
  fi

  return $SUCCESS
}


# make and format boot partition
make_boot_partition()
{
  title 'Hard Drive Setup > Partition Creation (boot)'

  wprintf '[+] Creating BOOT partition'
  printf "\n\n"
  if [ "$BOOT_MODE" = 'uefi' ] && [ "$PART_LABEL" = 'gpt' ]
  then
    mkfs.fat -F32 "$BOOT_PART" >> $VERBOSE 2>&1 ||
      { err 'Could not create filesystem'; exit $FAILURE; }
  else
    if [ ! $BIOS_GPT == $TRUE ]
    then
      mkfs.$BOOT_FS_TYPE -F "$BOOT_PART" >> $VERBOSE 2>&1 ||
      { err 'Could not create filesystem'; exit $FAILURE; }
    fi
  fi

  return $SUCCESS
}

nroot_format(){
  local part=$1
  local fstype=$2
  title "Hard Drive Setup > Partition Creation ($part)"
  if [ "$ROOT_FS_TYPE" = 'btrfs' ]
    then
      mkfs.$fstype -f "$part" >> $VERBOSE 2>&1 ||
        { err 'Could not create filesystem'; exit $FAILURE; }
    else
      mkfs.$fstype -F "$part" >> $VERBOSE 2>&1 ||
        { err 'Could not create filesystem'; exit $FAILURE; }
    fi
  return $SUCCESS
}


# make and format partitions
make_partitions()
{
  make_boot_partition
  make_root_partition

  if [ "$SWAP_PART" != "none" ]
  then
    make_swap_partition
  fi
  return $SUCCESS
}


# mount filesystems
mount_filesystems()
{
  title 'Hard Drive Setup > Mount'

  wprintf '[+] Mounting filesystems'
  printf "\n\n"

  # ROOT
  if [ $LUKS = $TRUE ]; then
    if ! mount "/dev/mapper/$CRYPT_ROOT" $CHROOT; then
      err "Error mounting root filesystem, leaving."
      exit $FAILURE
    fi
  else
    if ! mount "$ROOT_PART" $CHROOT; then
      err "Error mounting root filesystem, leaving."
      exit $FAILURE
    fi
  fi

  # BOOT
  mkdir "$CHROOT/boot" >> $VERBOSE 2>&1
  local mpoint="$CHROOT/boot"
  # if [ $BOOT_MODE == "uefi" ]
  # then
  #   mpoint="${mpoint}/efi"
  #   mkdir -p $mpoint
  # fi
  if ! mount "$BOOT_PART" "$mpoint"; then
    err "Error mounting boot partition, leaving."
    exit $FAILURE
  fi

  # SWAP
  if [ "$SWAP_PART" != "none" ]
  then
    swapon $SWAP_PART >> $VERBOSE 2>&1
  fi

  return $SUCCESS
}


# unmount filesystems
umount_filesystems()
{
  routine="$1"

  if [ "$routine" = 'harddrive' ]
  then
    title 'Hard Drive Setup > Unmount'

    wprintf '[+] Unmounting filesystems'
    printf "\n\n"
    umount -Rf $CHROOT > /dev/null 2>&1;
    if [ $? -ne 0 ]
    then
      return $ERROR
    fi
    umount -Rfl "$HD_DEV"{1..128} > /dev/null 2>&1 # gpt max - 128
    for dev in $NROOT_DEVS
    do
      umount -Rfl "/dev/$dev"{1..128} > /dev/null 2>&1 # gpt max - 128
    done
  else
    title 'Game Over'

    wprintf '[+] Unmounting filesystems'
    printf "\n\n"

    umount -Rfl $CHROOT > /dev/null 2>&1
    cryptsetup luksClose "$CRYPT_ROOT" > /dev/null 2>&1
    swapoff $SWAP_PART > /dev/null 2>&1
    for dev in $NROOT_DEVS
    do
      umount -Rfl "/dev/$dev"{1..128} > /dev/null 2>&1 # gpt max - 128
    done
  fi

  return $SUCCESS
}

#mount non root filesystems
mount_other_fs(){
  title 'Hard Drive Setup > Other mountpoints'
  for item in "${DISK_MOUNTS[@]}"
  do
    part=${item%.*}
    mp=${item#*.}
    if [ "${mp:0:1}" == "/" ]
    then
      mp=${mp:1}
    fi
    echo "Mounting $part on $CHROOT/$mp"
    mount "$part" $CHROOT/$mp >> $VERBOSE 2>&1
    if [ $? -ne 0 ]
    then
      err "Error mounting $part in $CHROOT/$mp"
    fi
  done
}


# check for necessary space
check_space()
{
  if [ $LUKS -eq $TRUE ]
  then
    avail_space=$(df -m | grep "/dev/mapper/$CRYPT_ROOT" | awk '{print $4}')
  else
    avail_space=$(df -m | grep "$ROOT_PART" | awk '{print $4}')
  fi

  if [ "$avail_space" -le 40960 ]
  then
    warn 'BalamOs requires at least 40 GB of free space to install!'
  fi

  return $SUCCESS
}


# install ArchLinux base and base-devel packages
install_base_packages()
{
  title 'Base System Setup > ArchLinux Packages'

  wprintf '[+] Installing ArchLinux base packages'
  printf "\n\n"
  warn 'This can take a while, please wait...'
  printf "\n"
  animation "Downloading packages" &
  pacstrap $CHROOT base base-devel linux linux-firmware zsh git terminus-font >> $VERBOSE 2>&1
  if [ $? -ne 0 ]
  then
    kill %1 2>/dev/null
    clear_log
    echo ""
    err "See the log at /tmp/balamos-install.log"
    exit 1
  fi
  chroot $CHROOT pacman -Syy --noconfirm --overwrite='*' >> $VERBOSE 2>&1
  check $? "install base packages"
  kill %1 2>/dev/null
  if [ $ecode -ne 0 ]
  then
    clear_log
    err "See the log at /tmp/balam-install.log for more info"
    exit 1
  fi
  return $SUCCESS
}


# setup /etc/resolv.conf
setup_resolvconf()
{
  title 'Base System Setup > Etc'

  wprintf '[+] Setting up /etc/resolv.conf'
  printf "\n\n"

  mkdir -p "$CHROOT/etc/" >> $VERBOSE 2>&1
  cp -L /etc/resolv.conf "$CHROOT/etc/resolv.conf" >> $VERBOSE 2>&1

  return $SUCCESS
}


# setup fstab
setup_fstab()
{
  title 'Base System Setup > Etc'

  wprintf '[+] Setting up /etc/fstab'
  printf "\n\n"

  if [ "$PART_LABEL" = "gpt" ]
  then
    genfstab -U $CHROOT >> "$CHROOT/etc/fstab"
  else
    genfstab -L $CHROOT >> "$CHROOT/etc/fstab"
  fi

  sed 's/relatime/noatime/g' -i "$CHROOT/etc/fstab"

  return $SUCCESS
}


# setup locale and keymap
setup_locale()
{
  title 'Base System Setup > Locale'

  wprintf "[+] Setting up $LOCALE locale"
  printf "\n\n"
  sed -i "s/^#en_US.UTF-8/en_US.UTF-8/" "$CHROOT/etc/locale.gen"
  sed -i "s/^#$LOCALE/$LOCALE/" "$CHROOT/etc/locale.gen"
  chroot $CHROOT locale-gen >> $VERBOSE 2>&1
  echo "LANG=$LOCALE" > "$CHROOT/etc/locale.conf"
  echo "KEYMAP=$KEYMAP" > "$CHROOT/etc/vconsole.conf"

  return $SUCCESS
}

get_timezones(){
  local tzns=()
  local zone
  for zone in $(ls -I "*.*" /usr/share/zoneinfo/$1)
  do
    if [ $zone == ${zone,,} ]
    then
      continue
    fi
    tzns+=($zone)
  done
  echo ${tzns[@]}
}

# setup timezone
setup_time()
{
  if confirm 'Base System Setup > Timezone' '[?] Default: UTC. Choose other timezone [y/n]: '
  then
    local timezone="1337"
    local timezones=($(get_timezones))
    while [[ ! ${timezones[@]} =~ ${timezone} ]] || [ -z "$timezone" ]
    do
      title 'Base System Setup > Timezone > Zone'
      menu_draw ${timezones[@]}
      wprintf "\n[?] What is your (Zone): "
      read -r timezone
      timezone=${timezone^}
    done
    if [ -d "/usr/share/zoneinfo/$timezone" ]
    then
      local timesubzone="1337"
      local timesubzones=($(get_timezones $timezone))
      while [ ! -f "/usr/share/zoneinfo/$timezone/$timesubzone" ]
      do
        title 'Base System Setup > Timezone > Subzone'
        menu_draw ${timesubzones[@]}
        wprintf "\n[?] What is your (Subzone): "
        read -r timesubzone
        timesubzone=${timesubzone^}
      done
      timezone=$timezone/$timesubzone
    fi
    chroot $CHROOT ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime \
      >> $VERBOSE 2>&1

    if [ $? -eq 1 ]
    then
      warn 'Do you live on Mars? Setting default time zone...'
      sleep 1
      default_time
    else
      wprintf "\n[+] Time zone setup correctly\n"
    fi
  else
    wprintf "\n[+] Setting up default time and timezone\n"
    sleep 1
    default_time
  fi

  printf "\n"

  return $SUCCESS
}


# default time and timezone
default_time()
{
  echo
  warn 'Setting up default time and timezone: UTC'
  printf "\n\n"
  chroot $CHROOT ln -sf /usr/share/zoneinfo/UTC /etc/localtime >> $VERBOSE 2>&1

  return $SUCCESS
}


# setup initramfs
setup_initramfs()
{
  title 'Base System Setup > InitramFS'

  wprintf '[+] Setting up InitramFS'
  printf "\n\n"

  sed -i 's/keyboard fsck/keyboard fsck consolefont/g' \
    "$CHROOT/etc/mkinitcpio.conf"
  echo 'FONT=ter-114n' >> "$CHROOT/etc/vconsole.conf"

  if [ $LUKS == $TRUE ]
  then
    sed -i 's/block filesystems/block keymap encrypt filesystems/g' \
      "$CHROOT/etc/mkinitcpio.conf"
  fi

  warn 'This can take a while, please wait...'
  printf "\n"
  animation "Creating initramfs" &
  chroot $CHROOT mkinitcpio -P >> $VERBOSE 2>&1
  kill %1 2>/dev/null
  return $SUCCESS
}


# mount /proc, /sys and /dev
setup_proc_sys_dev()
{
  title 'Base System Setup > Proc Sys Dev'

  wprintf '[+] Setting up /proc, /sys and /dev'
  printf "\n\n"

  mkdir -p "${CHROOT}/"{proc,sys,dev} >> $VERBOSE 2>&1

  mount -t proc proc "$CHROOT/proc" >> $VERBOSE 2>&1
  mount --rbind /sys "$CHROOT/sys" >> $VERBOSE 2>&1
  mount --make-rslave "$CHROOT/sys" >> $VERBOSE 2>&1
  mount --rbind /dev "$CHROOT/dev" >> $VERBOSE 2>&1
  mount --make-rslave "$CHROOT/dev" >> $VERBOSE 2>&1

  return $SUCCESS
}


# setup hostname
setup_hostname()
{
  title 'Base System Setup > Hostname'

  wprintf '[+] Setting up hostname'
  printf "\n\n"

  echo "$HOST_NAME" > "$CHROOT/etc/hostname"

  return $SUCCESS
}


# setup boot loader for UEFI/GPT or BIOS/MBR
setup_bootloader()
{
  title 'Base System Setup > Boot Loader'

  if [ "$BOOT_MODE" = 'uefi' ] && [ "$PART_LABEL" = 'gpt' ] && [ "$DUALBOOT" == "$FALSE" ]
  then
    wprintf '[+] Setting up EFI boot loader'
    printf "\n\n"

    chroot $CHROOT bootctl install >> $VERBOSE 2>&1
    uuid="$(blkid "$ROOT_PART" | cut -d ' ' -f 2 | cut -d '"' -f 2)"

    if [ $LUKS = $TRUE ]
    then
      cat >> "$CHROOT/boot/loader/entries/arch.conf" << EOF
title   BalamOs
linux   /vmlinuz-linux
initrd    /initramfs-linux.img
options   cryptdevice=UUID=$uuid:$CRYPT_ROOT root=/dev/mapper/$CRYPT_ROOT rw
EOF

    else
      cat >> "$CHROOT/boot/loader/entries/arch.conf" << EOF
title   BalamOs
linux   /vmlinuz-linux
initrd    /initramfs-linux.img
options   root=UUID=$uuid rw
EOF
    fi
  else
    wprintf '[+] Setting up GRUB boot loader'
    printf "\n\n"
    animation "Setting up grub2" &
    uuid="$(lsblk -o UUID "$ROOT_PART" | sed -n 2p)"
    chroot $CHROOT pacman -S grub --noconfirm --overwrite='*' --needed \
        >> $VERBOSE 2>&1

    if [ $DUALBOOT = $TRUE ]
    then
      chroot $CHROOT pacman -S os-prober --noconfirm --overwrite='*' --needed \
        >> $VERBOSE 2>&1
      sed -i "s/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/g" $CHROOT/etc/default/grub
    fi

    if [ $LUKS == $TRUE ]
    then
      sed -i "s|quiet|cryptdevice=UUID=$uuid:$CRYPT_ROOT root=/dev/mapper/$CRYPT_ROOT quiet|" \
        "$CHROOT/etc/default/grub"
      echo "GRUB_ENABLE_CRYPTODISK=y" >> $CHROOT/etc/default/grub
    fi
    sed -Ei "s|Arch|Balam|g;s|#GRUB_COLOR_|GRUB_COLOR_|g;\
    s|#GRUB_THEME=.*|GRUB_THEME=\"/boot/grub/themes/balam-grub/theme\.txt\"|g;\
    s|GRUB_COLOR_NORMAL=\"light-blue/black\"|GRUB_COLOR_NORMAL=\"red/black\"|g;\
    s|GRUB_COLOR_HIGHLIGHT=\"light-cyan/blue\"|GRUB_COLOR_HIGHLIGHT=\"light-red/black\"|g"\
     $CHROOT/etc/default/grub
    sed -i "s/menuentry '\$LABEL'/menuentry '\$LABEL' --class efi/g" "$CHROOT/etc/grub.d/30_uefi-firmware"
    if [ "$BOOT_MODE" = 'uefi' ]
    then
      chroot $CHROOT pacman -S efibootmgr --noconfirm --overwrite='*' --needed \
          >> $VERBOSE 2>&1
      local target="i386"
      if [ "$(cat /sys/firmware/efi/fw_platform_size)" -eq 64 ]
      then
        target="x86_64"
      fi
      chroot $CHROOT grub-install --target="${target}-efi" --efi-directory=/boot/ --bootloader-id=GRUB >> $VERBOSE 2>&1
    else
      chroot $CHROOT grub-install --target=i386-pc "$HD_DEV" >> $VERBOSE 2>&1
    fi
    local ecode=$?
    kill %1 2>/dev/null
    animation "Cloning and installing grub2 theme" &
    if [ $ecode -ne 0 ]
    then
      err "An error ocurred while installing grub and the system wont be able to boot, solve it once the installation ends"
      sleep 5
    fi

    mkdir -p /boot/grub/themes
    GIT_TERMINAL_PROMPT=0 git clone $GRUB_THEME $CHROOT/boot/grub/themes/balam-grub >> $VERBOSE 2>&1

    kill_job "Cloning"
    printf "\r[+] Generating /boot/grub/grub.cfg, please wait a moment.\n"
    chroot $CHROOT grub-mkconfig -o /boot/grub/grub.cfg >> $VERBOSE 2>&1

    sed -i "s/'uefi-firmware'/'uefi-firmware' --class efi/g" $CHROOT/boot/grub/grub.cfg
  fi

  chroot $CHROOT pacman -Sy --noconfirm linux filesystem >> $VERBOSE 2>&1 #TODO check if system is able to boot without this

  return $SUCCESS
}


# ask for normal user account to setup
ask_user_account()
{
  if confirm 'Base System Setup > User' '[?] Setup a normal user account [y/n]: '
  then
    wprintf '[?] User name: '
    read -r NORMAL_USER
  else
    echo -e "\n    ${RED}${CNF_MSGS[$JUST_A_COUNTER]}$NC"
    if ((JUST_A_COUNTER+1 < ${#CNF_MSGS[@]}))
    then
      ((JUST_A_COUNTER++))
    fi
    sleep 2
    ask_user_account
  fi
  if [[ ! $NORMAL_USER =~ ^[[:alpha:]][[:alpha:][:digit:]_-]{2,15}$ ]]
  then
    err "Invalid username format, it must be between 3 and 15 alphanumeric characters (- and _ allowed)"
    err "and has to start with a aphabetic character"
    ask_user_account
  fi
  return $SUCCESS
}

# setup blackarch test user (not active + lxdm issue)
setup_testuser()
{
  title 'Base System Setup > Test User'

  wprintf '[+] Setting up test user blackarchtest account'
  printf "\n\n"
  warn 'Remove this user after you added a normal system user account'
  printf "\n"
  chroot $CHROOT groupadd blackarchtest >> $VERBOSE 2>&1
  chroot $CHROOT useradd -g blackarchtest -d /home/blackarchtest/ \
    -s /sbin/nologin -m blackarchtest >> $VERBOSE 2>&1
  NORMAL_USER="blackarchtest"
}


# setup user account, password and environment
setup_user()
{
  user="$(echo "$1" | tr -dc '[:alnum:]_' | tr '[:upper:]' '[:lower:]' |
    cut -c 1-32)"

  title "Base System Setup > User $user"

  wprintf "[+] Setting up $user account"
  printf "\n"

  # normal user
  if [ $1 == "root" ]
  then
    chroot $CHROOT chsh -s /usr/bin/zsh >> $VERBOSE 2>&1
    printf "\n"
  elif [ -n "$NORMAL_USER" ]
  then
    chroot $CHROOT groupadd "$user" >> $VERBOSE 2>&1
    chroot $CHROOT useradd -g "$user" -d "/home/$user" -s "/usr/bin/zsh" \
      -G "$user,wheel,users,video,audio" -m "$user" >> $VERBOSE 2>&1
    chroot $CHROOT chown -R "$user":"$user" "/home/$user" >> $VERBOSE 2>&1
    wprintf "[+] Added user: $user"
    printf "\n\n"
  fi

  # password
  res=1337
  wprintf "[?] Set password for $user: "
  printf "\n\n"
  while [ $res -ne 0 ]
  do
    if [ "$user" = "root" ]
    then
      chroot $CHROOT passwd
    else
      chroot $CHROOT passwd "$user"
    fi
    res=$?
  done
  return $SUCCESS
}

reinitialize_keyring()
{
  title 'Base System Setup > Keyring Reinitialization'

  wprintf '[+] Reinitializing keyrings'
  printf "\n\n"
  animation "Updating keyrings" &
  chroot $CHROOT pacman -S --overwrite='*' --noconfirm archlinux-keyring\
    >> $VERBOSE 2>&1
  kill %1 2>/dev/null
  return $SUCCESS
}

# install extra (missing) packages
setup_extra_packages()
{
  cpu=$(cat /proc/cpuinfo | grep vendor_id | cut -f2 -d: | sed 's/ //g' | head -1)
  case $cpu in
    "GenuineIntel")
      cpu="Intel"
      hardware='intel-ucode'
    ;;
    "AuthenticAMD")
      cpu="AMD"
      hardware='amd-ucode'
    ;;
  esac

  gpu=""
  for device in $(lspci | grep VGA | cut -f3 -d: | cut -f2 -d" ")
  do
      gpu="$gpu $device"
      case $device in
          "NVIDIA")
          xorg=$xorg "nvidia nvidia-utils"
          echo -e "[Trigger]\nOperation=Install\nOperation=Upgrade\nOperation=Remove\nType=Package\nTarget=nvidia\nTarget=linux\n\n[Action]\nDescription=Updating NVIDIA module in initcpio\nDepends=mkinitcpio\nWhen=PostTransaction\nNeedsTargets" > $CHROOT/etc/pacman.d/hooks/nvidia.hook
          echo "Exec=/bin/sh -c 'while read -r trg; do case \$trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'" >> $CHROOT/etc/pacman.d/hooks/nvidia.hook
          ;;
          "Intel")
          xorg=$xorg "xf86-video-intel vulkan-intel"
          ;;
          "AMD")
          xorg=$xorg "xf86-video-amdgpu vulkan-radeon"
          ;;
          "VMWare")
          xorg=$xorg "xf86-video-vmware mesa-amber vulkan-swrast"
          ;;
      esac
  done

  all="$ARCH_PKGS $BT_PKGS $BROWSER_PKGS $EDITOR_PKGS $FS_PKGS $FONT_PKGS $AUDIO_PKGS $hardware $KERNEL_PKGS"
  all="$all $MISC_PKGS $NETWORK_PKGS $XORG_PKGS"

  title 'Base System Setup > Extra Packages'

  wprintf '[+] Installing extra packages'
  printf "\n"

  printf "
    Detected CPU: $cpu
    Detected GPU: $gpu

  > ArchLinux   : $(echo "$ARCH_PKGS" | wc -w) packages
  > Browser     : $(echo "$BROWSER_PKGS" | wc -w) packages
  > Bluetooth   : $(echo "$BT_PKGS" | wc -w) packages
  > Editor      : $(echo "$EDITOR_PKGS" | wc -w) packages
  > Filesystem  : $(echo "$FS_PKGS" | wc -w) packages
  > Fonts       : $(echo "$FONT_PKGS" | wc -w) packages
  > Hardware    : $(echo "$hardware" | wc -w) packages
  > Audio       : $(echo "$AUDIO_PKGS" | wc -w) packages
  > Kernel      : $(echo "$KERNEL_PKGS" | wc -w) packages
  > Misc        : $(echo "$MISC_PKGS" | wc -w) packages
  > Network     : $(echo "$NETWORK_PKGS" | wc -w) packages
  > Xorg        : $(echo "$XORG_PKGS" | wc -w) packages
  \n"

  warn 'This can take a while, please wait...'
  printf "\n"
  animation "Installing packages" &
  chroot $CHROOT pacman -Sy --disable-download-timeout --needed --overwrite='*' --noconfirm $all \
    >> $VERBOSE 2>&1
  if [ $? -ne 0 ]
  then
    clear_log
    err "See the log at /tmp/balamos-install.log"
    kill %1 2>/dev/null
    exit 1
  fi
  kill %1 2>/dev/null
  echo "[+] Installing aur packages"
  for pkg in $AUR_PKGS
  do
    git_build $(echo ${pkg##*/} | cut -f1 -d.) $pkg
  done
  return $SUCCESS
}

setup_aur_helper(){
  title "Base System Setup > Aur helper"
  git_build "paru" "https://aur.archlinux.org/paru-bin.git"
  echo '[+] Creating yay alias'
  chroot $CHROOT ln -s /usr/bin/paru /usr/bin/yay >> $VERBOSE 2>&1
  return $SUCCESS
}

setup_ohmyzsh(){
  title "Base System > oh-my-zsh!"
  animation "Installing oh-my-zsh" &
  chroot $CHROOT sh -c "ZSH='/usr/share/oh-my-zsh' $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >> $VERBOSE 2>&1
  check $? "oh-my-zsh"
  cp -r /usr/share/oh-my-zsh/plugins/. $CHROOT/usr/share/oh-my-zsh/plugins/ 
  kill %1 2>/dev/null
}

print_dots(){
  dotprofile="1337"
  if [ ! -f $BI_PATH/profiles.list ]
  then
    err "Profiles not found, dotfiles will default to BiCH0's"
    dotprofile="BiCH0"
    return
  fi
  while [ -z "$(grep $dotprofile $BI_PATH/profiles.list)" ]
  do
    if [ "$dotprofile" != "1337" ]
    then
      err "Use the number of a valid profile"
    fi
    i=1
    title "Base System Setup > Choose profile"
    for profile in $(cat $BI_PATH/profiles.list)
    do
      echo ">> $i.${profile^}"
      ((i++))
    done
    printf "\n"
    wprintf "[?] Choose a dotfiles profile (images at https://github.com/<profile>/balam-dotfiles): "
    read -r dotprofile
    dotprofile=$(sed "${dotprofile}q;d" $BI_PATH/profiles.list 2>/dev/null)
    if [ -z "$dotprofile" ]
    then
      dotprofile="1337"
    fi
  done
}

pkgs_load(){
  local name=$1
  local file=$2
  local -n array="$name"
  local res=()
  for item in $(grep $1 $file | grep -v "^#" | cut -f2 -d"=" | sed 's/\"//g;s/,/ /g')
  do
    res+=($item)
  done
  if [ ${#res[@]} -eq 0 ]
  then
    echo ${array[@]}
  else
    echo ${res[@]}
  fi
}

dotfiles_load(){
  local path=$1
  local target=""
  for route in "$path/backgrounds" "$path/lightdm-theme" "$path/ohmyzsh-themes" "$path/root" "$path/skel"
  do
    if [ -d $route ]
    then
      case ${route##*/} in
        "backgrounds")
          target="usr/share/backgrounds/"
        ;;
        "ohmyzsh-themes")
          target="usr/share/oh-my-zsh/themes/"
        ;;
        "root")
          target="root/"
        ;;
        "skel")
          target="etc/skel/"
        ;;
        *)
          echo ${route##/*} "Not a valid route"
          continue
        ;;
      esac
      cp -rf $route/. $CHROOT/$target >> $VERBOSE 2>&1
    fi
    echo " - Moving $route -> $target" >> $VERBOSE 2>&1
  done
  if [ -f $path/packages.list ]
  then
    WM_PKGS=($(pkgs_load "WM_PKGS" $path/packages.list))
    DM_PKGS=($(pkgs_load "DM_PKGS" $path/packages.list))
  fi
}


skel_push(){
  cp -r ${CHROOT}/etc/skel/. $CHROOT/root >> $VERBOSE 2>&1
  cp -f /root/.zshrc $CHROOT/root/.zshrc >> $VERBOSE 2>&1
  if [ -n "$NORMAL_USER" ]
  then
    cp -r ${CHROOT}/etc/skel/. $CHROOT/home/$NORMAL_USER/ >> $VERBOSE 2>&1
    chroot $CHROOT chown -R "$NORMAL_USER":"$NORMAL_USER" "/home/$NORMAL_USER" >> $VERBOSE 2>&1

  fi
}

#Copy all dotfiles to its destination
prepare_cfiles(){
  title "Base System Setup > System settings"

  cp -r /usr/share/oh-my-zsh/themes/balamos*.zsh-theme $CHROOT/usr/share/oh-my-zsh/themes >> $VERBOSE 2>&1
  check $? "base dotfiles"

  print_dots
  echo "[+] Downloading $dotprofile dotfiles"
  animation "Cloning $dotprofile/balam-dotfiles.git" &
  GIT_TERMINAL_PROMPT=0 git clone https://github.com/${dotprofile}/balam-dotfiles.git -b release /tmp/${dotprofile}-dots >> $VERBOSE 2>&1
  check $? "custom theme"
  if [ $? -ne 0 ]
  then
    echo -e "${RED}[ERR]${NC} Profile not found, choose another"
    prepare_cfiles
  fi
  kill_job "Cloning"

  # This will help the updater keep track of your dotfiles
  mkdir -p $CHROOT/$BI_PATH
  echo -e "PATCH='$LAST_PATCH'\nDOTS='${dotprofile}'" > $CHROOT/$BI_PATH/lastpatch

  dotfiles_load "/tmp/${dotprofile}-dots"
}

# perform system base setup/configurations
setup_base_system()
{
  pass_mirror_conf # copy mirror list to chroot env

  setup_resolvconf

  install_base_packages

  setup_resolvconf

  mount_other_fs

  setup_fstab

  setup_proc_sys_dev

  setup_locale

  setup_initramfs

  setup_hostname

  setup_user "root"
  ask_user_account

  if [ -n "$NORMAL_USER" ]
  then
    setup_user "$NORMAL_USER"
  else
    setup_testuser
    sleep 2
  fi

  reinitialize_keyring

  setup_extra_packages

  setup_aur_helper

  setup_ohmyzsh

  setup_bootloader

  prepare_cfiles

  skel_push

  return $SUCCESS
}


# enable systemd-networkd services
enable_iwd_networkd()
{
  title 'BalamOs Linux Setup > Network'

  wprintf '[+] Enabling Iwd and Networkd'
  printf "\n\n"

  chroot $CHROOT systemctl enable iwd systemd-networkd >> $VERBOSE 2>&1

  return $SUCCESS
}


# update /etc files and set up iptables
update_etc()
{
  title 'BalamOs Linux Setup > Etc files'

  wprintf '[+] Updating /etc files'
  printf "\n\n"

  # /etc/*
  cp -r "/etc/"{arch-release,issue,motd,os-release,sysctl.d,systemd,lsb-release} "$CHROOT/etc/." >> $VERBOSE 2>&1

  # /usr/lib/lsb-release
  cp "/usr/lib/lsb-release" "$CHROOT/usr/lib/" >> $VERBOSE 2>&1

  return $SUCCESS
}


# ask for blackarch linux mirror
ask_mirror()
{
  title 'BalamOs Linux Setup > BlackArch Mirror'

  local IFS='|'
  count=1
  mirror_url='https://balam.confugiradores.es/mirror.lst'
  mirror_file='/tmp/mirror.lst'

  if [ ! -f "$mirror_file" ]
  then
    wprintf '[+] Fetching mirror list'
    curl -sk -o $mirror_file $mirror_url >> $VERBOSE
  fi

  while read -r country url mirror_name
  do
    wprintf " %s. %s - %s" "$count" "$country" "$mirror_name"
    printf "\n"
    wprintf "   * %s" "$url"
    printf "\n"
    ((count++))
  done < "$mirror_file"

  printf "\n"
  wprintf '[?] Select a mirror number (enter for default): '
  read -r a
  printf "\n"

  # bugfix: detected chars added sometimes - clear chars
  _a=$(printf "%s" "$a" | sed 's/[a-z]//Ig' 2> /dev/null)

  if [ -z "$_a" ]
  then
    wprintf "[+] Choosing default mirror: %s " $BA_REPO_URL
  else
    BA_REPO_URL=$(sed -n "${_a}p" $mirror_file | cut -d "|" -f 2)
    wprintf "[+] Mirror from '%s' selected" \
      "$(sed -n "${_a}p" $mirror_file | cut -d "|" -f 3)"
    printf "\n\n"
  fi
  # bugfix: prevent unable to reach repository
  wprintf "[+] Checking connection, wait a moment..."
  ping -c5 -W 15 $BA_REPO_URL &>/dev/null
  if [ $? -eq 0 ]
  then
    rm -f $mirror_file
    return $SUCCESS
  else
    grep -v $BA_REPO_URL $mirror_file > $mirror_file.tmp
    mv $mirror_file.tmp $mirror_file
  fi
}

# ask for archlinux server
ask_mirror_arch()
{
  local mirrold='cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup'

  if confirm 'Pacman Setup > ArchLinux Mirrorlist' \
    "[+] Worldwide mirror will be used\n\n[?] Look for the best server [Y/n]: " "y"
  then
    printf "\n"
    warn 'This may take time depending on your connection'
    printf "\n"
    animation "Fetching the best mirror" &
    $mirrold
    pacman -Sy --noconfirm >> $VERBOSE 2>&1
    pacman -S --needed --noconfirm reflector >> $VERBOSE 2>&1
    yes | pacman -Scc >> $VERBOSE 2>&1
    reflector --verbose -l 15 -f 5 --protocol https --sort rate \
      --save /etc/pacman.d/mirrorlist >> $VERBOSE 2>&1
    kill %1 2>/dev/null
  else
    printf "\n"
    warn 'Using Worldwide mirror server'
    $mirrold
    echo -e "## Arch Linux repository Worldwide mirrorlist\n\n" \
      > /etc/pacman.d/mirrorlist

    for wore in $(echo $AR_REPO_URL)
    do
      echo "Server = $wore" >> /etc/pacman.d/mirrorlist
    done
  fi

}

# pass correct config
pass_mirror_conf()
{
  mkdir -p "$CHROOT/etc/pacman.d/" >> $VERBOSE 2>&1
  cp -f /etc/pacman.d/{blackarch-,}mirrorlist "$CHROOT/etc/pacman.d/" \
    >> $VERBOSE 2>&1
}

# verify the keyring signature
# note: this is pointless if you do not verify the key fingerprint
verify_keyring()
{
  echo -n "[+] Verifying keyring " >> $VERBOSE
  animation "Installing keys" &
  gpg --keyserver keyserver.ubuntu.com \
    --recv-keys F9A6E68A711354D84A9B91637533BAFE69A25079 > /dev/null 2>&1
  if ! gpg --keyserver keyserver.ubuntu.com \
     --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 > /dev/null 2>&1
  then
    if ! gpg --keyserver hkps://keyserver.ubuntu.com:443 \
       --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 > /dev/null 2>&1
    then
      if ! gpg --keyserver hkp://pgp.mit.edu:80 \
         --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 > /dev/null 2>&1
      then
          echo ""
          err "Could not verify the key. Please check: https://blackarch.org/faq.html"
      fi
    fi
  fi
  kill_job "Installing"
  if ! gpg --keyserver-options no-auto-key-retrieve \
    --with-fingerprint ${CHROOT}/tmp/blackarch-keyring.pkg.tar.zst.sig > /dev/null 2>&1
  then
    echo ""
    err "Invalid keyring signature. please stop by https://matrix.to/#/#/BlackaArch:matrix.org"
  else
    echo -e "${GREEN}[OK]${NC}" >> $VERBOSE
  fi
}

# run strap.sh
run_strap_sh()
{
  title 'BalamOs Linux Setup > Strap'

  wprintf '[+] Emulating blackarch strap.sh'
  printf "\n\n"
  warn 'This can take a while, please wait...'
  printf "\n"
  animation "Downloading keys" &
  local mirror_p="${CHROOT}/etc/pacman.d"
  local mirror_r="https://balam.confugiradores.es"
  local MIRROR_F="blackarch-mirrorlist"
  local GPG_CONF="${CHROOT}/etc/pacman.d/gnupg/gpg.conf"

  if ! grep -q 'allow-weak-key-signatures' $GPG_CONF
  then
    echo 'allow-weak-key-signatures' >> $GPG_CONF
  fi

  curl -s $BA_KEYRING > ${CHROOT}/tmp/blackarch-keyring.pkg.tar.zst
  curl -s "$BA_KEYRING.sig" > ${CHROOT}/tmp/blackarch-keyring.pkg.tar.zst.sig

  kill %1 2>/dev/null
  printf "\r                          \n"

  verify_keyring
  
  animation "Installing keyring" &

  if [ -f "${CHROOT}/tmp/blackarch-keyring.pkg.tar.zst.sig" ]; then
    rm ${CHROOT}/tmp/blackarch-keyring.pkg.tar.zst.sig
  fi

  if ! chroot $CHROOT pacman --config /dev/null --noconfirm \
    -U /tmp/blackarch-keyring.pkg.tar.zst >> $VERBOSE 2>&1; then
      kill %1 2>/dev/null
      err 'keyring installation failed'
  fi
  kill %1 2>/dev/null

  # hotfix for Blackarch #4061
  animation "Populating keyring" &
  chroot $CHROOT pacman-key --recv-key F9A6E68A711354D84A9B91637533BAFE69A25079 >> $VERBOSE 2>&1
  echo "F9A6E68A711354D84A9B91637533BAFE69A25079:4:" >> $CHROOT/usr/share/pacman/keyrings/blackarch-trusted
  chroot $CHROOT pacman-key --populate blackarch archlinux >> $VERBOSE 2>&1

  kill_job "Populating"

  echo ""
  echo "[+] Fetching new mirror list..." >> $VERBOSE
  if ! curl -sk "$mirror_r/$MIRROR_F" -o "$mirror_p/$MIRROR_F"
  then
    err "We couldn't fetch the mirror list from: $mirror_r/$MIRROR_F"
  fi

  # add blackarch linux mirror if we are in chroot
  if ! grep -q 'blackarch' "$CHROOT/etc/pacman.conf"
  then
    echo ""
    echo "[+] Adding blackarch mirror"
    printf '[blackarch]\nServer = %s\nInclude = /etc/pacman.d/blackarch-mirrorlist' "$BA_REPO_URL" \
      >> "$CHROOT/etc/pacman.conf"
  else
    sed -i "/\[blackarch\]/{ n;s?Server.*?Server = $BA_REPO_URL?; }" \
      "$CHROOT/etc/pacman.conf"
  fi

  # copy balam os updater to final system
  cp /usr/bin/balamos-update ${CHROOT}/usr/bin/balamos-update
  cp -r $BI_PATH ${CHROOT}$BI_PATH

  return $SUCCESS
}

extra_pkgs_cleanup(){
  local apt_pkgs=($*)
  local aur_pkgs=()
  for pkg in ${apt_pkgs[@]}
  do
    if [[ "$pkg" =~ ^https://.+ ]]
    then
      apt_pkgs=("${apt_pkgs[@]/$pkg}")
      aur_pkgs+=($pkg)
    fi
  done
  echo "${apt_pkgs[@]}|${aur_pkgs[@]}"
}

# setup display manager
setup_display_manager()
{
  title 'BalamOs Linux Setup > Display Manager'

  echo '[+] Installing Display Manager packages:'
  print_pkgs ${DM_PKGS[@]}
  printf "\n"
  animation "Downloading packages" &

  local pkgs=$(extra_pkgs_cleanup ${DM_PKGS[@]})
  chroot $CHROOT pacman -S ${pkgs%|*}  --needed --overwrite='*' \
    --noconfirm >> $VERBOSE 2>&1
  kill_job "Downloading"
  printf "\r[~] Downloading packages... [OK]\n"

  for pkg in ${pkgs#*|}
  do
    git_build $(echo ${pkg##*/} | cut -f1 -d.) $pkg
  done

  rm -fr $CHROOT/etc/systemd/system/getty@tty1.service.d/

  # Copy icons and fonts to chroot
  cp -r /usr/share/icons/. "$CHROOT/usr/share/icons/."
  mkdir -p $CHROOT/usr/share/fonts/{TTF,opentype}
  cp /usr/share/fonts/opentype/{conthrax-sb,DroidSansMNerdFontMono-Regular}.otf $CHROOT/usr/share/fonts/opentype/
  cp /usr/share/fonts/TTF/HackNFM-Regular.ttf $CHROOT/usr/share/fonts/TTF/

  chroot $CHROOT systemctl enable ${pkgs%%|*} >> $VERBOSE 2>&1

  # TODO add support for other greeters
  if [[ ${pkgs[@]} =~ ly ]]
  then
    cp -f /tmp/${dotprofile}-dots/ly.conf $CHROOT/etc/ly/config.ini
    sed -i "s|tty2|tty7|g" $CHROOT/usr/lib/systemd/system/ly.service
  elif [[ ${pkgs[@]} =~ lightdm ]]
  then
      local ldmg=$(echo ${DM_PKGS[@]} | grep greeter)
      if [ $(echo $ldmg | wc -w) -gt 1 ]
      then
        ldmg=$(echo $ldmg | cut -f1 -d" ")
        warn "Multiple greeters detected, using $ldmg" 
      fi
      sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=${ldmg}/g" $CHROOT/etc/lightdm/lightdm.conf
  fi
  return $SUCCESS
}


# setup window managers
setup_window_managers()
{
  title 'BalamOs Linux Setup > Window Manager'

  echo '[+] Installing Window Manager packages:'
  print_pkgs ${WM_PKGS[@]}
  printf "\n"

  local pkgs=$(extra_pkgs_cleanup ${WM_PKGS[@]})

  animation "Installing packages" &

  chroot $CHROOT pacman -S ${pkgs%|*}  --needed --overwrite='*' \
    --noconfirm >> $VERBOSE 2>&1

  kill %1 2>/dev/null
  printf "\r[~] Installing packages... [OK]\n"

  local pkg
  for pkg in ${pkgs#*|}
  do
    git_build $(echo ${pkg##*/} | cut -f1 -d.) $pkg
  done

  # Copy live desktop files to chroot
  cp -r "/usr/share/xsessions/i3.desktop" "$CHROOT/usr/share/xsessions"

  # wallpaper
  cp -r "/usr/share/backgrounds" "$CHROOT/usr/share/backgrounds/"

  # remove wrong xsession entries
  chroot $CHROOT rm /usr/share/xsessions/i3-with-shmlog.desktop >> $VERBOSE 2>&1

  return $SUCCESS
}


# ask user for VirtualBox modules+utils setup
ask_vbox_setup()
{
  if confirm 'BalamOs Linux Setup > VirtualBox' '[?] Setup VirtualBox modules [y/n]: '
  then
    VBOX_SETUP=$TRUE
  fi

  return $SUCCESS
}


# setup virtualbox utils
setup_vbox_utils()
{
  title 'BalamOs Linux Setup > VirtualBox'

  wprintf '[+] Setting up VirtualBox utils'
  printf "\n\n"
  animation "Installing VirtualBox utils" &
  chroot $CHROOT pacman -S virtualbox-guest-utils --overwrite='*' --needed \
    --noconfirm >> $VERBOSE 2>&1

  chroot $CHROOT systemctl enable vboxservice >> $VERBOSE 2>&1

  cp -r "/etc/xdg/autostart/vboxclient.desktop" \
    "$CHROOT/etc/xdg/autostart/." >> $VERBOSE 2>&1
  kill %1 2>/dev/null
  return $SUCCESS
}


# ask user for VMware modules+utils setup
ask_vmware_setup()
{
  if confirm 'BalamOs Linux Setup > VMware' '[?] Setup VMware modules [y/n]: '
  then
    VMWARE_SETUP=$TRUE
  fi

  return $SUCCESS
}


# setup vmware utils
setup_vmware_utils()
{
  title 'BalamOs Linux Setup > VMware'

  wprintf '[+] Setting up VMware utils'
  printf "\n\n"
  animation "Installing VMWare utils" &

  chroot $CHROOT pacman -S open-vm-tools xf86-video-vmware \
    xf86-input-vmmouse --overwrite='*' --needed --noconfirm \
    >> $VERBOSE 2>&1

  chroot $CHROOT systemctl enable vmware-vmblock-fuse.service >> $VERBOSE 2>&1
  chroot $CHROOT systemctl enable vmtoolsd.service >> $VERBOSE 2>&1
  kill %1 2>/dev/null
  return $SUCCESS
}


# ask user for BlackArch tools setup
ask_ba_tools_setup()
{
  if confirm 'BalamOs Linux Setup > Tools' '[?] Setup Noice T00lz [y/n]: '
  then
    BA_TOOLS_SETUP=$TRUE
  fi

  return $SUCCESS
}

# skip git tools, it makes the installation finish gracefully
{
  
  umount_filesystems
  sync_disk
  easter_backdoor

  clear_log
}

# setup blackarch tools from repository (binary) or via blackman (source)
setup_blackarch_tools()
{
  foo=5

  if [ "$VERBOSE" = '/dev/null' ]
  then
    noconfirm='--noconfirm'
  fi

  if [ -n "$dotprofile" ]
  then
    if ! confirm 'BalamOs Linux Setup > Tools' "[?] Install dotfiles ($dotprofile) toolset? [Y/n]: " "y"
    then
      print_dots
    fi
  fi
  if [ ! -f /tmp/${dotprofile}-dots/tools.list ]
  then
    err "Tools not found, so no 1337 4 u. Unless..."
    sleep 2
    if confirm 'BalamOs Linux Setup > Tools' "[?] Do you wanna use another profile? [y/n]"
    then
      setup_blackarch_tools
      return $?
    else
      return $FALSE
    fi
  fi

  wprintf "[+] Installing $dotprofile's toolset:\n"
  print_pkgs $tools
  printf "\n"
  warn 'This can take a while, please wait...'
  check_space
  printf "\n"
  animation "Installing tools" &
  
  local toolset=$(extra_pkgs_cleanup $(cat /tmp/${dotprofile}-dots/tools.list))

  chroot $CHROOT pacman -S ${toolset%|*}  --needed --overwrite='*' \
    --noconfirm >> $VERBOSE 2>&1

  if [[ ${toolset[@]} =~ wordlistctl ]]
  then
    cp -r /usr/share/wordlists/. $CHROOT/usr/share/wordlists
    chmod -R 777 $CHROOT/usr/share/wordlists
  fi

  kill %1 2>/dev/null

  if confirm 'BalamOs Linux Setup > Tools > Git tools' "[?] Some of the tools need to be compiled, wanna install them anyways? [Y/n]: " "y"
  then
    trap skip_git_tools 2
    local tool
    for tool in ${toolset#*|}
    do
      git_build $(echo ${tool##*/} | cut -f1 -d.) $tool
    done
  fi

  # This will help the updater keep track of your toolset
  echo -e "DOTTOOLS='$dotprofile'\nDATE='$(date +%Y/%m/%dT%H:%M:%SZ)'" >> $CHROOT/$BI_PATH/lastpatch

  return $SUCCESS
}

# add user to newly created groups
update_user_groups()
{
  title 'BalamOs Linux Setup > User'

  wprintf "[+] Adding user $user to groups and sudoers"
  printf "\n\n"

  if [ $VBOX_SETUP -eq $TRUE ]
  then
    chroot $CHROOT usermod -aG 'vboxsf,audio,video' "$user" >> $VERBOSE 2>&1
  fi

  # sudoers
  echo "$user ALL=(ALL) ALL" >> $CHROOT/etc/sudoers >> $VERBOSE 2>&1

  return $SUCCESS
}

# setup blackarch related stuff
setup_blackarch()
{
  update_etc

  enable_iwd_networkd

  ask_mirror

  run_strap_sh

  setup_display_manager

  setup_window_managers

  ask_vbox_setup

  if [ $VBOX_SETUP -eq $TRUE ]
  then
    setup_vbox_utils
  fi

  ask_vmware_setup

  if [ $VMWARE_SETUP -eq $TRUE ]
  then
    setup_vmware_utils
  fi

  enable_pacman_multilib 'chroot'

  enable_pacman_color 'chroot'

  ask_ba_tools_setup

  if [ $BA_TOOLS_SETUP -eq $TRUE ]
  then
    setup_blackarch_tools
  fi

  if [ -n "$NORMAL_USER" ]
  then
    update_user_groups
  fi

  return $SUCCESS
}


# for fun and lulz
easter_backdoor()
{
  local bar=0

  title 'Game Over'

  wprintf '[+] BalamOs Linux installation successfull!'
  printf "\n\n"

  wprintf 'Yo n00b, b4ckd00r1ng y0ur sy5t3m n0w '
  while [ $bar -ne 5 ]
  do
    wprintf "."
    sleep 1
    ((bar++))
  done
  printf "\n>> ${BLINK}${WHITE}HACK THE PLANET! D00R THE PLANET!${NC} <<"
  printf "\n\n"

  return $SUCCESS
}


# perform sync
sync_disk()
{
  title 'Game Over'

  wprintf '[+] Syncing disk'
  printf "\n\n"

  sync

  return $SUCCESS
}


# check if new version available. perform self-update and exit
self_updater()
{
  title 'Self Updater'
  wprintf '[+] Checking for a new version of myself...'
  printf "\n\n"
  local rversion=$(curl -s https://raw.githubusercontent.com/BICH0/balamOs/master/installer.sh 2>/dev/null | tee /tmp/installer.sh | grep VERSION2= | head -1 | sed -E "s/.+=//g;s/'//g")
  local lversion=$(echo $VERSION2 | sed -E "s/.+=//g;s/'//g")
  local update=0

  for ((i=1; i<=3; i++))
  do
    local lpart=$(echo $lversion | cut -f$i -d".")
    local rpart=$(echo $rversion | cut -f$i -d".")
    if [ "$lpart" -gt "$rpart" ]
    then
      break;
    elif [ "$lpart" -lt "$rpart" ]
    then
      update=1
      break;
    fi
  done

  if [ "$update" -eq 1 ]
  then
    printf "\n\n"
    warn 'A new version is available! Going to fuck, err, update myself.'
    mv /tmp/installer.sh /usr/bin/balamos-install
    wprintf "\n[+] Updated successfully. Please restart the installer now!\n"
    chmod +x /usr/bin/balamos-install
    exit $SUCCESS
  fi
  return $SUCCESS
}


# controller and program flow
main()
{
  # do some ENV checks
  clear
  check_uid
  check_env
  check_boot_mode

  # Update keyrings
  install_keyrings

  # Check if installer needs to be updated
  self_updater
  sleep 1

  # output mode
  ask_output_mode

  # locale
  ask_locale
  set_locale

  # keymap
  ask_keymap
  set_keymap

  # network
  ask_hostname

  get_net_ifs
  ask_net_conf_mode
  if [ "$NET_CONF_MODE" != "$NET_CONF_SKIP" ]
  then
    ask_net_if
  fi
  case "$NET_CONF_MODE" in
    "$NET_CONF_AUTO")
      net_conf_auto
      ;;
    "$NET_CONF_WLAN")
      ask_wlan_data
      net_conf_wlan
      ;;
    "$NET_CONF_MANUAL")
      ask_net_addr
      net_conf_manual
      ;;
    "$NET_CONF_SKIP")
      ;;
    *)
      ;;
  esac
  clear

  # pacman
  ask_mirror_arch
  update_pacman

  # hard drive
  get_hd_devs
  ask_hd_dev
  ask_dualboot

  umount_filesystems 'harddrive' 
  if [ $? -ne $SUCCESS ]
  then
    err "Unable to unmount devices, try manually unmounting the following"
    mount -l | grep "$CHROOT"
  fi
  
  ask_cfdisk

  noroot_disks
  ask_luks

  get_partition_label
  ask_partitions
  print_partitions

  ask_formatting
  make_partitions
  mount_filesystems

  # arch linux
  setup_base_system
  setup_time

  # blackarch Linux
  setup_blackarch

  # epilog
  umount_filesystems
  sync_disk
  easter_backdoor

  clear_log
  
  return $SUCCESS
}


# we start here
main "$@" | tee ${LOGFILE}.tmp


# EOF
