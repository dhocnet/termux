#!/bin/bash
#
# slpkg installer untuk Slackware ARM pada termux environment
# adalah bagian dari paket slacknetinstall
#
# Oleh          : mongkeelutfi
# Info          : mongkee.lutfi@gmail.com
# Blog          : https://blog.dhocnet.work
# Kode sumber   : https://github.com/dhocnet/termux/scripts/
#
# Agustus, 01 2018
shopt -s xpg_echo

SBO_NOW=https://slackbuilds.org/slackbuilds/14.2/system/slpkg.tar.gz

# menentukan repositori armv7l (32bit) atau aarch64 (64bit)
ARCH_NOW=$(uname -m)
if [ $ARCH_NOW = "aarch64" ]
then
    NEW_REPO=https://mirrors.slackware.bg/slarm64/slarm64-current/
fi
# membuat direktori konstruksi
echo "Menyiapkan kebutuhan instalasi ..."
if [ ! -d /tmp/slpkg ]
then
    mkdir /tmp/slpkg
fi
sleep 1
# mengunduh pemaket slpkg
WGETFLAGS="--no-check-certificate" slackpkg -dialog=off -default_answer=y install tar
echo "Mengunduh script pemaket ..."
cd /tmp/slpkg
wget -c -t 0 -T 10 -w 5 -q --show-progress $SBO_NOW
sleep 1
# mendapatkan alamat unduh
echo "Mendapatkan alamat unduh ..."
tar xvf slpkg.tar.gz
cd slpkg
cat slpkg.info | grep DOWNLOAD= > slpkg.uri
source <(sed -E -n 's/[^#]+/export &/ p' slpkg.uri)
sleep 1
# mengunduh paket slpkg
echo "Mengunduh paket slpkg ..."
wget -c -t 0 -T 10 -w 5 -q --show-progress $DOWNLOAD
sleep 2
echo "Menjalankan script pemaket ..."
if [ ! -x ./slpkg.SlackBuild ]
then
    chmod +x ./slpkg.SlackBuild
fi
sleep 1
./slpkg.SlackBuild
echo "\n\nOK.\nMemasang paket binari slpkg ..."
sleep 2
installpkg /tmp/slpkg*.t?z
echo "\n\nOK.\nMengatur alamat repository ..."
sleep 2
if [ $ARCH_NOW = "aarch64" ]
then
    slpkg repo-add sl64 $NEW_REPO
fi
echo "\n\nSELESAI!\nSetelah ini, silahkan masuk ke Slackware lalu jalankan perintah:\n\nslpkg update\n\n"
read -p 'Tekan enter untuk melanjutkan ...'
exit
