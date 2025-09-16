#!/bin/bash
if [ -z $1 ] || [ $1 == "-h" ]; then
    echo "Script for encrypting and decrypting .env using sops utility"
    echo "Usage: $0 -[e|d]" 
    echo "-h: print this help"
    echo "-e: encrypt .env in current dir"
    echo "-d: decrypt .env.enc in current dir"
    exit 1
elif [ $1 == "-c" ]; then
    cat >> .sops.yaml << EOF
creation_rules:
  - path_regex: \.(env|env\.enc)$
    age: >-
      age18qxsdc2cg390cudnaf9h7njcx2kcqjte07vfs37dy6xldp7f3v8qgmvqrk,
      age1dfptqgyefhqjjednnjs5szfafzmk0hs23u85g6h7n2uajgtae3lquhkzs7
    input_type: dotenv
    output_type: dotenv
EOF
elif [ $1 == "-e" ]; then
    sops --encrypt --output-type dotenv .env > .env.enc
elif [ $1 == "-d" ]; then
    sops --input-type dotenv --output-type dotenv --decrypt .env.enc > .env
fi
