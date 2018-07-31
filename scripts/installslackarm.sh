#!/data/data/com.termux/files/usr/bin/bash
#
# Script installer Slackware-current ARM
#
# Oleh          : mongkeelutfi
# Email         : mongkee.lutfi@gmail.com
# Blog          : https://blog.dhocnet.work
# Kode sumber   : https://github.com/dhocnet/termux/scripts/
#
# Tanggal       : 31 Juli 2018

PKG_MINI="a/aaa_base a/aaa_elflibs a/aaa_terminfo a/acl a/attr a/bash a/bin a/btrfs-progs a/bzip2 a/coreutils a/dbus a/dcron a/devs a/dialog a/e2fsprogs a/ed a/elvis a/etc a/file a/findutils a/hostname a/hwdata a/lbzip2 a/lvm2 a/less a/gawk a/gettext a/getty-ps a/glibc-solibs a/glibc-zoneinfo a/gptfdisk a/grep a/gzip a/kbd a/jfsutils a/inotify-tools a/kmod a/lrzip a/lzip a/lzlib a/mtd-utils a/pkgtools a/procps-ng a/reiserfsprogs a/shadow a/sed a/sysklogd a/sysvinit a/sysvinit-scripts a/tar a/eudev a/libgudev a/usbutils a/util-linux a/vboot-utils a/which a/xfsprogs a/xz ap/groff ap/man-db ap/man-pages ap/nano ap/slackpkg d/perl n/openssl n/ca-certificates n/dhcpcd n/gnupg n/lftp n/libmnl n/network-scripts n/nfs-utils n/ntp n/iputils n/net-tools n/iproute2 n/openssh n/rpcbind n/libtirpc n/rsync n/telnet n/traceroute n/wget n/wpa_supplicant n/wireless-tools l/lzo l/libnl3 l/libidn l/libunistring l/mpfr l/ncurses l/pcre"
INSTALLPKG_DL="https://mirrors.slackware.bg/slackware/slackware-current/source/a/pkgtools/scripts"
INSTALL_SYS=$HOME/slackware/tmp/installpkg
UPGRADE_SYS=$HOME/slackware/tmp/upgradepkg
WGET_P=$HOME/slackware/tmp/pkg
SCRIPT_PEMICU="IyEvZGF0YS9kYXRhL2NvbS50ZXJtdXgvZmlsZXMvdXNyL2Jpbi9iYXNoCgp1bnNldCBMRF9QUkVM
T0FECnByb290IFwKICAgIC0tbGluazJzeW1saW5rIFwKICAgIC1PIFwKICAgIC1yICRIT01FL3Ns
YWNrd2FyZSBcCiAgICAtYiAvZGV2LyBcCiAgICAtYiAvc3lzLyBcCiAgICAtYiAvcHJvYy8gXAog
ICAgLWIgL3N0b3JhZ2UvIFwKICAgIC1iICRIT01FIFwKICAgIC13IC9yb290IFwKICAgIC9iaW4v
ZW52LyBcCiAgICAtaSBIT01FPS9yb290IFwKICAgIFRFUk09IiRURVJNIiBcCiAgICBQUzE9J1ty
b290QHNsYWNrd2FyZSBcd10jICcgXAogICAgTEFORz1lbl9VUy5VVEYtOCBcCiAgICBQQVRIPS9i
aW46L3Vzci9iaW46L3NiaW46L3Vzci9zYmluIFwKICAgIC9iaW4vYmFzaCAtLWxvZ2luCg=="

SETUP_MULAI () {
    clear
    echo "Anda membutuhkan beberapa program lain untuk instalasi Slackware-current ARM. Yaitu \n 1) wget \n 2) tar \n 3) proot \n 4) dialog \n "
    read -p 'Install program [Y/n]? ' ins_y
    if [ $ins_y == "n" ]
    then
        SETUP_BATAL
    else
        SETUP_TERMUX
    fi
}

SETUP_BATAL () {
    clear
    echo "Istalasi Slackware-current ARM dibatalkan!"
    break
}

SETUP_TERMUX () {
    apt -y update && apt -y install dialog proot tar wget
    SETUP_SELECT
}

SETUP_SELECT () {
    clear
    echo "-- PILIH JENIS INSTALASI -- \n \n 1) Miniroot (default) - Perlu disk 500MB \n 2) Development - Perlu disk 4GB \n "
    read -p "Pilihan (default: 1) [1/2]: " pilih_tipe
    if [ $pilih_tipe == '2' ]
    then
        touch $HOME/slackware/tmp/insDEV.y
    fi
    INSTALL_DEFAULT
}

INSTALL_DEFAULT () {
    clear
    mkdir -p $HOME/slackware/tmp/pkg
    echo "Mengunduh program installer: installpkg"
    wget -c -t 0 $INSTALLPKG_DL/installpkg -O $WGET_P/../installpkg
    for PKG_TODL in $PKG_MINI ; do
        wget -c -t 0 -P $WGET_P https://mirrors.slackware.bg/$ARCH_SELECT/$PKG_TODL-*.t[gx]z
    done
    $INSTALL_SYS --terse --root $HOME/slackware/ $WGET_P/*.t?z
    if [ -e $HOME/slackware/tmp/insDEV.y ]
    then
        rm $HOME/slackware/tmp/insDEV.y
        INSTALL_DEVEL
    else
        INSTALL_STATER
    fi
}

INSTALL_DEVEL () {
    clear
    PKG_DEVDIR="a ap d l t"
    echo "Mengunduh program installer: upgradepkg"
    wget -c -t 0 $INSTALLPKG_DL/upgradepkg -O $WGET_P/../upgradepkg
    for PKG_DEVDL in $PKG_DEVDIR ; do
        wget -c -t 0 -r -np -nd -A t[xg]z -P $WGET_P https://mirrors.slackware.bg/$ARCH_SELECT/$PKG_DEVDL/
    done
    ROOT=$HOME/slackware
    $UPGRADE_SYS --install-new $WGET_P/*.t?z
    INSTALL_STATER
}

INSTALL_STATER () {
    clear
    echo "Memasang script pemicu ..."
    base64 -d $SCRIPT_PEMICU > $HOME/../usr/bin/startslack
    chmod +x $HOME/../usr/bin/startslack
    echo "OK ..."
    clear
    echo "Membersihkan sisa-sisa instalasi ..."
    rm -vrf $HOME/slackware/tmp/*
    echo "OK ..."
    sleep 1
    CARA_PAKAI
}

CARA_PAKAI () {
    clear
    echo "SELAMAT! Anda telah berhasil memasang Slackware Linux (current-$SELECT_ARCH) di perangkat Android.\n \n Untuk menjalankan, gunakan perintah: startslack \n \n "
}


SELECT_ARCH=`uname -m`
if [ $SELECT_ARCH == 'armv71' ]
then
    ARCH_SELECT="slackwarearm/slackwarearm-current/slackware"
elif [ $SELECT_ARCH == "aarch64" ]
then
    ARCH_SELECT="slarm64/slarm64-current/slarm64"
else
    clear
    echo "Arsitektur tidak terdeteksi!"
    SETUP_BATAL
fi

SETUP_MULAI
