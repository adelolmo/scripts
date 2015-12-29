#!/bin/bash
#make sure a process is always running.

process=deluged
makerun="service deluge start"

if ps ax | grep -v grep | grep $process > /dev/null; then
        exit
else
        logger "Start deluge service."
        exec $makerun
fi
exit
