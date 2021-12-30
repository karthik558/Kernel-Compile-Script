#Basic Script to build kernel

#!/bin/bash
cd RyZeN
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_HOST="NOT-GAMING-KERNEL"
export KBUILD_BUILD_USER="K A R T H I K"
MAKE="./makeparallel"

# Set Date
DATE=$(TZ=Asia/Jakarta date +"%Y%m%d")

# For end-time
BUILD_START=$(date +"%s")

blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

TC_DIR="/home/karthik558/Workspace/"
MPATH="$TC_DIR/CLANG-13/bin/:$PATH"
rm -f out/arch/arm64/boot/Image.gz-dtb
make O=out vendor/violet-perf_defconfig
PATH="$MPATH" make -j16 O=out \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    LD=ld.lld \
        CROSS_COMPILE=aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
        CC=clang \
        AR=llvm-ar \
        OBJDUMP=llvm-objdump \
        STRIP=llvm-strip \
        2>&1 | tee error.log

# Copying Image.gz-dtb to anykernel
cp out/arch/arm64/boot/Image.gz-dtb /home/karthik558/Workspace/Anykernel
cd /home/karthik558/Workspace/Anykernel

# Ziping Kernel using Anykernel
if [ -f "Image.gz-dtb" ]; then
    zip -r9 RyZeN-violet-S-$DATE.zip * -x .git README.md *placeholder
cp /home/karthik558/Workspace/Anykernel/RyZeN-violet-S-$DATE.zip /home/karthik558/Workspace/
rm /home/karthik558/Workspace/Anykernel/RyZeN-violet-S-$DATE.zip
rm /home/karthik558/Workspace/Anykernel/Image.gz-dtb

# Signzip using zipsigner
cd /home/karthik558/Workspace/
# curl -sLo zipsigner-3.0.jar https://github.com/Magisk-Modules-Repo/zipsigner/raw/master/bin/zipsigner-3.0-dexed.jar
java -jar zipsigner-3.0.jar RyZeN-violet-S-$DATE.zip RyZeN-violet-S-$DATE-signed.zip

# Remove unsigned build
rm RyZeN-violet-S-$DATE.zip

# Build Completed
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

    echo "Build success!"
else
    echo "Build failed!"
fi
