#!/bin/bash
#DATABASE_URL=oracle://jade:jade@10.10.10.200:1521/xe PORT=3100 node app.js

server=10.10.10.200
port=3000
debug='' # --debug
sid=xe

### SERVER
if [ "$#" -gt 1 ] && ([ "$1" = "$2" ] || [ "$1" = "$3" ] || [ "$2" = "$3" ])
then
    echo ERROR: Invalid argument\(s\)
    echo -e ' ' Expecting 1 server \"local\" \|\| \"staging\", 1 port: 3000-65535 and optionally, \"debug\" 
    echo -e ' ' ex: $0 local 3000 debug
    exit 1
fi

if [ "$1" = local ] || [ "$2" = local ] || [ "$3" = local ]
then
    echo Using db host: local \(dev-vm\) at [$server]
elif [ "$1" = staging ] || [ "$2" = staging ] || [ "$3" = staging ]
then
    server=192.168.0.101
    sid=jade.test.db.wyndhamjade.com
    echo Using db host staging at [$server]
else
    echo NOTICE: Unknown db host - Using local \(dev-vm\) at [$server]
fi


### PORT
re='^[0-9]+$'
if [[ $1 =~ $re ]] && [ "$1" -gt 2999 ] && [ "$1" -lt 65535 ]
then
    port=$1
    echo Using port [$port]
elif [[ $2 =~ $re ]] && [ "$2" -gt 2999 ] && [ "$2" -lt 65535 ]
then
    port=$2
    echo Using port [$port]
elif [[ $3 =~ $re ]] && [ "$3" -gt 2999 ] && [ "$3" -lt 65535 ]
then
    port=$3
    echo Using port [$port]
else
    echo NOTICE: Invalid port - Using port [$port] [by default]
fi


### DEBUG
if [ "$1" = debug ] || [ "$2" = debug ] || [ "$3" = debug ]
then
    debug=--debug
    echo Debug: On
else
    echo Debug: Off
fi


### COMMAND
source $(brew --prefix nvm)/nvm.sh
nvm use 0.10
DATABASE_URL=oracle://jade:jade@$server:1521/$sid PORT=$port node $debug app.js
