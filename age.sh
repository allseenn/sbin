#!/bin/bash
if [ -z $2 ]; then
    echo "Script for encrypting and decrypting files using age utility"
    echo "Usage: $0 -[e|d] <file>[.enc]" 
    echo "-h: print this help"
    echo "-e: encrypt given file and save it to file name + .enc extension"
    echo "-d: decrypt given file.enc and save it to file name without .enc extension"
    exit 1
fi
if [ $1 == "-e" ]; then
    age --encrypt --recipient $(grep public ~/.config/sops/age/keys.txt | awk '{print $4}') --output $2.enc $2
elif [ $1 == "-d" ]; then
    age --decrypt --identity ~/.config/sops/age/keys.txt --output ${2%.enc} $2
fi
