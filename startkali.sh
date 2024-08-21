#!/data/data/com.termux/files/usr/bin/bash

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
XDG_RUNTIME_DIR=$KALIROOT/tmp/XDG
TMPDIR=/$KALIROOT/tmp

# tempel berkas sistem ke berkas chroot
su -c "$BBX mount -o remount,dev,suid /data"
su -c "$BBX mount --bind /dev $KALIROOT/dev"
su -c "$BBX mount --bind /dev/pts $KALIROOT/dev/pts"
su -c "$BBX mount --bind /proc $KALIROOT/proc"
su -c "$BBX mount --bind /sys $KALIROOT/sys"

su -c "$BBX mount -t tmpfs -o size=256M tmpfs $KALIROOT/dev/shm"

# start x11 server
termux-x11 :0 -ac &

# chroot ke kali linux
su -c "$BBX chroot $KALIROOT /bin/su - kali"

# matikan servis x11
pkill -9 app_process

# lepas tempelan sistem
su -c "umount -f $KALIROOT/dev/pts"
su -c "umount -f $KALIROOT/dev/shm"
su -c "umount -f $KALIROOT/dev"
su -c "umount -f $KALIROOT/proc"
su -c "umount -f $KALIROOT/sys"

echo -e "\n OKE!"
