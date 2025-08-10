FROM ubuntu:24.04
ARG MINECRAFT_VERSION=1.21.8
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGES="openjdk-21-jdk-headless supervisor"
ARG BUILD_PACKAGES="git wget curl "
ADD files/build.sh /
RUN apt update && \
    apt install -y $PACKAGES $BUILD_PACKAGES && \
    /build.sh && \
    apt autoremove --purge -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*
ADD files /
CMD ["supervisord", "-c", "/supervisord.conf"]