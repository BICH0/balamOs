#!/bin/sh

#Colors
BG='#161616'
BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#ff4949'
TEXT='#dbdbdb'
TEXT2='#ff4c4c'
WRONG='#ff0000'
VERIFYING='#ffffff00'

i3lock \
--{time,date,layout,verif,wrong,greeter}-font=hack \
--{date,verif,wrong,greeter}-size=20 \
--{layout,date,greeter}-color=$TEXT2 \
--{time,verif,wrong}-color=$TEXT     \
--{key,bs}hl-color=$DEFAULT          \
--ringver-color=$VERIFYING           \
--ringwrong-color=$WRONG             \
--wrong-color=$WRONG                 \
--pass-{media,screen,power,volume}-keys \
-c $BG                           \
--bar-indicator                  \
--bar-base-width 5               \
--bar-max-height 100              \
--bar-periodic-step 50           \
--bar-step 30                    \
--bar-color $DEFAULT             \
--bar-count 15                   \
--screen 1                       \
--clock                          \
--indicator                      \
--time-str="%H:%M:%S"            \
--date-str="%A, %d/%m/%Y"        \
--verif-text="Verifying…"        \
--wrong-text="Invalid password"  \
--keylayout 1                    \