#!/bin/bash

menu=$(echo -e "Internet\nDevelopment\nOffice\nGraphics" | rofi -dmenu -p "Applications" -i -width 20 -lines 4 -font "mono 12" -padding 20)

case $menu in
    Internet)
        submenu=$(echo -e " Firefox\n Chromium" | rofi -dmenu -p "Internet" -i -width 20 -lines 2 -font "mono 12" -padding 20 -mesg-pre "Submenu: Internet" | awk '{print $2}')
        case $submenu in
            Firefox) firefox & ;;
            Chromium) chromium & ;;
        esac
        ;;
    Development)
        submenu=$(echo -e " VSCode\n Terminal" | rofi -dmenu -p "Development" -i -width 20 -lines 2 -font "mono 12" -padding 20 -mesg-pre "Submenu: Development" | awk '{print $2}')
        case $submenu in
            VSCode) code & ;;
            Terminal) i3-sensible-terminal & ;;
        esac
        ;;
    Office)
        submenu=$(echo -e " LibreOffice\n PDF Viewer" | rofi -dmenu -p "Office" -i -width 20 -lines 2 -font "mono 12" -padding 20 -mesg-pre "Submenu: Office" | awk '{print $2}')
        case $submenu in
            LibreOffice) libreoffice & ;;
            "PDF Viewer") xreader & ;;
        esac
        ;;
    Graphics)
        submenu=$(echo -e " GIMP\n Inkscape" | rofi -dmenu -p "Graphics" -i -width 20 -lines 2 -font "mono 12" -padding 20 -mesg-pre "Submenu: Graphics" | awk '{print $2}')
        case $submenu in
            GIMP) gimp & ;;
            Inkscape) inkscape & ;;
        esac
        ;;
esac
