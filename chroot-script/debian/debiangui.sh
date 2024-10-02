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

# memulai debian dengan GUI
# jika memiliki usee biasa, tambahkan: --user namauser \
# diatas baris --shared-tmp
proot-distro login debian \
  # hilangkan tanda pagar dibawah ini, lalu ganti username
  # dengan nama user kamu, jika ada.
  #--user username \
  --shared-tmp \
  -- /bin/bash -c "
    export PULSE_SERVER=tcp:127.0.0.1
    termux-x11 :0 -xstartup \"dbus-run-session startlxqt\"" &&

exit 1
