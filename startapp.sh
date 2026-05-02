#!/bin/sh

if [ ! -d "/config/wine/drive_c/Program Files (x86)/Loxone" ]; then
  xterm -e /bin/sh -lc '/init-install.sh 2>&1 | tee -a /config/log/xterm.log' || exit 1
fi

export WINEDEBUG=-all
setxkbmap $XLANG
#exec xterm
exec wine "/config/wine/drive_c/Program Files (x86)/Loxone/LoxoneConfig/LoxoneConfig.exe"
