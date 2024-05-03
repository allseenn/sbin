#!/bin/bash
# script controls jupiter $TYPE server installed to virtual environment in directory VENV
VENV=/opt/lab/env
# NDIR - its working dir place where you $TYPEs *.ipynb files stores. 
NDIR=/mnt/wd/github
# 0.0.0.0 start to listen any available net interface 
IP=0.0.0.0
# default port 8888
PORT=8888
# select type of notebook or lab o server
TYPE=notebook
# --no-browser Prevent the opening of the default url in the browser, you could use firefox or any installed
BROWSER=--no-browser 
# its tricking constuct that similar to ternary IF: ifs $1 is empy set CMD to h, its needed any string to avoid many warnings futher
CMD=${1:-h}

if [ $CMD = start ]
then
    source $VENV/bin/activate
    $VENV/bin/jupyter $TYPE --ip=$IP --port=$PORT --$TYPE-dir=$NDIR --no-browser &

elif [ $CMD = stop ]
then
    JNPID=$(ps aux | grep jupyte[r] | awk '{ print $2 }')
    kill -9 $JNPID

elif [ $CMD = restart ]
then
    JPID=$(ps aux | grep jupyte[r] | awk '{ print $2 }')
    kill -9 $JNPID
    sleep 5
    source $VENV/bin/activate
    $VENV/bin/jupyter $TYPE --ip=$IP --port=$PORT --$TYPE-dir=$NDIR $BROWSER &

elif [ $CMD = status ]
then
    $VENV/bin/jupyter $TYPE list

elif [ $CMD = pass ]
then
    $VENV/bin/jupyter $TYPE password

elif [ $CMD = conf ]
then
    $VENV/bin/jupyter $TYPE --generate-config

elif [ $CMD = act ]
then
      bash -c "cd $VENV/.. && source $VENV/bin/activate; bash"
else 
echo "USAGE: $0 start|stop|restart|status|act|pass|conf
start - starts jupiter $TYPE server on $IP:$PORT
stop - kill server
restart - restarts server
status - show ip and ports of running servers
pass - set password for server
conf - generates configuration in user directory
act - activates virtual environment of jupyter and cd to $(cd $VENV/.. && pwd)"
fi
