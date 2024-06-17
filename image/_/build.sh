#!/usr/bin/env bash
set -Eeuxo pipefail

BUILDTOOLS_URL="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
BUILDTOOLS_GIT="https://hub.spigotmc.org/stash/scm/spigot/buildtools.git"
SPIGOT_GIT="https://hub.spigotmc.org/stash/scm/spigot/spigot.git"

root=$(mktemp -d)
target_jar=/spigot.jar
version_file=/spigot.version

function main() {
	build
	local jar=$(find_jar)
	echo "Spigot: $jar"
	ln -vs "$jar" "$target_jar"
	local version=$(parse_version "$jar")
	echo "Version: $version"
	echo -n "$version" >"$version_file"
}

function build() {
	(
		cd "$root" &&
			curl -o build.jar "$BUILDTOOLS_URL" &&
			java -jar build.jar --rev $MINECRAFT_VERSION &&
			mv spigot-*.jar /
	)
}

function find_jar() {
	find / -maxdepth 1 -type f -name spigot-*.jar | tail -n 1
}

function set_config() {
	sed -i -E "s/^(${2}=).*$/\1${3}/" "$1"
}

function parse_version() {
	echo "$1" | grep -oP '[\d.]+(?=\.)'
}

function cleanup() {
	echo "Cleanup..."
	rm -rf "$root"
}

trap cleanup exit

main
