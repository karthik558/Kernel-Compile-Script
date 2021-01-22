#Kernel-Compiling-Script 

#!/bin/bash
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_HOST="R-A-D-E-O-N"
export KBUILD_BUILD_USER="K A R T H I K"
MAKE="./makeparallel"

BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

TC_DIR="/home/ubuntu/Kernel"
MPATH="$TC_DIR/clang/bin/:$PATH"
rm -f out/arch/arm64/boot/Image.gz-dtb
make O=out vendor/violet-perf_defconfig
PATH="$MPATH" make -j32 O=out \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    LD=ld.lld \
        CROSS_COMPILE=aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
        CC=clang \
        AR=llvm-ar \
        OBJDUMP=llvm-objdump \
        STRIP=llvm-strip
        2>&1 | tee error.log

git clone https://android.googlesource.com/platform/system/libufdt scripts/ufdt/libufdt
python2 scripts/ufdt/libufdt/utils/src/mkdtboimg.py create out/arch/arm64/boot/dtbo.img --page_size=4096 out/arch/arm64/boot/dts/qcom/sm6150-idp-overlay.dtbo
cp out/arch/arm64/boot/Image.gz-dtb /home/ubuntu/Kernel/Anykernel
cp out/arch/arm64/boot/dtbo.img /home/ubuntu/Kernel/Anykernel
cd /home/ubuntu/Kernel/Anykernel 
if [ -f "Image.gz-dtb" ]; then
    zip -r9 Ryzen+-violet-dtbo-$(TZ=Asia/Kolkata date +'%M%H-%d%m%Y').zip"* -x .git README.md *placeholder
cp /home/ubuntu/Kernel/Anykernel/Ryzen+-violet-dtbo-$(TZ=Asia/Kolkata date +'%M%H-%d%m%Y').zip /home/ubuntu/Kernel
rm /home/ubuntu/Kernel/Anykernel/Image.gz-dtb
rm /home/ubuntu/Kernel/Anykernel/Ryzen+-violet-dtbo-$(TZ=Asia/Kolkata date +'%M%H-%d%m%Y').zip

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

    echo "Build success!"
else
    echo "Build failed!"
fi
