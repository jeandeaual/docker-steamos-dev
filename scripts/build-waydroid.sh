#!/usr/bin/env bash
# https://gitlab.com/popsulfr/steam-deck-tricks#android-via-waydroid

set -euo pipefail

sudo pacman -Syu --noconfirm --needed \
    base-devel \
    git \
    dkms \
    linux-neptune-headers

for package in anbox-modules-dkms-git libglibutil libgbinder python-gbinder waydroid python-pyclip; do
    git clone "https://aur.archlinux.org/${package}.git"

    cd "${package}"

    if [[ "${package}" == anbox-modules-dkms-git ]]; then
        sed -i 's/\b\(sed\s\+.*#if\s\+1.*binder\.c\s*\)$/#\1/' PKGBUILD
    fi

    makepkg -s --noconfirm --needed --asdeps

    if [[ "${package}" =~ ^(libglibutil|libgbinder|python-gbinder)$ ]]; then
        # These packages are dependencies of following packages
        sudo pacman -U --noconfirm --needed --asdeps ./*.pkg.tar.zst
    fi

    cd ..
done

mv ./libglibutil/*.pkg.tar.zst ./libgbinder/*.pkg.tar.zst ./python-gbinder/*.pkg.tar.zst ./python-pyclip/*.pkg.tar.zst ./waydroid/

readonly packages=(./waydroid/*.pkg.tar.zst)

echo "anbox-modules-dkms-git is available under $(realpath anbox-modules-dkms-git/*.pkg.tar.zst)"
echo "The following packages are available under $(realpath waydroid):"

for package in "${packages[@]}"; do
    echo "${package##*/}"
done
