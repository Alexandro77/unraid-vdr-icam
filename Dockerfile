# Use full Arch Linux base
FROM archlinux:latest

LABEL maintainer="Alexandro77"
LABEL description="VDR server with dvbapi ICAM support for Unraid (Arch-based, clean build)"

USER root

# Update package database and install build dependencies
RUN pacman-key --init && pacman-key --populate archlinux && pacman -Sy --noconfirm
RUN pacman -S --noconfirm base-devel git pkgconf libxml2 openssl bash autoconf automake libtool wget curl s6 linux-headers && pacman -Scc --noconfirm

# Install additional runtime dependencies (if needed by VDR)
RUN pacman -S --noconfirm libx11 xorg-server ffmpeg && pacman -Scc --noconfirm

# Create VDR user
RUN useradd -m -s /bin/bash vdr

# Set up working directory
WORKDIR /tmp

# Build xinelibvdr (required for dvbapi)
RUN git clone https://github.com/marcelk/xinelibvdr.git && cd xinelibvdr && ./autogen.sh && make && make install

# Build VDR from source (optional if you want latest VDR)
RUN git clone https://github.com/TVDR/VDR.git && cd VDR && ./autogen.sh && ./configure --prefix=/usr/local && make && make install

# Build dvbapi plugin with ICAM support
RUN git clone https://github.com/alexx77x/vdr-plugin-dvbapi.git && cd vdr-plugin-dvbapi && ./configure --with-vdr=/usr/local && make && make install

# Clean up build folders to reduce image size
RUN rm -rf /tmp/*

# Expose standard VDR ports
EXPOSE 2004 2005 3000

# Default configuration volume
VOLUME ["/etc/vdr"]

# Switch to VDR user for runtime
USER vdr

# Start VDR
CMD ["vdr"]
