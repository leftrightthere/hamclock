# hamclock
Hamclock container with Docker and Podman compatibility

## Repositories
```
# GitHub
ghcr.io/leftrightthere/hamclock

# Docker
leftrightthere/hamclock
```

## Deviations

The container creates a new user account and relocates the profile path to '/opt/hamclock/hamuser' instead of using the default root user.
```
# Environmental Variables available
UTC_OFFSET
CALLSIGN
LOCATOR
LAT
LONG
OFFSET
VOACAP_MODE
VOACAP_POWER
FLRIG_HOST
FLRIG_PORT
USE_FLRIG
USE_METRIC
CALLSIGN_BACKGROUND_COLOR
CALLSIGN_BACKGROUND_RAINBOW
CALLSIGN_COLOR
WIFI_SSID
WIFI_PWD
WIFI_PWD
SHOW_PUB_IP
DXGRID
```


## Podman

### Pull the image
```
podman pull ghcr.io/leftrightthere/hamclock
```
### Run the image (No persistent storage)
```
podman run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  ghcr.io/leftrightthere/hamclock
```
### Run the image (Persistent storage volume)
```
podman run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -v ghcr-hamclock:/opt/hamclock/hamuser/.hamclock \
  ghcr.io/leftrightthere/hamclock
```
### Run the image (Env variables with storage volume)
```
podman run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -e UTC_OFFSET=-5 \
  -e LOCATOR=AA00aa \
  -e DXGRID=JJ00aa \
  -v ghcr-hamclock:/opt/hamclock/hamuser/.hamclock \
  ghcr.io/leftrightthere/hamclock
```
## Docker

### Pull the image
```
docker pull ghcr.io/leftrightthere/hamclock
```
### Run the image (No persistent storage)
```
docker run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  ghcr.io/leftrightthere/hamclock
```
### Run the image (Persistent storage volume)
```
docker run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -v ghcr-hamclock:/opt/hamclock/hamuser/.hamclock \
  ghcr.io/leftrightthere/hamclock
```
### Run the image (Env variables with storage volume)
```
docker run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -e UTC_OFFSET=-5 \
  -e LOCATOR=AA00aa \
  -e DXGRID=JJ00aa \
  -v ghcr-hamclock:/opt/hamclock/hamuser/.hamclock \
  ghcr.io/leftrightthere/hamclock
```
