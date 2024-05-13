#!/bin/bash

UPDATER_VERSION='0.0.1'
CHANGES="this is just a test"

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

#Color codes
RED="\e[0;31m"
NC="\e[0m"

compare_ver(){
    local lver=$1
    local rver=$2
    if [ -z "$lver" ] || [ -z "$rver" ]
    then
        return 1
    fi
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

check_needed(){
    compare_ver $(cat /usr/share/balamos_lastpatch 2>/dev/null) $UPDATER_VERSION
    if [ $? -eq 1 ]
    then
        start_update
    else
        echo "[+] Checking if update is available"
        curl https://raw.githubusercontent.com/BICH0/balamOs/master/updater.sh > /tmp/updater.sh
        
    fi
}

process_choice(){
    options=($(echo $* | sed 's/,/ /g'))
    for opt in ${options[@]}
    do
        if [[ "$opt" =~ - ]]
        then
            for ((i=${opt%-*}; i<=${opt#*-}; i++))
            do
                echo $i
            done
            continue
        fi
        echo $opt
    done
}

start_update(){
    local change_num=$(echo $CHANGES | wc -w)
    local update=()
    if [ "$change_num" -eq 0 ]
    then
        echo "[!] Nothing to update, y'all good 4 now..."
        #exit 0
    fi
    printf "These are the current changes: \n"
    for ((i=0; i<$change_num; i++))
    do
        echo " $i.$(echo $CHANGES | cut -f$(($i+1)) -d" ")"
    done
    printf "\n"
    echo "Default: ALL"
    printf "[?] Select the changes you want to apply (0 1 2-4): "
    if [ "$NOCONFIRM" -ne 1 ]
    then
        read -r choice
    else
        echo ""
    fi
    echo ""
    if [ -z "$choice" ]
    then
        choice=$(seq 0 $change_num)
    else
        choice=$(process_choice $choice)
    fi
    for num in $choice
    do
        num=$(($num+1))
        local item=$(echo $CHANGES | cut -f$num -d" ")
        if [ -n "$item" ]
        then
            process_update $item
        fi
    done
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

main(){
    echo ""
    if [ $(id -u) -ne 0 ]
    then
        echo -e "${RED}[!] This updater can only be launched as root\nTry sudo balamos-updater${NC}\n"
        exit 1
    fi
    process_args $*
    check_needed
    echo $UPDATER_VERSION > /usr/share/balamos_lastpatch
    echo ""
    exit 0
}

main $*