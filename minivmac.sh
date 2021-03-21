#!/bin/sh
if [ -x "$0-bin" -a -d /usr/share/minivmac/roms ]; then
  "$0-bin" -d /usr/share/minivmac/roms
else
  echo "Failed to find executable '$0-bin' or directory '/usr/share/minivmac/roms'."
  exit 1
fi
