#!/bin/bash

DISPLAY_NUM=${1:-0}
VIDEO_OUTPUT="/mnt/backup/video/screen_record_$(date +%Y%m%d_%H%M%S).mp4"

# Устройства аудио
SYS_AUDIO="bluez_output.74_2A_8A_14_B3_32.1.monitor"
MIC_AUDIO="bluez_input.74_2A_8A_14_B3_32.0"

ffmpeg \
  -video_size 1920x1080 \
  -framerate 30 \
  -f x11grab -i ":${DISPLAY_NUM}.0" \
  -f pulse -i "$SYS_AUDIO" \
  -f pulse -i "$MIC_AUDIO" \
  -filter_complex "[1:a][2:a]amerge=inputs=2[aout]" \
  -map 0:v -map "[aout]" \
  -c:v mpeg4 -qscale:v 4 \
  -preset medium \
  -crf 23 \
  -c:a aac \
  -ac 2 \
  -ar 48000 \
  -movflags faststart \
 "$VIDEO_OUTPUT"

