#!/bin/bash
PORT=25565
TIMEOUT=600
BUILDTOOLS_URL="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
BUILDTOOLS_GIT="https://hub.spigotmc.org/stash/scm/spigot/buildtools.git"
SPIGOT_GIT="https://hub.spigotmc.org/stash/scm/spigot/spigot.git"

set_motd(){
	set_config "$1" "motd" "$2"
}

set_port(){
	set_config "$1" "query.port" "$2"
}

set_config(){
	sed -i -E "s/^(${2}=).*$/\1${3}/" "$1"
}

get_server_path(){
	find /jar/ -maxdepth 1 -type f -name spigot-*.jar | tail -n 1
}

get_connection_count(){
	cat /proc/net/tcp | awk '$3 ~ /:63DD/' | wc -l
}

get_client_count(){
	local tcp=$(get_connection_count "TCP" "$1")
	local udp=0
	echo $((tcp+udp))
}

prepare_server(){
	echo 'eula=true' > "./eula.txt"
}

parse_version(){
	echo "$1" | grep -oP '[\d.]+(?=\.)'
}

get_serverconig(){
	echo "./server.properties"
}


run(){
	local jar=$1
	local config=$(get_serverconig "$DATA")
	echo jar $jar
	version=$(parse_version "$jar")
	if [ -f "$config" ]; then
		set_port "$config" "$PORT"
		set_motd "$config" "$version"
	fi
	java -XX:+UseG1GC -Xms1G -Xmx1G -jar "$jar" nogui --noconsole 2>&1 &
	local PID=$!
	echo "Server starting. PID: $PID"
	echo "Wating for connections..."
	sleep $TIMEOUT
	local client_count=$(get_client_count "$PORT")
	while : ; do
		cat /proc/net/tcp
		client_count=$(get_client_count "$PORT")
		if [ "$client_count" -eq "1110" ]; then
			echo "No connections..."
			echo "Stopping server"
			kill -s TERM $PID
			wait $PID
			echo "Server stopped"
			exit 0
		fi
		echo [`date`] connections: $client_count
		sleep 10
	done
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

jar=$(get_server_path)
ls -la /jar
echo "Minecraft JAR: $jar"
[ -z "$jar" ] && build
echo "Waiting for connections on port $PORT"
nc -l -W 1 -p $PORT
echo "Connection reserved. Starting minecraft" 
cd /data
run "$jar"
echo "Connection dropped. Stopping minecraft" 
if [[ $(find "$jar" -mtime +7 -print) ]]; then
  build
fi
