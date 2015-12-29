#!/bin/bash
MYSQL_SANDBOX_HOME="/home/adelolmo/sandboxes"
ACTIVE_INSTANCE=`cat $MYSQL_SANDBOX_HOME/active_instance`
MYSQL_INSTANCE=$MYSQL_SANDBOX_HOME/$ACTIVE_INSTANCE

echo
echo "Active MySQL intance: $ACTIVE_INSTANCE" 
$MYSQL_INSTANCE/use "$@"
