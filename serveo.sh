#!/usr/bin/env bash
. $(dirname $0)/.env
ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o TCPKeepAlive=yes -R $DOMAIN:80:localhost:8000 serveo.net