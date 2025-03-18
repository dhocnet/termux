#!/data/data/com.termux/files/usr/bin/bash

#
# Kali Linux chroot start script for Termux
#
# By: Heru N. <desktop.hobbie@gmail.com>
# - https://dhocnet.work
# - https://youtube.com/@dhocnet
# - https://youtube.com/@HotPrendRoom
#

#
# Dimodifikasi untuk chroot di lingkungan Parrot OS
#

function BOOT_MENU() {
  BOOT=$(dialog --backtitle "Termux Loader for Parrot Security OS" \
    --title "Parrot OS Boot Menu" \
    --menu "Choose boot mode." 12 45 25 \
      1 "Parrot OS Text Session" \
      2 "Parrot OS Graphical Session" 2>&1 1>&3)

  if [ "$?" = 0 ]
  then
    export STARTX="$BOOT"
    BOOT_LINUX
  else
    echo "BATAL!"
  fi
}

function BOOT_LINUX() {
  # setup env
  unset LD_PRELOAD
  export ROOTFS="$PREFIX/var/run/parrot-run-session"
  TMPDIR="$PREFIX/tmp"
  XDG_RUNTIME_DIR="$TMPDIR/XDG"
  # internal storage
  BINDIN="/storage/emulated/0"
  # sdcard
  BINDEX="/storage/79dfcd53-3402-493d-a590-bd82a79d47bf"

  # kaitkan img file ke loop device
  sudo losetup loop777 $BINDEX/parrot.img

  # membuat target mount parrot
  if [ ! -e $ROOTFS ]
  then
    sudo mkdir -p $ROOTFS
  fi

  # mount rootfs
  su -c "mount /dev/block/loop777p2 $ROOTFS"

  # ruang kerja x11
  if [ ! -e $ROOTFS/tmp ]
  then
    sudo mkdir -p $ROOTFS/tmp
    sudo chmod a+rwx $ROOTFS/tmp/
  elif [ ! -e $XDG_RUNTIME_DIR ]
  then
    sudo mkdir -p $XDG_RUNTIME_DIR
    sudo chmod a+rwx $XDG_RUNTIME_DIR
  fi

  # mount berkas sistem ke parrot
  su -c "mount -o remount,dev,suid /data"
  su -c "mount --bind /sys $ROOTFS/sys"
  su -c "mount --bind /proc $ROOTFS/proc"
  su -c "mount --bind /dev $ROOTFS/dev"
  su -c "mount --bind /dev/pts $ROOTFS/dev/pts"

  if [ ! -e $ROOTFS/dev/shm ]
  then
    su -c "mkdir $ROOTFS/dev/shm"
  fi
  su -c "mount -t tmpfs -o size=256M tmpfs $ROOTFS/dev/shm"
  su -c "mount --bind $TMPDIR $ROOTFS/tmp"

  # mount penyimpanan internal
  if [ ! -e $ROOTFS/mnt/internal ]
  then
    sudo mkdir -p $ROOTFS/mnt/internal
  fi
  su -c "mount --bind $BINDIN $ROOTFS/mnt/internal"

  # mount sdcard
  if [ ! -e $ROOTFS/mnt/sdcard ]
  then
    sudo mkdir -p $ROOTFS/mnt/sdcard
  fi
  su -c "mount --bind $BINDEX $ROOTFS/mnt/sdcard"

  # start audio server
  pulseaudio --start --load="module-native-protocol-tcp \
    auth-ip-acl=127.0.0.1 \
    auth-anonymouse=1" \
    --exit-idle-time=-1
  pacmd load-module module-native-protocol-tcp \
    auth-ip-acl=127.0.0.1 \
    auth-anonymouse=1

  if [ "$STARTX" = 2 ]
  then
    # START X11 SERVER
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
    termux-x11 :0 -ac 2> /dev/null & 
    su -c "touch $ROOTFS/tmp/startx.y"
  fi
  sudo hostname go-proto3000
  su -c "chroot $ROOTFS /bin/su - haplay"
  pkill -9 app_process
  # LEAVING KALI CHROOT
  CLEANING_CHROOT
}

function CLEANING_CHROOT() {
  if [ "$STARTX" = 2 ]
  then
    su -c "rm $PREFIX/tmp/startx.y"
  fi
  # melepas semua binding
  su -c "umount $ROOTFS/dev/pts"
  su -c "umount $ROOTFS/dev/shm"
  su -c "rm -r $ROOTFS/dev/shm"
  su -c "umount $ROOTFS/dev"
  su -c "umount $ROOTFS/proc"
  su -c "umount $ROOTFS/sys"
  su -c "umount $ROOTFS/tmp"

  # melepas penyimpanan
  su -c "umount $ROOTFS/mnt/internal"
  su -c "umount $ROOTFS/mnt/sdcard"

  # melepas parrot os
  su -c "umount $ROOTFS"

  # melepas loop device
  sudo losetup -d /dev/block/loop777

  # bersihkan folder parrot
  sudo rm -rf $ROOTFS

  echo "DONE!"
}

#
### tidak peelu root untuk memulai
#
if [ "$(whoami)" = "root" ]
then
  echo -e "\n\033[1m\033[5m\033[91m\033[103mROOT DILARANG MASUK!!!\033[0m \n"
  exit 1
fi

exec 3>&1

BOOT_MENU
