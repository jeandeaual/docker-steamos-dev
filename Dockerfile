FROM archlinux:latest

ARG user=deck

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup the SteamOS repositories
# hadolint ignore=SC2016
RUN echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' > /etc/pacman.d/mirrorlist
RUN sed -i \
    -e 's|^\(\[core\]\)|[jupiter-rel]\nInclude = /etc/pacman.d/mirrorlist\nSigLevel = Never\n\n[holo-rel]\nInclude = /etc/pacman.d/mirrorlist\nSigLevel = Never\n\n\1|' \
    -e 's/\[\(core\|extra\|community\)\]/[\1-rel]/' \
    /etc/pacman.conf

# Initialize Pacman
RUN pacman -Syy
RUN pacman-key --init
RUN pacman-key --populate archlinux

# Replace all Arch packages with the SteamOS mirror versions
RUN pacman -S --noconfirm holo-keyring
RUN pacman -Rdd --noconfirm libverto
RUN pacman -Qqn | pacman -S --noconfirm --overwrite='*' -

# Install the Linux headers and some development tools
RUN pacman -S --noconfirm --needed \
    base-devel \
    cmake \
    vim \
    git \
    sudo \
    dkms \
    linux-neptune-headers

RUN rm -rf /var/cache/pacman/pkg/*

# Create the deck user
RUN useradd -m "${user}"
RUN echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}"

USER ${user}
WORKDIR /home/${user}
