# Base VDR server
FROM lapicidae/vdr-server:latest

LABEL maintainer="Alexandro77"
LABEL description="VDR server with dvbapi ICAM support for Unraid"

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    git build-essential pkg-config libvdr-dev libdvbcsa-dev libssl-dev libxml2-dev && \
    rm -rf /var/lib/apt/lists/*

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

# Cleanup
RUN rm -rf /tmp/xinelibvdr /tmp/vdr-plugin-dvbapi

# Expose VDR ports
EXPOSE 2004 2005 3000

# Default configuration volume
VOLUME ["/etc/vdr"]

# Start VDR
CMD ["vdr"]