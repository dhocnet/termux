#!/bin/bash

# hanya untuk berjaga-jaga, jika saja telah dilakukan setup manual
# saat login ke mode teks. Ini untuk memastikan jika shell tidak
# tersangkut antara chroot dan termux
pkill -9 dbus*
pkill -9 xiccd
