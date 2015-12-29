#!/bin/bash
if [ -z "$1" ]; then
	echo
	echo "Usage: $(basename $0) instance_name   (e.g. $(basename $0) p05)"
	exit 1
fi

MYSQL_SANDBOX_HOME="/home/adelolmo/sandboxes"
MYSQL_INSTANCE_NAME="5.1.66-$1"
SANDBOX_DIR="msb_5_1_66-$1"
MYSQL_TAR="mysql-5.1.66-linux-x86_64-glibc23.tar.gz"
MYSQL_DEFAULT_DIR="mysql-5.1.66-linux-x86_64-glibc23"

echo
echo "*********************************************************************"
echo "* WARNING: Please make sure no MySQL instance is currently running! *"
echo "*********************************************************************"
echo
echo -n "Continue? (y/[N]) "
read option
if [ "$option" == "y" ]; then
	echo "Creating new instance $MYSQL_INSTANCE_NAME..."
	echo "Unpacking..."
	if [ -d $MYSQL_INSTANCE_NAME ]; then
		rm -Rf $MYSQL_INSTANCE_NAME
	fi
	mkdir /tmp/my_sandbox > /dev/null 2>&1
	tar xvf $MYSQL_TAR -C /tmp/my_sandbox > /dev/null 2>&1

	mkdir $MYSQL_INSTANCE_NAME > /dev/null 2>&1
	mv /tmp/my_sandbox/$MYSQL_DEFAULT_DIR/* ./$MYSQL_INSTANCE_NAME

	# prepare configuration file
#	cp my.sandbox.cnf /tmp
#	sed -i "s/INSTANCE/$1/g" /tmp/my.sandbox.cnf
#	echo
	low_level_make_sandbox --basedir=/usr/local/mysql-sandboxes/$MYSQL_INSTANCE_NAME --sandbox_directory=$SANDBOX_DIR --install_version=5.1 --sandbox_port=3306 --db_user=root --db_password=ak12ban3 --no_ver_after_name --my_clause=log-error=msandbox.err --my_clause=max_allowed_packet=500M --force --no_run

#	echo "Change active instance to $SANDBOX_DIR..."
#	echo $SANDBOX_DIR > $MYSQL_SANDBOX_HOME/active_instance
	
	# replace pid-file
	grep -v pid-file $MYSQL_SANDBOX_HOME/$SANDBOX_DIR/my.sandbox.cnf > /tmp/my.sandbox.cnf
	echo "pid-file                = /tmp/$SANDBOX_DIR.pid" >> /tmp/my.sandbox.cnf
	mv /tmp/my.sandbox.cnf $MYSQL_SANDBOX_HOME/$SANDBOX_DIR/my.sandbox.cnf	

	# modify pid in sub-scripts
	TFILE="/tmp/out.tmp.$$"
	for f in `find $MYSQL_SANDBOX_HOME/$SANDBOX_DIR -maxdepth 1 -type f`; do
		if [ -f $f -a -r $f ]; then
			#echo "file: $f"
			sed "s/PIDFILE=.*/PIDFILE=\"\/tmp\/$SANDBOX_DIR.pid\"/g" "$f" > $TFILE && mv $TFILE "$f"
			chmod u+x $f
		else
			echo "Error: Cannot read $f"
		fi
	done

	echo "Adding simbolink..."
	ln -s /usr/local/mysql-sandboxes/$MYSQL_INSTANCE_NAME $MYSQL_SANDBOX_HOME/$SANDBOX_DIR-basedir

	echo "Process SUCCESFUL."
	exit 0
else
	echo "Process Aborted."
	exit 0
fi
