#!/bin/bash
firefox &>/dev/null &
kill -15 $!
if [ ! -f ~/.mozilla/firefox/profiles.ini ]
then
    exit
fi
profile=~/.mozilla/firefox/$(cat ~/.mozilla/firefox/profiles.ini | grep Profile0 -3 | tail -1 | cut -f2 -d'=')
if [ -d $profile ]
then
    rm -rf $profile
    mv ~/.mozilla/firefox/default.default-release $profile
    sed -i "/~\/.mozilla\/firefox\/mozilla.sh/d" ~/.zshrc
    rm ~/.mozilla/firefox/mozilla.sh
fi