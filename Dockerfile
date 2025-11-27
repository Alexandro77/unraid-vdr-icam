# Arch Linux base
FROM archlinux:latest

LABEL maintainer="Alexandro77"
LABEL description="VDR server with plugins for Unraid (AUR build + plugin stubs)"

# ------------------------------
# Root setup: update and install dependencies
# ------------------------------
USER root

RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Syu --noconfirm

RUN pacman -S --noconfirm \
    base-devel \
    git \
    wget \
    curl \
    tar \
    pkgconf \
    libxml2 \
    openssl \
    bash \
    autoconf \
    automake \
    libtool \
    ffmpeg \
    libx11 \
    xorg-server \
    sqlite \
    linux-headers \
    sudo \
    && pacman -Scc --noconfirm

# ------------------------------
# Create unprivileged VDR user
# ------------------------------
RUN useradd -m -s /bin/bash vdr && echo "vdr ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create build directory for vdr user
RUN mkdir -p /home/vdr/build && chown -R vdr:vdr /home/vdr/build

# ------------------------------
# Build VDR core (from AUR)
# ------------------------------
USER vdr
WORKDIR /home/vdr/build

# Clone VDR AUR and build
RUN git clone https://aur.archlinux.org/vdr.git && \
    cd vdr && \
    makepkg -si --noconfirm

# ------------------------------
# Switch back to root for plugin builds
# ------------------------------
USER root
WORKDIR /tmp

# ------------------------------
# Plugin build stubs
# ------------------------------

# 1. dvbapi (ICAM support)
# NOTE: This plugin uses Makefile, not configure
RUN wget -O dvbapi.tar.gz https://github.com/manio/vdr-plugin-dvbapi/archive/refs/heads/master.tar.gz && \
    tar xzf dvbapi.tar.gz && \
    cd vdr-plugin-dvbapi-master && \
    # TODO: fill in correct build command, e.g.,
    # make VDRDIR=/usr/include/vdr LIBDIR=/usr/lib && make install
    echo "Build command for dvbapi plugin goes here"

# 2. streamdev plugin
RUN wget -O streamdev.tar.gz https://github.com/vdr-projects/vdr-plugin-streamdev/archive/refs/heads/master.tar.gz && \
    tar xzf streamdev.tar.gz && \
    cd vdr-plugin-streamdev-master && \
    # TODO: fill in correct build command
    echo "Build command for streamdev plugin goes here"

# 3. live plugin
RUN wget -O live.tar.gz https://github.com/vdr-projects/vdr-plugin-live/archive/refs/heads/master.tar.gz && \
    tar xzf live.tar.gz && \
    cd vdr-plugin-live-master && \
    # TODO: fill in correct build command
    echo "Build command for live plugin goes here"

# 4. osdteletext plugin
RUN wget -O osdteletext.tar.gz https://github.com/vdr-projects/vdr-plugin-osdteletext/archive/refs/heads/master.tar.gz && \
    tar xzf osdteletext.tar.gz && \
    cd vdr-plugin-osdteletext-master && \
    # TODO: fill in correct build command
    echo "Build command for osdteletext plugin goes here"

# 5. vnsiserver plugin
RUN wget -O vnsiserver.tar.gz https://github.com/vdr-projects/vdr-plugin-vnsiserver/archive/refs/heads/master.tar.gz && \
    tar xzf vnsiserver.tar.gz && \
    cd vdr-plugin-vnsiserver-master && \
    # TODO: fill in correct build command
    echo "Build command for vnsiserver plugin goes here"

# 6. epg2vdr plugin
RUN wget -O epg2vdr.tar.gz https://github.com/vdr-projects/vdr-plugin-epg2vdr/archive/refs/heads/master.tar.gz && \
    tar xzf epg2vdr.tar.gz && \
    cd vdr-plugin-epg2vdr-master && \
    # TODO: fill in correct build command
    echo "Build command for epg2vdr plugin goes here"

# ------------------------------
# Cleanup
# ------------------------------
RUN rm -rf /tmp/* /home/vdr/build/*

# ------------------------------
# Ports, volume, runtime
# ------------------------------
EXPOSE 2004 2005 3000 8008
VOLUME ["/etc/vdr"]

USER vdr
CMD ["vdr"]
