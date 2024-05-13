#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="BalamOs"
iso_label="BALAM_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="BiCH0 <https://balamos.confugiradores.es>"
iso_application="Balam Os Live/Rescue DVD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.grub.esp' 'uefi-x64.grub.esp'
           'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/bin/balamos-install"]="0:0:755"
  ["/usr/bin/balamos-update"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/root/.config/ranger/scope.sh"]="0:0:750"
  ["/home/balam/.config/i3/polybar.sh"]="0:0:750"
  ["/home/balam/.config/i3/i3lock.sh"]="0:0:750"
  ["/home/balam/.config/i3/logout.sh"]="0:0:750"
  ["/home/balam/.config/ranger/scope.sh"]="0:0:750"
  ["/home/balam/fixer.sh"]="0:0:750"
  ["/home/balam/.mozilla/firefox/mozilla.sh"]="0:0:750"
  ["/home/balam/.config/rofi/powermenu/powermenu.sh"]="0:0:750"
  ["/etc/skel/.config/i3/polybar.sh"]="0:0:750"
  ["/etc/skel/.config/i3/i3lock.sh"]="0:0:750"
  ["/etc/skel/.config/i3/logout.sh"]="0:0:750"
  ["/etc/skel/.config/ranger/scope.sh"]="0:0:750"
  ["/etc/skel/.mozilla/firefox/mozilla.sh"]="0:0:750"
  ["/etc/skel/.config/rofi/powermenu/powermenu.sh"]="0:0:750"
  ["/usr/share/wordlists"]="0:0:777"
  ["/usr/share/wordlists/discovery/"]="0:0:777"
  ["/usr/share/wordlists/passwords/"]="0:0:777"
  ["/usr/share/wordlists/discovery/dsstorewordlist.txt.tgz"]="0:0:666"
  ["/usr/share/wordlists/discovery/directory-list-2.3-big.txt.tgz"]="0:0:666"
  ["/usr/share/wordlists/passwords/rockyou.txt.gz"]="0:0:666"
)
