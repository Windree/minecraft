FROM ubuntu:24.04
ARG MINECRAFT_VERSION=1.20.6
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGES="openjdk-21-jdk-headless"
ARG BUILD_PACKAGES="git wget curl openjdk-17-jre-headless"
ADD _/build.sh /
RUN apt update && \
    apt install -y $PACKAGES $BUILD_PACKAGES && \
    /build.sh && \
    apt autoremove --purge -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*
ADD _/ /
CMD ["/entrypoint.sh"]