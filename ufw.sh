#!/bin/sh
ufw allow proto tcp from any port 25565
ufw allow proto udp from any port 25565
ufw reload