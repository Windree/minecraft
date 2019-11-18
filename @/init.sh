#!/bin/bash
PORT=25565
TIMEOUT=3600
{
echo "Waiting for connections on port $PORT"
nc -l -W 1 -p $PORT
echo "Connection reserved. Starting minecraft" 
bash -x /minecraft.sh "$PORT" "$TIMEOUT"
echo "Connection dropped. Stopping minecraft" 
} | /irc-send minecraft-server logs 