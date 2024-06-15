#!/bin/bash -x

UPDATER_VERSION='0.0.3'

process_update(){
   echo "[+] Updating $1"
   case $1 in
    *)
        echo "  [!] $1 not found, skipping..."
    ;;
   esac;
}

####### STATIC CODE BELOW

NOCONFIRM=0
BU_PATH="/usr/bin/balamos-update"
LOG="/tmp/balam-updater.log"
LVERSION_PATH="/usr/share/balamos-data"
PATCHES_URL="https://balam.confugiradores.es/patches"
DOTS_URL=""
TOOLS_URL=""
LPATCH="[?]"
RPATCH=""
DATE=""
DOTFILES=("[?]" "[?]")
DTOOL_UPD=0
DOTS_UPD=0
PATCH_UPD=0

#Color codes
RED="$(tput setaf 1)"
RED2B="$(tput setaf 9)"
PURPLE="$(tput setaf 13)"
NC="$(tput sgr0)"

# leet banner (very important, very 1337)
banner()
{
  columns="$(tput cols)"
  str="--==[ BalamOs Linux updater ($UPDATER_VERSION) ]==--"
  printf "${RED}%*s${NC}\n" "${columns}" | tr ' ' '-'
  echo "$str" |
  while IFS= read -r line
  do
    printf "%s%*s\n%s" "$RED2B" $(( (${#line} + columns) / 2)) \
      "$line" "$NC"
  done
  printf "${RED}%*s${NC}\n" "${columns}" | tr ' ' '-'
  sub_l="Last patch: $LPATCH"
  sub_r="Dotfiles: ${DOTFILES[0]} / ${DOTFILES[0]}"
  sub_spacing=$(($columns - ${#sub_l} - ${#sub_r}))
  printf "%s%*s%s\n\n\n" "$sub_l" $sub_spacing "" "$sub_r"
}

title()
{
  clear
  banner
  printf "${PURPLE}>> %s${NC}\n\n\n" "${@}"
}

parse_datafile(){
    local field=$1
    local file=$2
    grep "$field=" $file 2>/dev/null | sed -E "s/.+=//g;s/['\"]//g" | head -1
}

exit_status(){
    local msg="*${1// /\*}*"
    local side=$((($columns-${#msg}-2)/2))
    local color
    case $2 in
        "0")
            color="\e[0;32m"
        ;;
        "1")
            color="\e[0;31m"
        ;;
        "2")
            color="\e[0;33m"
        ;;
    esac

    printf "${color}%*s${NC}[%s]${color}%*s${NC}\n\n\n" $side "" "$msg" $side "" | sed 's/ /-/g;s/*/ /g'
}

#Returns 1 if $1 is lower than $2 or if $1 doesnt exist, can also return 2 if there are multiple versions in between
compare_ver(){
    local lver=$1
    local rver=$2
    if [ -z "$lver" ] || [ -z "$rver" ]
    then
        return 1
    fi
    local res=1
    for ((i=1;i<=3;i++))
    do
        local ldig=$(echo $lver | cut -f$i -d".")
        local rdig=$(echo $rver | cut -f$i -d".")
        if [ "$ldig" -lt "$rdig" ]
        then
            return 1
        elif [ "$ldig" -gt "$rdig" ]
        then
            return 0
        fi
    done
    return 0
}

compare_date(){
    if [ -z "$1" ] || [ -z "$2" ]
    then
        return 0
    fi
    if [[ "$1" > "$2" ]]
    then
        return 1
    fi
    return 0
}

process_args(){
    for arg in $*
    do
        case $arg in
            "--noconfirm")
                NOCONFIRM=1
            ;;
            *)
            ;;
        esac
    done
}

fetch_patches(){
    local lpatch_v=(${LPATCH//\./ })
    local rpatch_v=(${RPATCH//\./ })
    local fetch=(${LPATCH//\./ })
    local lvl=1
    local version
    local res=1
    while [ "${fetch[*]}" != "${rpatch_v[*]}" ] && [ $lvl -ge 0 ]
	do
        ((fetch[2]++))
        version="${fetch[0]}.${fetch[1]}.${fetch[2]}"
		curl --fail-with-body -sk $PATCHES_URL/patch-$version -o /tmp/patch-$version 2>/dev/null
        if [ $? -ne 0 ]; then
            rm /tmp/patch-$version
			fetch[2]=0
            ((fetch[$lvl]++))
			((lvl--))
        else
            install_patch $version
            res=$?
        fi
    done
    return $res
}

check_needed(){
    echo "[+] Checking for self update..."
    curl -s https://raw.githubusercontent.com/BICH0/balamOs/master/updater.sh -o /tmp/updater.sh
    compare_ver $UPDATER_VERSION $(parse_datafile "UPDATER_VERSION" /tmp/updater.sh)
    if [ $? -ne 0 ]
    then
        echo -e "${RED}[!]${NC} New version available going squizo mode!"
        $(/tmp/updater.sh $*) && exit 0
    fi
    echo "[+] Fetching last patch..."
    if [ $(curl --fail-with-body -sk $PATCHES_URL/latest -o /tmp/lastpatch) ]
    then
        echo -e "${RED}[ERROR]${NC} Unable to fetch lastpatch, verify your internet connection or try later"
        rm /tmp/lastpatch
        exit 1
    fi
    RPATCH=$(parse_datafile "PATCH" /tmp/lastpatch)
    mv /tmp/lastpatch /tmp/patch-$RPATCH 
    LPATCH="0.0.0"
    if [ -f "$LVERSION_PATH/lastpatch" ]
    then
        DATE=$(parse_datafile "DATE" $LVERSION_PATH/lastpatch)
        LPATCH=$(parse_datafile "PATCH" $LVERSION_PATH/lastpatch)
        if [ -z "$LPATCH" ]
        then
            LPATCH="0.0.0"
            echo $LPATCH >> $LVERSION_PATH/lastpatch
            echo $DATE >> $LVERSION_PATH/lastpatch
        fi
    else
        echo "PATCH='$LPATCH'" > $LVERSION_PATH/lastpatch
        echo "DATE='$(date +%Y/%m/%dT%H:%M:%SZ)'" >> $LVERSION_PATH/lastpatch
    fi
    compare_ver $LPATCH $RPATCH
    PATCH_UPD=$?

    echo "[+] Fetching dotfiles and toolist updates..."
    local index=0
    for line in "DOTS" "DOTTOOLS"
    do
        local output=$(parse_datafile "$line" $LVERSION_PATH/lastpatch)
        if [ -n "$output" ]
        then
            DOTFILES[$index]=$output
        fi
        ((index++))
    done

    compare_date $(curl -s https://api.github.com/repos/${DOTFILES[0]}/balam-dotfiles/commits/release | grep date | tail -1 | sed -E 's/.*":.//g;s/"//g') $(date +%Y/%m/%dT%H:%M:%SZ)
    DOTS_UPD=$?

    compare_date $(curl -s https://api.github.com/repos/${DOTFILES[1]}/balam-dotfiles/commits/release | grep date | tail -1 | sed -E 's/.*":.//g;s/"//g') $(date +%Y/%m/%dT%H:%M:%SZ)
    DTOOL_UPD=$?

    return $?
}

handle_update(){
    if [ $PATCH_UPD -ne 0 ]
    then
        fetch_patches $LPATCH $RPATCH
        return $?
    fi
    return 1
}

handle_dots (){
    if [ $DOTS_UPD -eq 1 ]
    then
        git clone https://github.com/${DOTFILES[0]}/balam-dotfiles/ -b release /tmp/balam-dotfiles 1>/dev/null
        #for each file check if its the same, if not ask
    fi
    if [ $DTOOL_UPD -eq 1 ]
    then
        curl https://raw.githubusercontent.com/${DOTFILES[1]}/balam-dotfiles/release/tools.list -o /tmp/tools.list
        #parse tools file
    fi
}

apply_patch(){
    local opt=$1
    shift
    local args=($*)
    local ecode=0
    #Cleanup for \e
    for ((i=0;i<${#args[@]};i++))
    do
        args[$i]="${args[$i]//\\e/ }"
    done
    printf "\n\n"
    case $opt in
        "pkgs")
            local pacman=()
            for pkg in "${args[@]}"
            do
                if [ "${pkg}" =~ ^https:\/\/ ]
                then
                    echo "AUR packages not supported, todavia..."
                else
                    pacman+=($pkg)
                fi
            done
            pacman -Sy --needed --noconfirm ${pacman[*]}
            ecode=$?
        ;;
        "confs")
            for conf in "${args[@]}"
            do
                echo "[+] ${conf}"
                local action=${conf:0:1}
                conf=${conf:1}
                local line=${conf%,*}
                local file=${conf#*,}
                if [ ! -f $file ]
                then
                    echo -e "    ^-- ${RED}[ERR]${NC} File not found\n"
                    ecode=1
                    continue
                fi
                #Select action #Comment >Append !Replace
                case "$action" in
                    "#")
                        sed -i "s$line|#$line|g" $file 2>>$LOG
                    ;;
                    ">")
                        echo $line >> $file
                    ;;
                    "!")
                        local what=${line%||*}
                        local with=${line#*||}
                        sed -i "s|$what|$with|g" $file 2>>$LOG
                    ;;
                esac
                if [ $? -ne 0 ]
                then
                    ecode=$?
                    echo "    ^-- ${RED}[ERR]${NC}"
                    printf ""
                    sleep 2
                fi
            done
        ;;
        "hotfixes")
            for cmd in "${args[@]}"
            do
                echo "[+] ${cmd}"
                bash -c "$cmd" 2>$LOG
                if [ $? -ne 0 ]
                then
                    ecode=$?
                    echo -e "    ^-- ${RED}[ERR]${NC}"
                    sleep 2
                fi
            done
        ;;
    esac
    echo ""
    sleep 4
    return $ecode
}

parse_patchinfo(){
    local new=()
    local count=0
    local patch_cats=0
    local opt
    local res=0
    for item in "pkgs" "confs" "hotfixes"
    do
        new=$(grep "NEW${item^^}" /tmp/patch-$1 | sed -E "s/^.+=//g;" | sed 's/\\&/ /g')
        new=(${new:1:-1})
        count=${#new[*]}
        opt=""

        if [ -n "$new" ]
        then
            ((patch_cats++))
            while [[ ! ${opt} =~ ^[i|s]$ ]]
            do
                title "Update > Patches ($1) > ${item^}"
                if [ "$opt" == "v" ]
                then
                    echo -e "\nChanges: \n"
                    for new_change in ${new[@]}
                    do
                        echo "- ${new_change//\\e/ }"
                    done
                    echo ""
                fi
                echo "There are $count new ${item^} do you want to install them?"
                if [ $NOCONFIRM -eq 0 ]
                then
                    read -p "(I)nstall, (s)kip, (v)iew changes: " opt
                else
                    opt="i"
                fi
                opt=${opt,,}
                case ${opt} in
                    "")
                        opt="i"
                    ;&
                    "i")
                        apply_patch $item ${new[@]}
                        res=$?
                    ;;
                    "v")
                        opt=v
                    ;;
                esac
            done
        fi

    done
    if [ $patch_cats -eq 0 ]
    then
        return 2
    fi
}

install_patch(){
    title "Update > Patches ($1)"
    local patch=$1
    local stime=2
    if [ -z "$patch" ]
    then
        patch="last"
    fi
    parse_patchinfo $patch
    local ecode=$?
    case $ecode in
     "0")
        exit_status "Installed succesfully" 0
     ;;
     "2")
        printf "\n\n\n\n"
        exit_status "Empty Patch :C" 2
        stime=1
        ecode=0
     ;;
     *)
        exit_status "Error applying patch" 1
        stime=5
        ecode=1
     ;;
    esac
    sleep $stime
    return $ecode
}

main(){
    title "Main > Checking environment"
    if [ $(id -u) -ne 0 ]
    then
        echo -e "${RED}[!] This updater can only be launched as root\nTry sudo balamos-update${NC}\n"
        exit 1
    fi
    if [ "$0" != $BU_PATH ] && [ "$0" != "/sbin/balamos-update" ]
    then
        cp -f $0 $BU_PATH
    fi
    process_args $*
    check_needed $*
    handle_dots
    handle_update && echo "Everything done, your system now is up to patch $RPATCH"
    if [ ! -d $LVERSION_PATH ]
    then
        mkdir -p $LVERSION_PATH
    fi
    echo "[+] Updating register..."
    sed -Ei "s/PATCH=.+/PATCH='$RPATCH'/g" $LVERSION_PATH/lastpatch
    sed -Ei "s|DATE=.+|DATE='$DATE'|g" $LVERSION_PATH/lastpatch
    echo ""
    exit 0
}

main $*