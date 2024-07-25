#!/bin/bash
set -o errexit
set -o nounset

# https://en.wikipedia.org/wiki/ANSI_escape_code
E0="$(printf "\e[0m")"        # reset
E1="$(printf "\e[1m")"        # bold

echo "${E1}Starting mariadb: http://127.0.0.1:3306${E0}"

# Start mariadb in the background
docker-entrypoint.sh "$@"

# Start SSH service
/usr/sbin/sshd -D
