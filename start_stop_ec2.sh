#!/bin/bash
# Script to start / stop EC2 instance

AWS=`which aws`

# check parameters
if [ -z $1 ] || [ -z $2 ]
then
    echo 'Usage: start|stop|dns <instance-id>'
    exit -1
fi

INSTANCE=$2

if [ $1 = "stop" ]
then
    echo "Instance $INSTANCE is stopping..."
    $AWS ec2 stop-instances --instance-ids $INSTANCE
    exit $?
fi

if [ $1 = "start" ]
then
    echo "Instance $INSTANCE is starting..."
    $AWS ec2 start-instances --instance-ids $INSTANCE
    $AWS ec2 wait instance-running --instance-ids $INSTANCE

    if [ $? -ne 0 ]
    then
        echo "$INSTANCE timed out while starting!"
        exit -1
    else
        echo "$INSTANCE started"
        exit 0
    fi
fi

exit -1
