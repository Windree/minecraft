FROM ubuntu:disco
ARG DEBIAN_FRONTEND=noninteractive
ARG BUILDTOOLS_URL="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
ARG BUILDTOOLS_GIT="https://hub.spigotmc.org/stash/scm/spigot/buildtools.git"
ARG SPIGOT_GIT="https://hub.spigotmc.org/stash/scm/spigot/spigot.git"
RUN apt update && \
    apt install -y openjdk-11-jre-headless curl wget git lsof netcat-openbsd && \
    cd /tmp && \
    curl -o build.jar "$BUILDTOOLS_URL" && \
    java -jar build.jar --rev latest && \
    mv spigot-*.jar / && \
    apt purge -y git wget curl && \
    apt autoremove --purge -y && \
    cd / && \
    rm -rf /tmp/* /var/lib/apt/lists/*
ADD --chown=root:root @ /
