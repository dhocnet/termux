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
#               : 01 Agustus 2018

# mengaktifkan teks blinkblink - text formating
shopt -s xpg_echo

# paket miniroot
PKG_MINI="a/aaa_base a/aaa_elflibs a/aaa_terminfo a/acl a/attr a/bash a/bin a/btrfs-progs a/bzip2 a/coreutils a/dbus a/dcron a/devs a/dialog a/e2fsprogs a/ed a/etc a/file a/findutils a/hostname a/hwdata a/lbzip2 a/lvm2 a/less a/gawk a/gettext a/getty-ps a/glibc-solibs a/glibc-zoneinfo a/gptfdisk a/grep a/gzip a/jfsutils a/inotify-tools a/kmod a/lrzip a/lzip a/lzlib a/pkgtools a/procps-ng a/reiserfsprogs a/shadow a/sed a/sysklogd a/usbutils a/util-linux a/which a/xfsprogs a/xz ap/groff ap/man-db ap/man-pages ap/nano ap/slackpkg d/perl n/openssl n/ca-certificates n/dhcpcd n/gnupg n/lftp n/libmnl n/network-scripts n/nfs-utils n/ntp n/iputils n/net-tools n/iproute2 n/openssh n/rpcbind n/libtirpc n/rsync n/telnet n/traceroute n/wget n/wpa_supplicant n/wireless-tools l/lzo l/libnl3 l/libidn l/libunistring l/mpfr l/ncurses l/pcre"

# slackware pkgtools modifikasi untuk digunakan pada termux
INSTALLPKG_DL="https://raw.githubusercontent.com/dhocnet/termux/master/scripts/netinstall/slackware"

# slackware pkgtools
INSTALL_SYS=$HOME/slackware/tmp/installpkg
UPGRADE_SYS=$HOME/slackware/tmp/upgradepkg

# download folder sementara
WGET_P=$HOME/slackware/tmp/pkg

# slackware chroot script
SCRIPT_PEMICU="IyEvZGF0YS9kYXRhL2NvbS50ZXJtdXgvZmlsZXMvdXNyL2Jpbi9iYXNoCgp1bnNldCBMRF9QUkVM
T0FECnByb290IFwKICAgIC0tbGluazJzeW1saW5rIFwKICAgIC1PIFwKICAgIC1yICRIT01FL3Ns
YWNrd2FyZSBcCiAgICAtYiAvZGV2LyBcCiAgICAtYiAvc3lzLyBcCiAgICAtYiAvcHJvYy8gXAog
ICAgLWIgL3N0b3JhZ2UvIFwKICAgIC1iICRIT01FIFwKICAgIC13IC9yb290IFwKICAgIC9iaW4v
ZW52LyBcCiAgICAtaSBIT01FPS9yb290IFwKICAgIFRFUk09IiRURVJNIiBcCiAgICBQUzE9J1ty
b290QHNsYWNrd2FyZSBcd10jICcgXAogICAgTEFORz1lbl9VUy5VVEYtOCBcCiAgICBQQVRIPS9i
aW46L3Vzci9iaW46L3NiaW46L3Vzci9zYmluIFwKICAgIC9iaW4vYmFzaCAtLWxvZ2luCg=="

SETUP_MULAI () {
    clear
    # konfirmasi instalasi paket yang dibutuhkan oleh slackware pkgtools
    echo "Anda membutuhkan beberapa program lain untuk \nmenyelesaikan instalasi Slackware-current ARM. Yaitu:\n\n 1) wget\n 2) coreutils\n 3) proot\n 4) util-linux\n 5) grep\n 6) Dialog\n 7) lzip\n"
    read -p 'Install program [Y/n]? ' ins_y
    if [ $ins_y = "n" ]
    then
        SETUP_BATAL
    else
        SETUP_TERMUX
    fi
}

SETUP_BATAL () {
    clear
    echo "Istalasi Slackware-current ARM dibatalkan!\n"
}

SETUP_TERMUX () {
    clear
    echo "Menginstal program yang dibutuhkan ...\n"
    apt -y upgrade && apt -y install grep coreutils lzip proot tar wget util-linux dialog
    sleep 1
    SETUP_SELECT
}

SETUP_SELECT () {
    clear
    echo "PILIH JENIS INSTALASI\n\n 1) Miniroot (default) - Perlu disk 500MB\n 2) Development - Perlu disk 4GB\n"
    read -p 'Pilihan (default: 1) [1/2]: ' pilih_tipe
    if [ $pilih_tipe = "2" ]
    then
        touch $HOME/slackware/tmp/insDEV.y
    fi
    INSTALL_DEFAULT
}

