#!/usr/bin/env bash
. $(dirname $0)/.env
vt -k $VIRUSTOTAL_TOKEN $*