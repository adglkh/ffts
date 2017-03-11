#!/bin/sh
# Compiles ffts for hisi platform.
# Make sure you have HISI_ROOT defined in .bashrc or .bash_profile
# Modify INSTALL_DIR to suit your situation

INSTALL_DIR="`pwd`/bin"

case $(uname -s) in
  Darwin)
    CONFBUILD=i386-apple-darwin`uname -r`
    HOSTPLAT=darwin-x86
  ;;
  Linux)
    CONFBUILD=x86-unknown-linux
    HOSTPLAT=linux-`uname -m`
  ;;
  *) echo $0: Unknown platform; exit
esac

TARGET_PLATFORM=arm-hisiv300-linux
ARCH=arm
CONFIG_ARG=arm-eabi

: ${HISI_ROOT:?}

echo "Using: $HISI_ROOT/target/bin/"

export PATH="$HISI_ROOT/target/bin/:$PATH"
export SYS_ROOT="$HISI_ROOT/target/:$PATH"
export CC="${TARGET_PLATFORM}-gcc --sysroot=$HISI_ROOT/target"
export LD="${TARGET_PLATFORM}-ld"
export AR="${TARGET_PLATFORM}-ar"
export RANLIB="${TARGET_PLATFORM}-ranlib"
export STRIP="${TARGET_PLATFORM}-strip"
export CFLAGS="-Os -mthumb -mcpu=cortex-a7 -mfloat-abi=softfp -mfpu=neon-vfpv4 -mno-unaligned-access -fno-aggressive-loop-optimizations -DHISI"

mkdir -p $INSTALL_DIR
#./configure --enable-neon --build=${CONFBUILD} --host=${CONFIG_ARG} --prefix=$INSTALL_DIR LIBS="-lc -lgcc" 
./configure --enable-neon --build=${CONFBUILD} --host=${CONFIG_ARG} --prefix=$INSTALL_DIR

make clean
make
make install

exit 0
