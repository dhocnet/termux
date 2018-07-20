#!/data/data/com.termux/files/usr/bin/bash

losetup -l /dev/block/loop999 | grep fedorafs.img > /dev/null

if [ $? = 0 ]
then
    echo 'Disk telah diatur!'
else
    echo 'Mengatur disk,...'
    losetup --partscan /dev/block/loop999 /storage/sdcard1/rootfs/fedorafs.img
    echo 'OK!'
fi

if [ -e ~/fedora/root ]
then
    echo 'Disk telah ditautkan!'
else
    echo 'Menautkan disk,...'
    /system/bin/mount -w -t ext4 /dev/block/loop999p1 ~/fedora
    echo 'OK!'
fi

unset LD_PRELOAD

proot --link2symlink -0 -r ~/fedora -b /dev/ -b /sys/ -b /proc/ -b /storage/ -b $HOME -w /root /data/data/com.termux/files/home/fedora/bin/env -i HOME=/root TERM="$TERM" PS1='[termux@fedora \W]\# ' LANG=$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
