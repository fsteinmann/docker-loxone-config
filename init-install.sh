#!/bin/bash
echo
echo
echo
echo
echo
echo "Installing CLEAN LoxoneConfig into ./config/wine directory"
echo
read -p "Press enter to continue"
echo

if [ ! -f "/config/LoxoneConfigSetup.exe" ]; then
  cd /config
  echo "Try to auto download loxone config installer.."
  # urgh, loxone doesn't provide a direct link to latest installer and changed the website lately, lets parse out the download link while we cry a little
  wget -O i.zip $(wget -O - https://www.loxone.com/enen/support/downloads/ 2>/dev/null | /extract-loxconfig.sh)
  unzip i.zip && rm i.zip

  if [ ! -f "/config/LoxoneConfigSetup.exe" ]; then
    echo "ERROR: ./config/LoxoneConfigSetup.exe missing! auto download failed too! please put installer file there.."
    read -n 1 -s -r -p "Press any key to continue"
    exit 1
  fi
fi

export WINEDEBUG=-all

echo Installing winetricks helper for fonts and sharper rendering..
/usr/bin/winetricks fontsmooth=rgb
#/usr/bin/winetricks corefonts
/usr/bin/winetricks gdiplus
# Align resolution to fix mouse coordinate offset
echo Create Remote Desktop and resize it to ${iDISPLAY_WIDTH:-1920}x${DISPLAY_HEIGHT:-1080}...
DISPLAY_WIDTH_HEX=$(printf "0x%X" ${DISPLAY_WIDTH:-1920})
DISPLAY_HEIGHT_HEX=$(printf "0x%X" ${DISPLAY_HEIGHT:-1080})
wine reg add "HKEY_CURRENT_USER\\Software\\Wine\\Direct3D" /v VirtualDesktop /t REG_SZ /d Y /f 2>/dev/null || true
wine reg add "HKEY_CURRENT_USER\\Software\\Wine\\Direct3D" /v VirtualDesktopWidth /t REG_DWORD /d ${DISPLAY_WIDTH_HEX} /f 2>/dev/null || true
wine reg add "HKEY_CURRENT_USER\\Software\\Wine\\Direct3D" /v VirtualDesktopHeight /t REG_DWORD /d ${DISPLAY_HEIGHT_HEX} /f 2>/dev/null || true
echo Installing LoxoneConfig..
wine "/config/LoxoneConfigSetup.exe"
echo Install finished. yay!
exit 0
