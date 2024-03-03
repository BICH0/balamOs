#!/bin/bash

killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

for screen in $(polybar --list-monitors | tr " " "$")
do
 m=$(echo $screen | cut -f1 -d:)
 if [[ $(echo $screen | grep primary) ]]
 then
    MONITOR=$m polybar primary-uni &
 else
    MONITOR=$m polybar secondary &
 fi
done
