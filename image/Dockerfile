FROM ubuntu:21.04
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGES="openjdk-17-jre-headless"
ARG BUILD_PACKAGES="git wget curl"
ADD _ /
RUN apt update && \
    apt install -y $PACKAGES $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/* && \
    /build.sh && \
    apt purge -y $BUILD_PACKAGES
CMD ["/init.sh"]