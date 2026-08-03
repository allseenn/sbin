#!/usr/bin/env bash
## Socks tunnel to Google Cloud Shell
gcloud cloud-shell ssh --ssh-flag="-D 0.0.0.0:8080" --ssh-flag="-C"
