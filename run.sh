#Basic Script to build kernel 

#!/bin/bash
export ARCH=arm64
export SUBARCH=arm64
TC_DIR="/home/ubuntu/Kernel"
MPATH="$TC_DIR/clang12/bin/:$PATH"
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

cp out/arch/arm64/boot/Image.gz-dtb /home/ubuntu/Kernel/Anykernel
cd /home/ubuntu/Kernel/Anykernel
if [ -f "Image.gz-dtb" ]; then
    zip -r9 Ryzen+-violet-"$DATE".zip * -x .git README.md *placeholder
    echo "Build success!"
else
    echo "Build failed!"
fi
