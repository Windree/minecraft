FROM ubuntu:22.04
ARG MINECRAFT_VERSION=1.20.1
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGES="openjdk-17-jre-headless"
ARG BUILD_PACKAGES="git wget curl"
ADD _/build.sh /
RUN apt update && \
    apt install -y $PACKAGES $BUILD_PACKAGES && \
    /build.sh && \
    apt purge -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*
ADD _/init.sh /
CMD ["/init.sh"]