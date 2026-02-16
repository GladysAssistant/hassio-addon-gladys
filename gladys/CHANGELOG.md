# Changelog

## 2.0.1

- Simplified Dockerfile: removed s6-overlay, use Gladys image directly with a simple run.sh

## 2.0.0

- **Breaking change**: Refactored addon to run Gladys directly (no more Docker-in-Docker)
- Gladys now runs natively inside the addon container
- Data persistence via `/data` (included in HA backups)
- Docker socket access for Gladys container management (MQTT, Zigbee2mqtt, etc.) — requires Protection Mode disabled
- Simpler and more reliable architecture

## 1.0.2

- Fix volume mount: resolve host path for /data so the Gladys container can mount it correctly

## 1.0.1

- Fix Docker socket path for Home Assistant OS (`/run/docker.sock`)

## 1.0.0

- Initial release
- Launches Gladys Assistant v4 via Docker
- Configurable server port and timezone
- Persistent data storage
- Host network mode for full device access
