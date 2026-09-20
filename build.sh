#!/bin/sh
set -e

sudo lb clean --purge

sudo lb config \
  --distribution trixie \
  --architectures amd64 \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debian-installer none \
  --binary-images iso-hybrid \
  --bootappend-live "boot=live components hostname=vamoraos quiet splash"

echo Building ISO...

sudo lb build
