#!/bin/env bash
set -Eeuo pipefail

function main(){
    if ! duplicity verify --no-encryption "$1" /dev/null; then
        echo Verification error
        exit 1
    fi
}

main "$1"