#!/bin/bash
set -Eeuo pipefail

function main() {
	local version=$(cat "/spigot.version")
	set_config "eula.txt" "eula" "true"
	set_config "server.properties" "motd" "$version"
	# set_config "server.properties" "query.port" "$PORT"
	java -XX:+UseG1GC -Xms8G -Xmx8G -jar "/spigot.jar" nogui --noconsole 2>&1
}

set_config() {
	sed -i -E "s/^(${2}=).*$/\1${3}/" "$1"
}

cd /data/ && main
