#!/usr/bin/env bash
set -euo pipefail

TARGET=""
DISK=""

for param in $(cat /proc/cmdline); do
  case "$param" in
    nixos-install.target=*) TARGET="${param#nixos-install.target=}" ;;
    nixos-install.disk=*)   DISK="${param#nixos-install.disk=}" ;;
  esac
done

[[ -z "$TARGET" ]] && { echo "No nixos-install.target in cmdline, exiting."; exit 0; }

if [[ -z "$DISK" ]]; then
  DISK=$(lsblk -dno NAME,RM,TYPE,SIZE --bytes 2>/dev/null \
    | awk '$2=="0" && $3=="disk" { print $4 " /dev/" $1 }' \
    | sort -rn | awk 'NR==1 { print $2 }')
  [[ -z "$DISK" ]] && { echo "Could not auto-detect a disk. Pass nixos-install.disk=/dev/sdX on the kernel cmdline."; exit 1; }
fi

echo "============================================"
echo "  NixOS Unattended Installer"
echo "============================================"
echo "  Target host : $TARGET"
echo "  Target disk : $DISK"
echo "  Flake       : /etc/nixos-installer/flake#${TARGET}"
echo "============================================"
echo "WARNING: ALL DATA ON $DISK WILL BE ERASED IN:"
for i in 10 9 8 7 6 5 4 3 2 1; do
  printf "  %2d seconds... (Ctrl+C to cancel)\r" "$i"
  sleep 1
done
echo ""
echo "Starting installation..."

disko-install \
  --flake "/etc/nixos-installer/flake#${TARGET}" \
  --disk main "${DISK}" \
  --no-root-password

echo ""
echo "============================================"
echo "  Installation complete!"
echo "  Rebooting in 5 seconds..."
echo "============================================"
sleep 5
reboot
