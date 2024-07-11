#!/bin/bash
set -o errexit
set -o nounset

# https://en.wikipedia.org/wiki/ANSI_escape_code
E0="$(printf "\e[0m")"        # reset
E1="$(printf "\e[1m")"        # bold

/sbin/apache2ctl -v
echo "${E1}Starting webserver: http://127.0.0.1:8080${E0}"

# Start Apache in the background
/sbin/apache2ctl -k start

# Start SSH service
/usr/sbin/sshd -D
