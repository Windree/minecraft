#!/bin/env bash
set -Eeuo pipefail

root=$(dirname "$(realpath $0)")

trap 'up' EXIT

function main() {
    local backup_path=$1

    local last_backup=$(find "$backup_path" -type f  -exec stat -c '%X %n' {} \; | sort -n | tail -1 | awk '{ print $2 }')
    if [ -z "$last_backup" ]; then
        local name=$backup_path/full.dar
        dar --create "$name" --fs-root "$root" -Q --no-overwrite --compress=zstd
        echo "Full backup '$name' created."
    else
        local name=$backup_path/incremental-$(date +%F-%T)
        dar --create "$name" --ref "${last_backup%.*.*}" --fs-root "$root" -Q --no-overwrite --compress=zstd
        echo "Incremental backup '$name' created."
    fi
}

up(){
    if ! docker-compose -f "$root/docker-compose.yml" up -d; then
        echo error starting container
        exit
    fi
}

down(){
    if ! docker-compose -f "$root/docker-compose.yml" stop; then
        echo error stopping container
        exit
    fi
}

down
main "$1"
