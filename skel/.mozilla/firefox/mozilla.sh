#!/bin/bash
if [ -n "$(stat .mozilla/firefox/*.default-release* | grep File | grep -v default.default | cut -f4 -d" ")" ]
then
    sed -i "/~\/.mozilla\/firefox\/mozilla.sh/d" ~/.zshrc
    rm ~/.mozilla/firefox/mozilla.sh
fi