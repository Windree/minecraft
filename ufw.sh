#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/.env"

ufw allow proto tcp to any port $MINECRAFT_GAME_PORT
ufw allow proto udp to any port $MINECRAFT_GAME_PORT
ufw reload
