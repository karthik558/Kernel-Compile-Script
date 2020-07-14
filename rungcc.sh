#!/bin/bash
export ARCH=arm64
export SUBARCH=arm64
TC_DIR="/home/karthiksp/Kernel"
MPATH="TC_DIR/toolchains/bin/:$PATH"
MPATH="$TC_DIR/toolchain32/bin/:$PATH"
MPATH="$TC_DIR/toolchain/bin/:$MPATH"
rm -f out/arch/arm64/boot/Image.gz-dtb
make O=out vendor/violet-gcc_defconfig
PATH="$MPATH" make -j4 O=out \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    LD=ld.lld \
        CROSS_COMPILE=aarch64-elf- \
        CROSS_COMPILE_ARM32=arm-eabi- \
        CC=gcc \
        AR=llvm-ar \
        OBJDUMP=llvm-objdump \
        STRIP=llvm-strip
        2>&1 | tee error.log
        
        
        
        
      

