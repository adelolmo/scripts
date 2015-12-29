#!/bin/bash

MYSQL_SANDBOX_HOME="/home/adelolmo/sandboxes"
ACTIVE_INSTANCE=`cat $MYSQL_SANDBOX_HOME/active_instance`

usage(){
	echo "Usage: $(basename $0) sql_dump_file"
	exit 1
}

if [ -z $1 ]; then
	usage
fi

#echo `cat active_instance`-basedir
SBDIR=$MYSQL_SANDBOX_HOME/$ACTIVE_INSTANCE
ACTIVE_BASEDIR=$ACTIVE_INSTANCE-basedir
#echo "active basedir: $ACTIVE_BASEDIR"
BASEDIR=`ls -l $MYSQL_SANDBOX_HOME/$ACTIVE_BASEDIR | awk '{print $11}'`
#echo "active basedir: $BASEDIR"

export LD_LIBRARY_PATH=$BASEDIR/lib:$BASEDIR/lib/mysql:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$BASEDIR_/lib:$BASEDIR/lib/mysql:$DYLD_LIBRARY_PATH
MYSQL="$BASEDIR/bin/mysql --no-defaults --socket=/tmp/mysql_sandbox3306.sock --port=3306"
echo
echo "MySQL active intance $ACTIVE_INSTANCE."
echo "SQL dump to execute: $1"
echo -n "Continue? (y/[N]) "
read option
if [ "$option" == "y" ]; then
	echo "Loading sql dump file $1 ..."
	$MYSQL -u root -p < $1
	exit 0
else
	echo "Process Aborted."
	exit 0
fi
