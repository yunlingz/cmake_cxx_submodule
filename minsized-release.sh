#!/bin/bash

BUILD_DIR=$(pwd)/build
INSTALL_PREFIX=$(pwd)/build/release_binary

if [ -d "$BUILD_DIR" ]; then
  exit 1
fi

mkdir $BUILD_DIR
cd $BUILD_DIR
cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DCMAKE_BUILD_TYPE=release -DBUILD_SHARED_LIBS=off ..
make -j4
# strip
find . -perm +111 -type f -maxdepth 1 -print0 | xargs -0 -I {} strip {}
# upx
find . -perm +111 -type f -maxdepth 1 -print0 | xargs -0 -I {} upx --best {}
make install
