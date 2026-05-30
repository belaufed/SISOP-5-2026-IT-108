#!/bin/bash
set -e

VER=6.1.1

mkdir -p build osboot
cd build

if [ ! -f linux-$VER.tar.xz ]; then
    wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$VER.tar.xz
fi

if [ ! -d linux-$VER ]; then
    tar xf linux-$VER.tar.xz
fi

cd linux-$VER

if [ ! -f .config ]; then
    make defconfig
fi

make -j$(nproc)

cp arch/x86/boot/bzImage ../../osboot/

echo "Kernel selesai -> osboot/bzImage"