INSTALL_DEFAULT () {
    clear
    mkdir -p $HOME/slackware/tmp/pkg
    echo "Mengunduh program installer: installpkg"
    wget -c -t 0 -P $WGET_P/../ -q --show-progress $INSTALLPKG_DL/installpkg
    chmod +x $WGET_P/../installpkg
    echo "OK."
    echo "Mengunduh paket dasar miniroot:"
    sleep 1
    for PKG_TODL in $PKG_MINI ; do
        wget -c -t 0 -T 10 -w 5 -P $WGET_P -q --show-progress ftp://mirrors.slackware.bg/$ARCH_SELECT/$PKG_TODL-*.t?z
    done
    echo "OK."
    echo "Memasang sistem dasar Slackware miniroot ..."
    sleep 2
    # buang pesan error yang timbul karena perintah perintah dari installscript doinst.sh
    # biasanya masalah yang timbul karena kesalahan chown fulan.binfulan atau perintah chroot
    # yang tidak terdapat pada termux environment
    $INSTALL_SYS --terse --root $HOME/slackware/ $WGET_P/*.t?z 2> /dev/null
    echo "Memeriksa pilihan Development ..."
    sleep 1
    if [ -e $HOME/slackware/tmp/insDEV.y ]
    then
        echo "Ditemukan!\nMelanjutkan instalasi paket Development ..."
        rm $HOME/slackware/tmp/insDEV.y
        sleep 1
        INSTALL_DEVEL
    else
        echo "Tidak ditemukan!\nMenyelesaikan instalasi ..."
        sleep 1
        INSTALL_STATER
    fi
}

INSTALL_DEVEL () {
    clear
    PKG_DEVDIR="a ap d l t"
    echo "Mengunduh program installer: upgradepkg, removepkg"
    wget -c -t 0 -P $WGET_P/../ -q --show-progress $INSTALLPKG_DL/{removepkg,upgradepkg}
    echo "OK.\n\nMengunduh paket Development:"
    chmod +x $WGET_P/../{removepkg,upgradepkg}
    sleep 1
    for PKG_DEVDL in $PKG_DEVDIR ; do
        wget -c -t 0 -r -np -nd -q --show-progress -T 10 -w 5 -A '.t{g,x}z' -P $WGET_P https://mirrors.slackware.bg/$ARCH_SELECT/$PKG_DEVDL/
    done
    echo "OK.\nMemasang paket Development:"
    sleep 1
    ROOT=$HOME/slackware
    $UPGRADE_SYS --install-new $WGET_P/*.t?z 2> /dev/null
    echo "\n\nInstalasi paket Development selesai.\nMelanjutkan finishing ..."
    sleep 1
    INSTALL_STATER
}

INSTALL_STATER () {
    clear
    echo "Memasang script pemicu ..."
    base64 -d < $SCRIPT_PEMICU > $HOME/../usr/bin/slackwarego
    chmod +x $HOME/../usr/bin/startslack
    echo "OK ..."
    clear
    echo "Membersihkan sisa-sisa instalasi ..."
    sleep 1
    rm -vrf $HOME/slackware/tmp/*
    echo "OK ..."
    sleep 1
    CARA_PAKAI
}

CARA_PAKAI () {
    clear
    echo "SELAMAT! Anda telah berhasil memasang Slackware Linux (current-$SELECT_ARCH) di perangkat Android.\n\n
    Oleh    : mongkeelutfi\n
    Info    : mongkee@gmail.com\n
    Blog    : https://blog.dhocnet.work\n
    Proyek  : https://github.com/dhocnet/termux\n\n
    01 Aggustus 2018, Denpasar, Bali\n\n
    Untuk menjalankan, gunakan perintah: startslack\n\n"
}

clear
echo "\nSlackware ARM - NetInstall\n-> https://github.com/dhocnet/termux/"
sleep 2

SELECT_ARCH=`uname -m`
if [ $SELECT_ARCH == 'armv7l' ]
then
    echo "\nTerdeteksi arsitektur ponsel; $SELECT_ARCH"
    ARCH_SELECT="slackwarearm/slackwarearm-current/slackware"
    sleep 2
    SETUP_MULAI
elif [ $SELECT_ARCH == "aarch64" ]
then
    echo "\nTerdeteksi arsitektur ponsel: $SELECT_ARCH"
    ARCH_SELECT="slarm64/slarm64-current/slarm64"
    sleep 2
    SETUP_MULAI
else
    echo "\nArsitektur ponsel belum didukung!\nArsitektur: $SELECT_ARCH"
    sleep 3
    SETUP_BATAL
fi

