#!/bin/bash
if [ -z $2 ]; then
    echo "Script for encrypting and decrypting files using sops utility"
    echo "Usage: $0 -[e|d] <file>[.enc]" 
    echo "-h: print this help"
    echo "-c conf: create config file .sops.yaml in current directory"
    echo "-e: encrypt given file and save it to file name + .enc extension"
    echo "-d: decrypt given file.enc and save it to file name without .enc extension"
    exit 1
fi
if [ $1 == "-c" ]; then
echo -e "creation_rules:
  - path_regex: \.env$
    age: >-
      $(grep public ~/.config/sops/age/keys.txt | awk '{print $4}')
" > .sops.yaml
elif [ $1 == "-e" ]; then
    sops --encrypt --output $2.enc $2
elif [ $1 == "-d" ]; then
    sops --input-type dotenv --output-type dotenv --decrypt $2 > ${2%.enc}
fi
