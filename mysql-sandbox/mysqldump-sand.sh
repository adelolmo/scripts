#!/bin/bash

MYSQL_SANDBOX_HOME="/home/adelolmo/sandboxes"
ACTIVE_INSTANCE=`cat $MYSQL_SANDBOX_HOME/active_instance`

SBDIR=$MYSQL_SANDBOX_HOME/$ACTIVE_INSTANCE
$SBDIR/my sqldump $@
