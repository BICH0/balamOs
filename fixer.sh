#!/bin/bash
function exitFn {
    sed -i '$d' /home/balam/.zshrc
    rm -rf /home/balam/fixer.sh
}

echo "toor" | su root -c '
mv /etc/lsb-release.bak /etc/lsb-release
mv /etc/skel/.zshrc.bak /etc/skel/.zshrc
cp /etc/os-release /usr/lib/os-release
'
exitFn