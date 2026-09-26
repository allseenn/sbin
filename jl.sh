#!/usr/bin/env bash
# script controls jupiter $TYPE server installed to virtual environment in directory VENV 
VENV="${PREFIX:-}/opt/lab/.venv"
# NDIR - its working dir place where you $TYPEs *.ipynb files stores.
NDIR=/mnt/sdcard/github
# 0.0.0.0 start to listen any available net interface
IP=0.0.0.0
# default port 8888
PORT=8888
# select type of notebook or lab o server
TYPE=lab
# --no-browser Prevent the opening of the default url in the browser, you could use firefox or any installed
BROWSER=--no-browser
# its tricking construct that similar to ternary IF: ifs $1 is empty set CMD to h, its needed any string to avoid many warnings further
CMD=${1:-h}

make_venv() {
    mkdir -p "$(dirname "$VENV")"
    # uv python install 3.12
    uv venv --python 3.14 --system-site-packages "$VENV"
    uv pip install --python "$VENV/bin/python" jupyterlab numpy pandas matplotlib scipy codeium-jupyter
}

ensure_venv() {
    if [ ! -x "$VENV/bin/jupyter" ]; then
        echo "Virtual environment not found: $VENV. Run '$0 install' first."
        exit 1
    fi
}

if [ "$CMD" = install ]
then
    make_venv

elif [ "$CMD" = start ]
then
    if [ ! -x "$VENV/bin/python" ]; then
        make_venv
    fi
    source "$VENV/bin/activate"
    "$VENV/bin/jupyter" "$TYPE" --ip=$IP --port=$PORT --notebook-dir=$NDIR --no-browser &

elif [ "$CMD" = stop ]
then
    JNPIDS=$(pgrep -f "$VENV/bin/jupyter" || true)
    if [ -n "$JNPIDS" ]; then
        kill -9 $JNPIDS
    fi

elif [ "$CMD" = restart ]
then
    JNPIDS=$(pgrep -f "$VENV/bin/jupyter" || true)
    if [ -n "$JNPIDS" ]; then
        kill -9 $JNPIDS
    fi
    sleep 5
    source "$VENV/bin/activate"
    "$VENV/bin/jupyter" "$TYPE" --ip=$IP --port=$PORT --notebook-dir=$NDIR $BROWSER &

elif [ "$CMD" = status ]
then
    ensure_venv
    "$VENV/bin/jupyter" "$TYPE" list

elif [ "$CMD" = remove ]
then
    if [ -d "$VENV" ]; then
        rm -rf "$VENV"
        echo "Removed virtual environment: $VENV"
    else
        echo "Virtual environment not found: $VENV"
    fi

elif [ "$CMD" = pass ]
then
    ensure_venv
    "$VENV/bin/jupyter" "$TYPE" password

elif [ "$CMD" = conf ]
then
    ensure_venv
    "$VENV/bin/jupyter" "$TYPE" --generate-config

elif [ "$CMD" = act ]
then
    ensure_venv
    bash -c "cd $VENV/.. && source $VENV/bin/activate; bash"
else
    echo "USAGE: $0 start|stop|restart|status|act|pass|conf|install|remove
start - starts jupiter $TYPE server on $IP:$PORT
stop - kill server
restart - restarts server
status - show ip and ports of running servers
pass - set password for server
conf - generates configuration in user directory
act - activates virtual environment of jupyter and cd to $(cd "$VENV/.." && pwd)
install - creates uv venv with python 3.12 and packages: jupyterlab, numpy, pandas, matplotlib, scipy
remove - deletes the virtual environment directory at $VENV"
fi


