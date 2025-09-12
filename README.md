# hamclock
Hamclock container with Docker and Podman compatibility, now including a React OS Info application

## Features

- **HamClock**: Ham radio clock application by WB0OEW
- **React OS Info App**: Web application that fetches and displays operating system information

## Source

[Github Repository](https://github.com/leftrightthere/hamclock/)

## Repositories
```
# Weekly builds scheduled to build every Friday morning

# GitHub
ghcr.io/leftrightthere/hamclock

# Docker
docker.io/leftrightthere/hamclock
```

## React OS Info Application

The container now includes a React application that provides a web interface to fetch operating system information from the server. This demonstrates secure server-side script execution without command injection vulnerabilities.

### Features:
- Clean, responsive React UI
- Secure backend API using Express.js
- Safe shell script execution to read `/etc/os-release`
- Real-time OS information display

### Access URLs:
- **React OS Info App**: http://localhost:3001
- **HamClock API**: http://localhost:8080
- **HamClock Web UI**: http://localhost:8081
- **HamClock Read-only UI**: http://localhost:8082

![React OS Info App Screenshot](https://github.com/user-attachments/assets/5ba15d46-04ba-43d2-98fc-95cf23bb2160)

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


## Building the Container

```bash
# Clone the repository
git clone https://github.com/leftrightthere/hamclock.git
cd hamclock

# Build the React application
cd react-app
npm install
npm run build
cd ..

# Build the container image
docker build -t hamclock-with-react .
# or with podman
podman build -t hamclock-with-react .
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
  -p 3001:3001 \
  ghcr.io/leftrightthere/hamclock
```
### Run the image (Persistent storage volume)
```
podman run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -p 3001:3001 \
  -v ghcr-hamclock:/opt/hamclock/hamuser/.hamclock \
  ghcr.io/leftrightthere/hamclock
```
### Run the image (Env variables with storage volume)
```
podman run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -p 3001:3001 \
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
  -p 3001:3001 \
  ghcr.io/leftrightthere/hamclock
```
### Run the image (Persistent storage volume)
```
docker run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -p 3001:3001 \
  -v ghcr-hamclock:/opt/hamclock/hamuser/.hamclock \
  ghcr.io/leftrightthere/hamclock
```
### Run the image (Env variables with storage volume)
```
docker run --detach --name hamclock \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -p 3001:3001 \
  -e UTC_OFFSET=-5 \
  -e LOCATOR=AA00aa \
  -e DXGRID=JJ00aa \
  -v ghcr-hamclock:/opt/hamclock/hamuser/.hamclock \
  ghcr.io/leftrightthere/hamclock
```

## Security Features

The React OS Info application has been designed with security in mind:

- **No Command Injection**: The shell script does not accept any parameters from user input
- **Path Protection**: Uses absolute paths to prevent path traversal attacks  
- **Input Validation**: No user input is passed to shell commands
- **Timeout Protection**: Shell script execution has a 5-second timeout limit
- **Error Handling**: Comprehensive error handling for all failure scenarios

The `/etc/os-release` file is read using a static shell script with no dynamic command construction, ensuring complete protection against command injection vulnerabilities.

