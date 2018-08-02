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
PKG_MINI="a/aaa_base a/aaa_elflibs a/aaa_terminfo a/acl a/attr a/bash a/tar a/bin a/btrfs-progs a/bzip2 a/coreutils a/dbus a/dcron a/devs a/dialog a/e2fsprogs a/ed a/etc a/file a/findutils a/hostname a/hwdata a/lbzip2 a/lvm2 a/less a/gawk a/gettext a/getty-ps a/glibc-solibs a/glibc-zoneinfo a/gptfdisk a/grep a/gzip a/jfsutils a/inotify-tools a/kmod a/lrzip a/lzip a/lzlib a/pkgtools a/procps-ng a/reiserfsprogs a/shadow a/sed a/sysklogd a/usbutils a/util-linux a/which a/xfsprogs a/xz ap/groff ap/man-db ap/man-pages ap/nano ap/slackpkg d/perl d/python d/python-pip d/python-setuptools n/openssl n/ca-certificates n/dhcpcd n/gnupg n/lftp n/libmnl n/network-scripts n/nfs-utils n/ntp n/iputils n/net-tools n/iproute2 n/openssh n/rpcbind n/libtirpc n/rsync n/telnet n/traceroute n/wget n/wpa_supplicant n/wireless-tools l/lzo l/libnl3 l/libidn l/libunistring l/mpfr l/ncurses l/pcre"

# slackware pkgtools modifikasi untuk digunakan pada termux
INSTALLPKG_DL="https://raw.githubusercontent.com/dhocnet/termux/master/scripts/netinstall/slackware"

# slackware pkgtools
INSTALL_SYS=$HOME/slackware/tmp/installpkg
UPGRADE_SYS=$HOME/slackware/tmp/upgradepkg

# download folder sementara
WGET_P=$HOME/slackware/tmp/pkg

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

SETUP_RESUME () {
    clear
    echo "Terdeteksi berkas slackware di sistem folder. Apakah Anda ingin melanjutkan proses instalasi?\n
    Y - Lanjutkan
    N - Install baru (hapus instalasi lama)\n"
    read -p 'Lanjutkan atau install baru [Y/n]? ' SET_RES
    if [ $SET_RES = "n" ]
    then
        clear
        echo "Menghapus instalasi lama ..."
        sleep 1
        chmod -R a+rw $HOME/slackware/usr/ 2> /dev/null
        rm -rf $HOME/slackware 2> /dev/null
        echo "OK."
        sleep 2
        SETUP_TERMUX
    else
        clear
        echo "Pilih tipe instalasi untuk dilanjutkan\n
        1) Lanjutkan instalasi miniroot (default)
        2) Upgrade Miniroot ke Development\n"
        read -p 'Lanjutkan atau upgrade [1/2]? ' SET_UP
        if [ $SET_UP = "2" ]
        then
            INSTALL_DEVEL
        else
            SETUP_SELECT
        fi
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
        if [ ! -d $HOME/slackware/tmp ]
        then
            mkdir -p $HOME/slackware/tmp
        fi
        echo "1" > $HOME/slackware/tmp/insDEV.y
    fi
    INSTALL_DEFAULT
}

INSTALL_DEFAULT () {
    clear
    mkdir -p $WGET_P
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
    if [ -f $HOME/slackware/tmp/insDEV.y ]
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
    #apt -y install lftp
    for PKG_DEVDL in $PKG_DEVDIR ; do
        wget -c -t 0 -r -np -nd -q --show-progress -T 10 -w 5 -A '.txz' -P $WGET_P https://mirrors.slackware.bg/$ARCH_SELECT/$PKG_DEVDL/
        #lftp -c 'open https://mirrors.slackware.bg/$ARCH_SELECT/$PKG_DEVDL/ ; mirror -c -e $WGET_P'
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
    wget -c -q --show-progress -P $HOME/../usr/bin/ https://github.com/dhocnet/termux/raw/master/scripts/launcher/slackwarego
    chmod +x $HOME/../usr/bin/slackwarego
    echo "nameserver 8.8.8.8" > $HOME/slackware/etc/resolv.conf
    echo "OK ..."
    clear
    echo "Membersihkan sisa-sisa instalasi ..."
    sleep 1
    rm -vrf $HOME/slackware/tmp/*
    # hemat penyimpanan internal dari program yang dipasang sebelumnya untuk kebutuhan instalasi
    apt -y remove grep coreutils lzip tar wget util-linux dialog
    apt -y autoremove
    echo "OK ..."
    sleep 1
    CARA_PAKAI
}

CARA_PAKAI () {
    clear
    echo "SELAMAT! Anda telah berhasil memasang Slackware Linux (current-$SELECT_ARCH) di perangkat Android.\n\n
    Oleh    : mongkeelutfi
    Info    : mongkee@gmail.com
    Blog    : https://blog.dhocnet.work
    Proyek  : https://github.com/dhocnet/termux\n
    01 Agustus 2018, Denpasar, Bali\n
    Untuk menjalankan, gunakan perintah: slackwarego\n"
}

clear
echo "\nSlackware ARM - NetInstall\n-> https://github.com/dhocnet/termux/"
sleep 2

SELECT_ARCH=`uname -m`
if [ $SELECT_ARCH == 'armv7l' ]
then
    echo "Terdeteksi arsitektur ponsel; $SELECT_ARCH"
    ARCH_SELECT="slackwarearm/slackwarearm-current/slackware"
    sleep 1
elif [ $SELECT_ARCH == "aarch64" ]
then
    echo "Terdeteksi arsitektur ponsel: $SELECT_ARCH"
    ARCH_SELECT="slarm64/slarm64-current/slarm64"
    sleep 1
else
    echo "Arsitektur ponsel belum didukung!\nArsitektur: $SELECT_ARCH"
    sleep 3
    SETUP_BATAL
fi

if [ -d $HOME/slackware ]
then
    SETUP_RESUME
else
    SETUP_MULAI
fi
