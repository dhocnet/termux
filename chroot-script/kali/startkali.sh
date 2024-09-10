#!/data/data/com.termux/files/usr/bin/bash

### KALI NETHUNTER CHROOT LAUNCHER ###
#
# Versi  : 0.01
# Oleh   : dhocnet <desktop.hobbie@gmail.com>
# - https://dhocnet.work
# - https://youtube.com/@dhocnet
# - https://youtube.com/@HotPrendRoom
#
# Diubah: 21/08/2024
#         09/09/2024

# disarankan hanya user biasa yang menjalankan
# script chroot kali linux
if [ "$(whoami)" = "root" ]
then
  echo -e "\nROOT DILARANG MASUK!!! \n"
  exit 1
fi

# setup lingkungan chroot
BBX="$PREFIX/bin/busybox"
KALIROOT="/data/data/com.termux/files/kali-arm64"
TMPDIR="$KALIROOT/tmp"
XDG_RUNTIME_DIR="$KALIROOT/tmp/XDG"

# tempel berkas sistem ke berkas chroot
su -c "$BBX mount -o remount,dev,suid /data"
su -c "$BBX mount --bind /dev $KALIROOT/dev"
su -c "$BBX mount --bind /dev/pts $KALIROOT/dev/pts"
su -c "$BBX mount --bind /proc $KALIROOT/proc"
su -c "$BBX mount --bind /sys $KALIROOT/sys"

# start x11 server
termux-x11 :0 -ac &

# chroot ke kali linux
su -c "$BBX chroot $KALIROOT /bin/su"

# matikan servis x11
pkill -9 app_process

# lepas tempelan sistem
su -c "umount -f $KALIROOT/dev/pts"
su -c "umount -f $KALIROOT/dev"
su -c "umount -f $KALIROOT/proc"
su -c "umount -f $KALIROOT/sys"

echo -e "\n OKE!"
