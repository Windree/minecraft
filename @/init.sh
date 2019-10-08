#!/bin/bash
PORT=25565
TIMEOUT=3600
echo "Waiting for connections"
nc -l -W 1 -p $PORT
bash -x /minecraft.sh "$PORT" "$TIMEOUT"
