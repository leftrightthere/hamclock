## Inspired by these projects:
## https://github.com/zeidlos/hamclock-docker
## https://github.com/ChrisRomp/hamclock-docker
## https://www.clearskyinstitute.com/ham/HamClock/

FROM alpine

LABEL org.opencontainers.image.title="HamClock"
LABEL org.opencontainers.image.authors="Peter Baker, KC3WRK"
LABEL org.opencontainers.image.description="HamClock by WBØOEW in an OCI container with React OS Info App"
LABEL org.opencontainers.image.source="https://github.com/leftrightthere/hamclock"
LABEL org.opencontainers.image.url="https://github.com/leftrightthere/hamclock/tree/main"
LABEL org.opencontainers.image.licenses="MIT"

# HamClock supported resolutions are 800x480, 1600x960, 2400x1440 and 3200x1920 as of v3.02
ARG RESOLUTION=2400x1440

# Ports
# RESTful API 8080, Read/Write Web UI 8081, Read Only Web UI 8082
# React App Backend and Frontend 3001
EXPOSE 8080/tcp
EXPOSE 8081/tcp     
EXPOSE 8082/tcp
EXPOSE 3001/tcp

# Copy init.sh script to container
WORKDIR /opt/hamclock/ESPHamClock
COPY init.sh /opt/hamclock/
RUN chmod +x /opt/hamclock/init.sh

# Install prerequisites including Node.js
RUN apk update \
 && apk add curl make g++ libx11-dev openssl unzip perl nodejs npm bash \
 && apk cache clean

# Install Hamclock
RUN cd /opt/hamclock \
 && rm -fr ESPHamClock \
 && curl -O https://www.clearskyinstitute.com/ham/HamClock/ESPHamClock.zip \
 && unzip ESPHamClock.zip \
 && cd ESPHamClock \
 && make -j 4 hamclock-web-${RESOLUTION} \
 && make install \
 && rm ../ESPHamClock.zip

# Install Hamclock Contrib and move hceeprom to hamclock directory
RUN cd /opt/hamclock \
 && curl -O https://www.clearskyinstitute.com/ham/HamClock/hamclock-contrib.zip \
 && unzip hamclock-contrib.zip \
 && chmod +x hamclock-contrib/hceeprom.pl \
 && mv hamclock-contrib/hceeprom.pl /opt/hamclock/ESPHamClock/ \
 && rm hamclock-contrib.zip

# Copy React App and Backend
COPY react-app/build /opt/react-app
COPY backend /opt/backend

# Install backend dependencies and make script executable
RUN cd /opt/backend && npm ci --only=production && chmod +x get-os-info.sh

# Insert User (We don't want to run as root)
RUN adduser --home /opt/hamclock/hamuser --disabled-password --gecos "Hamclock user" hamuser
ENV HOME /opt/hamclock/hamuser
USER hamuser

# Copy startup script
COPY startup.sh /opt/hamclock/startup.sh
USER root
RUN chmod +x /opt/hamclock/startup.sh
USER hamuser

# Set command parameters
CMD /opt/hamclock/startup.sh
