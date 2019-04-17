#!/bin/bash

#install dependencies
apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo libcloog-isl-dev libisl-deva git wget tar make

#create folders and download binutils and gcc
cd $HOME
mkdir src
mkdir opt
mkdir opt/cross
mkdir opt/cross/bin
cd src
git clone https://github.com/bminor/binutils-gdb.git
cd binutils-gdb
mkdir build-binutils
cd $HOME/src
wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-6.3.0/gcc-6.3.0.tar.gz
tar xzf gcc-6.3.0.tar.gz
cd gcc-6.3.0
mkdir build-gcc
cd $HOME/src


export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"


#install binutls
cd binutils-gdb/build-binutils
../configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

#build gcc
cd $HOME/src/gcc-6.3.0/build-gcc
gccwhich -- $TARGET-as || echo $TARGET-as is not in the PATH
../configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc

#update the bashrc so that the cross compiler can be used from anywhere
cd $HOME
echo ' ' >> .bashrc
echo '#make it so the cross compiler can be used from anywhere'
echo 'export PREFIX="$HOME/opt/cross"' >> .bashrc
echo 'export TARGET=i686-elf' >> .bashrc
echo 'export PATH="$PREFIX/bin:$PATH"' >> .bashrc

