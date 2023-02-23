#!/usr/bin/env bash

set -euo pipefail

sudo pacman -Syu --noconfirm --needed \
    base-devel \
    git \
    dkms \
    linux-neptune-headers \
    cmake \
    qt5

git clone --recurse-submodules https://github.com/zhaowenlan1779/threeSD.git

cd threeSD

mkdir build
cd build

cmake ..
make

echo "threeSD has been built in $(realpath bin/threeSD)"
