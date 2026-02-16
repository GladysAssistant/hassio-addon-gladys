#!/usr/bin/env bash
set -e

# ==============================================================================
# Start Gladys Assistant
# ==============================================================================

# Read configuration from Home Assistant addon options
OPTIONS_FILE="/data/options.json"

server_port=$(jq -r '.server_port' "${OPTIONS_FILE}")
timezone=$(jq -r '.timezone' "${OPTIONS_FILE}")

echo "[INFO] Starting Gladys Assistant..."
echo "[INFO] Server port: ${server_port}"
echo "[INFO] Timezone: ${timezone}"
echo "[INFO] Data path: /data"

# Symlink /var/lib/gladysassistant to /data so Gladys integrations
# (MQTT, Zigbee2mqtt, etc.) write to the persistent addon data directory
if [ ! -e /var/lib/gladysassistant ] || [ ! -L /var/lib/gladysassistant ]; then
    rm -rf /var/lib/gladysassistant
    ln -s /data /var/lib/gladysassistant
fi

# Symlink Docker socket so Gladys can find it at the expected path
if [ -S /run/docker.sock ] && [ ! -e /var/run/docker.sock ]; then
    ln -s /run/docker.sock /var/run/docker.sock
fi

# Set environment variables for Gladys
export NODE_ENV=production
export SERVER_PORT="${server_port}"
export TZ="${timezone}"
export SQLITE_FILE_PATH=/data/gladys-production.db

# Start Gladys (source code is at /src/server in the Gladys image)
cd /src/server
exec node index.js
