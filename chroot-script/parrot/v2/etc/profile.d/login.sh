#!/bin/bash

if [ -e /tmp/startx.y ]
then
  export PULSE_SERVER=tcp:127.0.0.1
  export DISPLAY=:0
  export TMPDIR=/tmp
  export XDG_RUNTIME_DIR=/tmp/XDG
  sleep 5
  dbus-launch --exit-with-session xfce4-session --display=:0
  sleep 2
  pkill -9 dbus*
  pkill -9 xiccd
  exit
fi
