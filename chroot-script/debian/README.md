# DEBIAN GUI LAUNCHER

`debiangui.sh` adalah script peluncur yang akan menjalankan Debian Linux langsung ke mode GUI melalui Termux.

Untuk menggunakan script peluncur ini, kamu harus memasang **Termux-X11 App** dari: https://github.com/termux/termux-x11, `pulseaudio`, dan `file`.

## MEMASANG PULSEAUDIO DAN FILE

Berikut ini adalah cara memasang `pulseaudio` dan `file` melalui Termux:

`~$ apt update && apt -y upgrade` 

`~$ apt -y install pulseaudio file`

## MENJALANKAN DEBIANGUI.SH

Setelah semua kondisi diatas terpenuhi, `debiangui.sh` dapat dijalankan dengan perintah:

`~$ bash debiangui.sh`

## PENGATURAN

Secara default, `debiangui.sh` akan menggunakan user `root` saat login.

Jika kalian telah menyiapkan user biasa pada Debian Linux, maka silahkan rubah isi script peluncur sesuai dengan petunjuk yang ada didalamnya dengan menambah parameter: `--user [namauser] \`.

Tonton cara menambah user baru pada Debian Linux disini: https://youtu.be/FzuVXj0yH8c

## VIDEO DEMONSTRASI

Tonton video demonstrasinya disini: https://youtu.be/nSQIS7gMXlM

