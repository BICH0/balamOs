#!/bin/bash
function exitFn {
    sed -i "/exec_always --no-startup-id ~\/fixer.sh/d" /home/balam/.config/i3/config
    rm -rf /home/balam/fixer.sh
}
command=""
if ping -c2 -W2 1.1.1.1 >/dev/null
then
    extra="pacman -Sy"
fi
echo "toor" | su root -c "
mv /etc/lsb-release.bak /etc/lsb-release
mv /etc/skel/.zshrc.bak /etc/skel/.zshrc
cp /etc/os-release /usr/lib/os-release
pacman-key --init   
pacman-key --populate archlinux blackarch
$(echo $extra)
"
exitFn