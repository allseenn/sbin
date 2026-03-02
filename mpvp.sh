#!/usr/bin/env bash
# pip install fastapi uvicorn
. $(dirname $0)/.env
. $DIR_MPVP/.venv/bin/activate
python $DIR_MPVP/main.py

