#!/data/data/com.termux/files/usr/bin/bash

if [ -e /dev/block/loop777p1 ]
then
    echo 'Disk telah diatur!'
else
    echo 'Mengatur disk,...'
    losetup --partscan /dev/block/loop777 /storage/sdcard1/rootfs/armedslackfs.img
    echo 'OK!'
fi

if [ -e ~/slackware/root ]
then
    echo 'Disk telah ditautkan!'
else
    echo 'Menautkan disk,...'
    /system/bin/mount -w -t ext4 /dev/block/loop777p1 ~/slackware
    echo 'OK!'
fi

unset LD_PRELOAD
unset HOSTNAME
export HOSTNAME=slackware

proot --link2symlink -0 -r ~/slackware -b /dev/ -b /sys/ -b /proc/ -b /storage/ -b $HOME -w /root /data/data/com.termux/files/home/slackware/bin/env -i HOME=/root TERM="$TERM" PS1='[termux@slackware \W]\# ' LANG=$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
