# Base VDR server (Alpine-based)
FROM lapicidae/vdr-server:latest

LABEL maintainer="Alexandro77"
LABEL description="VDR server with dvbapi ICAM support for Unraid (Alpine compatible)"

# Install build dependencies for Alpine
RUN apk add --no-cache \
    git \
    build-base \
    pkgconfig \
    libxml2-dev \
    openssl-dev \
    linux-headers \
    bash \
    autoconf \
    automake \
    libtool \
    wget \
    curl

# Build xinelibvdr (required by dvbapi)
RUN git clone https://github.com/marcelk/xinelibvdr.git /tmp/xinelibvdr && \
    cd /tmp/xinelibvdr && \
    ./autogen.sh && \
    make && \
    make install

# Build dvbapi plugin with ICAM support
RUN git clone https://github.com/alexx77x/vdr-plugin-dvbapi.git /tmp/vdr-plugin-dvbapi && \
    cd /tmp/vdr-plugin-dvbapi && \
    ./configure --with-vdr=/usr/local && \
    make && \
    make install

# Clean up build folders to keep image small
RUN rm -rf /tmp/xinelibvdr /tmp/vdr-plugin-dvbapi

# Expose VDR ports
EXPOSE 2004 2005 3000

# Default configuration volume
VOLUME ["/etc/vdr"]

# Start VDR by default
CMD ["vdr"]
