#This is a repo of scripts that i am using for building kernel

Explaining the script

export ARCH=arm64 - Change according to your device 

export SUBARCH=arm64 - Change according to your device 

TC_DIR="/home/ubuntu/Kernel" - TC_DIR = Tool chain directory 

MPATH="$TC_DIR/clang12/bin/:$PATH" - MPATH = Tool chain bin directory 

rm -f out/arch/arm64/boot/Image.gz-dtb - Removing previously compiled kernel Image.gz-dtb 

make O=out vendor/violet-perf_defconfig - Show your deconfig file

PATH="$MPATH" make -j32 O=out \ - j= no of cores

NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    LD=ld.lld \               - This are kernel need files
    
CROSS_COMPILE=aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
        CC=clang \            - CC=clang is your compiler use GCC instead of clang according to the toolchain you are using 
        
AR=llvm-ar \
        OBJDUMP=llvm-objdump \
        STRIP=llvm-strip      - This are kernel need files
        
2>&1 | tee error.log  - save logs    
