#!/bin/bash
# script controls jupiter $TYPE server installed to virtual environment in directory VENV
VENV=/opt/label/env
# NDIR - its working dir place where you $TYPEs *.ipynb files stores. 
NDIR=/mnt/wd/github
# 0.0.0.0 start to listen any available net interface 
IP=0.0.0.0
# default port 8888
PORT=8000
# select type of notebook or lab o server
TYPE=notebook
# --no-browser Prevent the opening of the default url in the browser, you could use firefox or any installed
BROWSER=--no-browser 
# username
USERNAME=slava
# password
PASSWORD=1408
# its tricking constuct that similar to ternary IF: ifs $1 is empy set CMD to h, its needed any string to avoid many warnings futher
CMD=${1:-h}

if [ $CMD = start ]
then
    source $VENV/bin/activate
    $VENV/bin/label-studio $TYPE --internal-host==$IP --port=$PORT --data-dir=$NDIR --username $USERNAME --password $PASSWORD &

elif [ $CMD = stop ]
then
    JNPID=$(ps aux | grep label-studi[o] | awk '{ print $2 }')
    kill -9 $JNPID

elif [ $CMD = restart ]
then
    JPID=$(ps aux | grep label-studi[o] | awk '{ print $2 }')
    kill -9 $JNPID
    sleep 5
    source $VENV/bin/activate
    $VENV/bin/label-studio $TYPE --internal-host=$IP --port=$PORT --data-dir=$NDIR --username $USERNAME --password $PASSWORD &

elif [ $CMD = status ]
then
    $VENV/bin/label-studio $TYPE list

elif [ $CMD = pass ]
then
    $VENV/bin/label-studio $TYPE password

elif [ $CMD = conf ]
then
    $VENV/bin/label-studio $TYPE --generate-config

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
act - activates virtual environment of label-studio and cd to $(cd $VENV/.. && pwd)"
fi
