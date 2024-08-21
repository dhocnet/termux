#!/bin/bash

#
# Install Script khusus Kali Nethuhter
# 
# Script ini dibuat khusus untuk demonstrasi konten pada saluran
# https://youtube.com/@HotPrendRoom dan mungkin tidak berfungsi
# untuk konfigurasi yang berbeda.
#

#
# Oleh    : dhocnet <desktop.hobbie@gmail.com>
# Dibuat  : 21 Agustus 2024
# Dirubah : 21 Agustus 2024
#
# Info    : https://dhocnet.work
#

function CEKDULU() {
  # memeriksa lingkungan, apakah berjalan pada Termux, atau tidak.
  if [ -e "/etc/os-release" ]
  then
    # memeriksa apakah pengguna adalah root?
    if [ "$(whoami)" = "root" ]
    then
      echo "Instalasi sedang berlangsung ..."
      PASANGDULU
    else
      echo "Jalankan script sebagai root!"
      KELUAR
    fi
  else
    echo "Jalankan script setelah melakukan chroot!"
    KELUAR
  fi
}

function PASANGDULU() {
  # memasang script ke folder /var/lib
  echo "Memasang script login dan logout ..."
  sleep 0.5
  cp login logout /var/lib
  # merubah mode ke executable
  echo "Mengatur script login dan logout ..."
  sleep 0.5
  chmod a+x /var/lib/{login,logout}
  # mengatur autorun script login dan logout
  echo "Menyetel autorun untuk user kali..."
  sleep 0.5
  echo "source /var/lib/login" >> /home/kali/{.bashrc,.zshrc}
  echo "source /var/lib/logout" >> /home/kali/{.bash_logout,.zlogout}
  # memastikan jika 4 file tersebut masih milik user kali
  echo "Memperbaiki permission ..."
  sleep 0.5
  chown kali:kali /home/kali/{.bashrc,.zshrc,.bash_logout,.zlogout}
  # selesai.
  echo "Beres!"
  KELUAR
}

function KELUAR() {
  exit 1
}

CEKDULU
