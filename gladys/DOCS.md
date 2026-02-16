# Gladys Assistant Add-on for Home Assistant

## About

[Gladys Assistant](https://gladysassistant.com/) is a privacy-first, open-source home automation software that runs on any Linux machine.

This add-on launches the official Gladys Assistant Docker container directly on your Home Assistant instance, allowing you to run both systems side by side.

## Installation

1. Add this repository to your Home Assistant add-on store.
2. Install the **Gladys Assistant** add-on.
3. Configure the add-on (see Configuration below).
4. Start the add-on.
5. Click **Open Web UI** to access Gladys Assistant.

## Configuration

### Option: `server_port`

The port on which Gladys Assistant will be accessible. Default is `8080`.

> **Note:** Port 80 is already used by Home Assistant OS (HAOS) reverse proxy. The default `8080` avoids this conflict. You can change it to any available port.

### Option: `timezone`

The timezone used by Gladys Assistant. Default is `Europe/Paris`.

You can find the full list of valid timezone values on [Wikipedia](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

### Example configuration

```yaml
server_port: 8080
timezone: "Europe/London"
```

## Data Persistence

All Gladys data (database, configuration, etc.) is stored in `/data/gladys` inside the add-on. This data persists across add-on restarts and updates.

## Network

This add-on uses the host network mode, which means Gladys Assistant will be accessible directly on the configured port of your Home Assistant host IP address.

## Docker in Docker

This add-on runs Gladys Assistant as a Docker container inside the Home Assistant add-on container (Docker-in-Docker). This is required because Gladys needs access to the Docker socket to manage its own integrations.

## Support

- [Gladys Assistant Documentation](https://gladysassistant.com/docs/)
- [Gladys Assistant Community](https://community.gladysassistant.com/)
- [GitHub Issues](https://github.com/GladysAssistant/hassio-addon-gladys/issues)
