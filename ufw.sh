#!/usr/bin/env bash
declare root="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
source "$root/.env"

ufw allow proto tcp to any port $MINECRAFT_GAME_PORT
ufw allow proto udp to any port $MINECRAFT_GAME_PORT
ufw reload
