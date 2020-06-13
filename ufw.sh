#!/bin/sh
ufw allow proto tcp to any port 25565
ufw allow proto udp to any port 25565
ufw reload