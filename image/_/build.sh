#!/bin/bash
set -Eeuo pipefail

BUILDTOOLS_URL="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
BUILDTOOLS_GIT="https://hub.spigotmc.org/stash/scm/spigot/buildtools.git"
SPIGOT_GIT="https://hub.spigotmc.org/stash/scm/spigot/spigot.git"

jar(){
	find / -maxdepth 1 -type f -name spigot-*.jar | tail -n 1
}

set_config(){
	sed -i -E "s/^(${2}=).*$/\1${3}/" "$1"
}

parse_version(){
	echo "$1" | grep -oP '[\d.]+(?=\.)'
}

build(){
	cd /tmp && \
	curl -o build.jar "$BUILDTOOLS_URL" && \
	java -jar build.jar --rev latest && \
	mkdir -p /jar && \
	mv spigot-*.jar / && \
	cd / && \
	rm -rf /tmp/* 
}

build
jar=$(jar)
echo "Spigot: $jar"
ln -vs "$jar" "/spigot.jar"
version=$(parse_version "$jar")
echo "Version: $version"
echo -n "$version" > /spigot.version
