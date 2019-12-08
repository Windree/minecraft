FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGES="openjdk-11-jre-headless netcat-openbsd"
ARG BUILD_PACKAGES="git wget curl"
RUN apt update && \
    apt install -y $PACKAGES $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*
ADD @ /
