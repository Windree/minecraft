#!/bin/bash
set +x
PORT=$1
TIMEOUT=$2

function set_motd(){
	set_config "$1" "motd" "$2"
}

function set_port(){
	set_config "$1" "query.port" "$2"
}

function set_config(){
	sed -i -E "s/^(${2}=).*$/\1${3}/" "$1"
}

function get_server_path(){
	find / -maxdepth 1 -type f -name spigot-*.jar | tail -n 1
}

function get_connection_count(){
	lsof -t -i$1:$2 -s$1:ESTABLISHED | wc -l
}

function get_client_count(){
	local tcp=$(get_connection_count "TCP" "$1")
	local udp=0
	echo $((tcp+udp))
}

function prepare_server(){
	echo 'eula=true' > "./eula.txt"
	chown -R root:root "."
	find "." -type d -exec chmod 755 {} +
	find "." -type f -exec chmod 644 {} +
}

function parse_version(){
	echo "$1" | grep -oP '[\d.]+(?=\.)'
}

function get_serverconig(){
	echo "./server.properties"
}


cd /data
prepare_server
CONFIG=$(get_serverconig "$DATA")
JAR=$(get_server_path)
VERSION=$(parse_version "$JAR")
if [ -f "$CONFIG" ]; then
	set_port "$CONFIG" "$PORT"
	set_motd "$CONFIG" "$VERSION"
fi
java -XX:+UseG1GC -Xms1G -Xmx1G -jar "$JAR" nogui --noconsole 2>&1 &
PID=$!
echo "Server starting. PID: $PID"
echo "Wating for connections..."
sleep $TIMEOUT
CLIENT_COUNT=$(get_client_count "$PORT")
while : ; do
	CLIENT_COUNT=$(get_client_count "$PORT")
	if [ "$CLIENT_COUNT" -eq "0" ]; then
	    echo "No connections..."
	    echo "Stopping server"
	    while kill -0 $PID >/dev/null 2>&1; do
		kill -s TERM $PID
		sleep 5
	    done	
	    echo "Server stopped"
	    exit 0
	fi
	echo [`date`] connections: $CLIENT_COUNT
	sleep $TIMEOUT
done
