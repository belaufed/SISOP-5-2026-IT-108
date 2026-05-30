#!/bin/bash
set -e

BUSYBOX=1.36.1

rm -rf rootfs-multi
mkdir -p rootfs-multi

# copy busybox install dari build sebelumnya
cp -a build/busybox-$BUSYBOX/_install/* rootfs-multi/

# folder utama
mkdir -p rootfs-multi/{dev,proc,sys,etc,tmp,root,home}

# home users
mkdir -p rootfs-multi/home/{henn,hann,viii,kids}

# permission
chmod 700 rootfs-multi/root
chmod 777 rootfs-multi/tmp

chmod 755 rootfs-multi/home/henn
chmod 755 rootfs-multi/home/hann
chmod 755 rootfs-multi/home/viii
chmod 755 rootfs-multi/home/kids

# passwd
cat > rootfs-multi/etc/passwd << EOF
root:x:0:0:root:/root:/bin/sh
henn:x:1000:1000:henn:/home/henn:/bin/sh
hann:x:1001:1001:hann:/home/hann:/bin/sh
viii:x:1002:1002:viii:/home/viii:/bin/sh
kids:x:1003:1003:kids:/home/kids:/bin/sh
EOF

# group
cat > rootfs-multi/etc/group << EOF
root:x:0:
users:x:100:
EOF

# shadow
cat > rootfs-multi/etc/shadow << EOF
root:root123:0:0:99999:7:::
henn:henn123:0:0:99999:7:::
hann:hann123:0:0:99999:7:::
viii:viii123:0:0:99999:7:::
kids:kids123:0:0:99999:7:::
EOF

# init
cat > rootfs-multi/init << 'EOF'
#!/bin/sh

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

clear
echo "===================="
echo " Farewell Party"
echo "===================="
echo "Welcome, root"

exec /bin/sh
EOF

chmod +x rootfs-multi/init

# pack
cd rootfs-multi
find . | cpio -H newc -ov | gzip > ../osboot/multi.gz
cd ..

echo "Multi filesystem selesai -> osboot/multi.gz"
