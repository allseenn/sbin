#!/bin/bash
wol $(ip nei | grep $(grep $1 /etc/hosts | awk '{print $1}') | awk '{print $5}')

