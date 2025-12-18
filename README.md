# N9SLA RTL-SDR rtl_tcp Server

Docker container running `rtl_tcp` for remote RTL-SDR access over the network.

## Usage

### docker-compose (Recommended)

```yaml
services:
  rtl_tcp:
    image: n9sla/rtl-tcp:latest
    container_name: rtl_tcp
    restart: unless-stopped
    devices:
      - "/dev/bus/usb/001/003:/dev/bus/usb/001/003"
    ports:
      - "1234:1234"
```

Then:

```bash
docker compose up -d
```

### Direct docker run

```bash
docker run -d \
  --name rtl_tcp \
  --restart unless-stopped \
  --device /dev/bus/usb/001/003:/dev/bus/usb/001/003 \
  -p 1234:1234 \
  n9sla/rtl-tcp:latest
```

## Connecting from SDR++

- Device type: **rtl_tcp**
- Host: `frodo` (or the IP of your Docker host)
- Port: `1234`

## Requirements

- Docker and docker-compose
- RTL-SDR USB dongle plugged into host
- Linux host (tested on Ubuntu 20.04)

## Environment

- **Base Image**: Alpine Linux (minimal, ~7MB)
- **Compiled**: rtl-sdr from [Osmocom](https://gitea.osmocom.org/sdr/rtl-sdr)
- **Architecture**: x86_64

## Troubleshooting

Check logs:

```bash
docker logs rtl_tcp
```

Verify device is accessible:

```bash
ls -l /dev/bus/usb/001/003
```

## License

RTL-SDR is GPL-licensed. See [rtl-sdr repository](https://gitea.osmocom.org/sdr/rtl-sdr).
