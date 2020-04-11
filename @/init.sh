#!/bin/bash
PORT=25565
TIMEOUT=14400
BUILDTOOLS_URL="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
BUILDTOOLS_GIT="https://hub.spigotmc.org/stash/scm/spigot/buildtools.git"
SPIGOT_GIT="https://hub.spigotmc.org/stash/scm/spigot/spigot.git"

get_server_path(){
	find "$1" -maxdepth 1 -type f -name spigot-*.jar | tail -n 1
}

set_config(){
	sed -i -E "s/^(${2}=).*$/\1${3}/" "$1"
}

parse_version(){
	echo "$1" | grep -oP '[\d.]+(?=\.)'
}

run(){
	local jar=$1
	
}

build(){
	cd /tmp && \
	curl -o build.jar "$BUILDTOOLS_URL" && \
	java -jar build.jar --rev latest && \
	mkdir -p /jar && \
	mv spigot-*.jar /jar/ && \
	cd / && \
	rm -rf /tmp/* 
}

jar=$(get_server_path /jar)

if [ -z "$jar" ]; then
	build
	jar=$(get_server_path /jar)
fi

echo "Minecraft JAR: $jar"
version=$(parse_version "$jar")
cd /data
set_config "eula.txt" "eula" "true";
set_config "server.properties" "motd" "$version";
set_config "server.properties" "query.port" "$PORT";
java -XX:+UseG1GC -Xms1G -Xmx1G -jar "$jar" nogui --noconsole 2>&1

# java -XX:+UseG1GC -Xms1G -Xmx1G -jar "$jar" nogui --noconsole 2>&1 &
# pid=$!
# sleep $((7*24*60*60))
# kill -15 $pid
# wait
# build
# sleep 10