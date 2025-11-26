# unraid-vdr-icam

Dockerized VDR server with dvbapi ICAM support for Unraid.

## Features

- VDR server from `lapicidae/vdr-server`
- DVBAPI plugin with ICAM support
- Configurable via `/config/vdr`
- Unraid Community Applications ready

## Usage

1. Map `/config/vdr` to `/etc/vdr` in Unraid.
2. Start the container via Unraid CA.
3. Configure `dvbapi.conf` for your CAM/CAID.

## Ports

- 2004: DVBAPI
- 2005: VDR HTTP
- 3000: VDR streaming