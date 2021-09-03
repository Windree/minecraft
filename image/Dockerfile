FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGES="openjdk-16-jre-headless"
ARG BUILD_PACKAGES="git wget curl"
RUN apt update && \
    apt install -y $PACKAGES $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/*
ADD @ /