#!/bin/bash
PORT=25565
TIMEOUT=600
BUILDTOOLS_URL="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
BUILDTOOLS_GIT="https://hub.spigotmc.org/stash/scm/spigot/buildtools.git"
SPIGOT_GIT="https://hub.spigotmc.org/stash/scm/spigot/spigot.git"
SERVER_PREFIX=/jar/
DATA_PREFIX=/data/
SERVER_EULA="$DATA_PREFIX/eula.txt"
SERVER_PROPERTIES="$DATA_PREFIX/server.properties"

set_config(){
	sed -i -E "s/^(${2}=).*$/\1${3}/" "$1"
}

find_spigot(){
	find $1 -maxdepth 1 -type f -name spigot-*.jar | tail -n 1
}

parse_version(){
	echo "$1" | grep -oP '[\d.]+(?=\.)'
}

run(){
	cd $2
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


jar=$(find_spigot "$SERVER_PREFIX")
echo "Minecraft JAR: $jar"
[ -z "$jar" ] && build && jar=$(find_spigot $SERVER_PREFIX)
echo "Waiting for connections on port $PORT"
nc -l -W 1 -p $PORT 2>&1 > /dev/null
echo "Connection reserved. Starting minecraft"
set_config $SERVER_EULA "eula" "true"
set_config $SERVER_PROPERTIES "motd" "$(parse_version $jar)"
set_config $SERVER_PROPERTIES "query.port" $PORT
(
	cd $DATA_PREFIX
	java -XX:+UseG1GC -Xms1G -Xmx1G -jar "$jar" nogui --noconsole 2>&1
) &
pid=$!
echo "Minecraft PID: $pid"
echo checking for conenction each 10 minutes
sleep 600
while : ; do
	sleep 600
	echo checking for conenction each 10 minutes
	if lsof -i :$PORT -sTCP:ESTABLISHED; then
		continue;
	fi

	echo "Connection dropped. Stopping minecraft" 
	kill -15 $pid
	wait
	if [[ $(find "$jar" -mtime +7 -print) ]]; then
	  build
	fi
done
