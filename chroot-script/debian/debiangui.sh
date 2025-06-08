#!/data/data/com.termux/files/usr/bin/bash

# memulai termux x11 app
am start --user 0 -n \
  com.termux.x11/com.termux.x11.MainActivity

# memulai server audio
pulseaudio --start \
  --load="module-native-protocol-tcp
    auth-ip-acl=127.0.0.1
    auth-anonymous=1" \
  --exit-idle-time=-1

pacmd load-module \
  module-native-protocol-tcp \
  auth-ip-acl=127.0.0.1 \
  auth-anonymous=1

# start x11 server
termux-x11 :0 -ac &

# memulai debian dengan GUI
# default script ini menjalankan desktop LXQT
# jika kamu menggunakan desktop lain, silahkan disesuaikan
# dengan mengganti "startlxqt" dengan startup desktop kalian.
# misalnya dengan "startlxde" untuk desktop LXDE
# atau "startxfce" jika menggunakan desktop XFCE4
proot-distro login debian \
  # hilangkan tanda pagar dibawah ini, lalu ganti username
  # dengan nama user kamu, jika ada.
  #--user username \
  --shared-tmp \
  -- /bin/bash -c "export PULSE_SERVER=tcp:127.0.0.1
    dbus-run-session startlxqt" &&

pkill -9 app_process
exit 1
