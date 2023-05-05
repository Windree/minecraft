#!/bin/env bash
set -Eeuo pipefail

function main() {
    local backup_path=$1
    local root=$(get_path)
    if ! docker-compose -f "$root/docker-compose.yml" stop; then
        echo error stopping container
        exit
    fi
    local last_backup=$(find "$backup_path" -type f  -exec stat -c '%X %n' {} \; | sort -n | tail -1 | awk '{ print $2 }')
    if [ -z "$last_backup" ]; then
        dar --create "$backup_path/full.dar" --fs-root "$root" -Q --no-overwrite --compress=zstd -vt
    else
        dar --create "$backup_path/incremental-$(date +%F-%T)" --ref "${last_backup%.*.*}" --fs-root "$root" -Q --no-overwrite --compress=zstd -vt
    fi

    if ! docker-compose -f "$root/docker-compose.yml" up -d; then
        echo error stopping container
        exit
    fi
}

function get_path() {
    dirname "$(realpath $0)"
}

main "$1"
