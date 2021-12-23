#!/bin/env bash
set -Eeuo pipefail

function main(){
    local root=$(get_path)
    if ! docker-compose -f "$root/docker-compose.yml" stop >/dev/null 2>/dev/null; then
        echo Error stopping container
        return
    fi
    if ! duplicity --no-encryption "$root/_" "$1" 2>/dev/null; then
        echo Backup error
        return
    fi
    if ! docker-compose -f "$root/docker-compose.yml" up --build -d >/dev/null 2>/dev/null; then
        echo Error restarting container
        return
    fi
}

function get_path(){
    dirname "$(realpath -s $0)"
}

main "$1"