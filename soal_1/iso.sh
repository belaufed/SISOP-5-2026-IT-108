#!/bin/bash
set -e

rm -rf iso
mkdir -p iso/boot/grub

cp osboot/bzImage iso/boot/
cp osboot/single.gz iso/boot/
cp osboot/multi.gz iso/boot/

cat > iso/boot/grub/grub.cfg << EOF
set timeout=5
set default=0

menuentry "Single User" {
    linux /boot/bzImage console=ttyS0
    initrd /boot/single.gz
}

menuentry "Multi User" {
    linux /boot/bzImage console=ttyS0
    initrd /boot/multi.gz
}
EOF

grub-mkrescue -o osboot/farewell.iso iso

echo "ISO selesai -> osboot/farewell.iso"
