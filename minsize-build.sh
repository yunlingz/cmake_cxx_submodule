#!/bin/bash

INSTALL_PREFIX="$HOME/opt/tmp_dir"

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DBUILD_SHARED_LIBS=OFF ..
make -j4

# strip
find . -perm +111 -type f -maxdepth 1 -print0 | xargs -0 -I {} strip {}

# upx
find . -perm +111 -type f -maxdepth 1 -print0 | xargs -0 -I {} upx --best {}
