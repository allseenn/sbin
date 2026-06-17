#!/usr/bin/env bash
## Socks tunnel to Google Cloud Shell
gcloud cloud-shell ssh --ssh-flag="-D 8080" --ssh-flag="-C"