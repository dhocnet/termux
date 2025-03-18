#!/data/data/com.termux/files/usr/bin/bash

#
# nama: parrotstart.sh
# versi: 0.1
# oleh: dhocnet
# kontak: dhocnet@gmail.com
# situs web: dhocnet.work
#
# script ini digunakan dalam video youtube https://youtube.com/watch?v=ygKkQ4a3oUU
# sebagai sarana demonstrasi metode chroot melalui file raw disk img pada smartphone
# jadul yang memiliki penyimpanan internal dibawah 64GB
#

# lepas ikatan dengan termux loader
unset LD_PRELOAD

# tentukan tujuan mounting
ROOTFS="$PREFIX/var/run/parrot-running-session"

# folder ekstra konfigurasi dan sesi termux-x11
TMPDIR="$PREFIX/tmp"
XDG_RUNTIME_DIR="$TMPDIR/XDG"

# internal storage untuk di binding
BINDIN="/storage/emulated/0"

# sdcard untuk di binding
# catatan: sesuaikan nama folder mount point sdcard dengan perintah lsblk
# atau df -h | grep fuse
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

# memulai termux x11
termux-x11 :0 -ac 2> /dev/null &

# memulai parrot
sudo hostname go-proto3000
su -c "chroot $ROOTFS /bin/su - haplay"

# pembersihan

# menutup termux x11
pkill -9 app_process 2> /dev/null

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
