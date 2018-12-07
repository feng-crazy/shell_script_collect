#!/bin/bash

SERVERS=$*
USERNAME="pi"
PASSWD="hdf654321"
FILE="DataHub"

function sshcopy
{
    if [ ${#1} -le 3 ]; then
	addr="192.168.0."${1}
    fi

    expect -c "
        set timeout -1;
        spawn ssh $USERNAME@$addr;
        expect {
            \"yes/no\" { send \"yes\r\" ;exp_continue; }
            \"password:\" { send \"$PASSWD\r\";exp_continue; }
            \"pi@\" { send \"cd /home/LT/Bin; cp DataHub DataHub.bak; ./lt kill; exit \r\" };
        };
        expect eof;
    "

    echo "To sync ${FILE} to pi@${addr} ..."
    sshpass -p $PASSWD scp build/$FILE pi@$addr:/home/LT/Bin

    expect -c "
        set timeout -1;
        spawn ssh $USERNAME@$addr;
        expect {
            \"yes/no\" { send \"yes\r\" ;exp_continue; }
            \"password:\" { send \"$PASSWD\r\";exp_continue; }
            \"pi@\" { send \"cd /home/LT/Bin; ./lt restart; exit \r\" };
        };
        expect eof;
    "
}

echo "Local file:"
echo `ls build -l| grep ${FILE}`

for server in $SERVERS
do
    sshcopy $server
done
