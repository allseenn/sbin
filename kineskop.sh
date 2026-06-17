#!/usr/bin/env bash
ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto \
-i 01.m3u8 -protocol_whitelist file,http,https,tcp,tls,crypto \
-i 02.m3u8 -c copy -map 0:v:0 -map 1:a:0 output.mp4