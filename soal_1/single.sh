#!/bin/bash
set -e

mkdir -p build
cd build

BUSYBOX=1.36.1

# download busybox
if [ ! -f busybox-$BUSYBOX.tar.bz2 ]; then
    wget https://busybox.net/downloads/busybox-$BUSYBOX.tar.bz2
fi

# extract
if [ ! -d busybox-$BUSYBOX ]; then
    tar xf busybox-$BUSYBOX.tar.bz2
fi

cd busybox-$BUSYBOX

# config
if [ ! -f .config ]; then
    make defconfig
    sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
fi

# build
make -j$(nproc)
make install

cd ../..

# rootfs
rm -rf rootfs-single
mkdir -p rootfs-single

cp -a build/busybox-$BUSYBOX/_install/* rootfs-single/

mkdir -p rootfs-single/{dev,proc,sys,etc,tmp,root}

# init
cat > rootfs-single/init << 'EOF'
#!/bin/sh

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

echo "Farewell Party"
echo "Welcome, root"

exec /bin/sh
EOF

chmod +x rootfs-single/init

# pack
cd rootfs-single
find . | cpio -H newc -ov | gzip > ../osboot/single.gz
cd ..

echo "Single filesystem selesai -> osboot/single.gz"
