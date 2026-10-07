#!/usr/bin/env bash
ROOT=/mnt/sdcard/cloud
cd $ROOT 
dirs=(*/)
if (($#)); then
	dir=${dirs[$1-1]}
else
	select dir in "${dirs[@]}"; do break; done
fi
cd -- "$dir" && bash
echo $ROOT/$dir

