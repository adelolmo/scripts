#!/bin/bash

TMP_DIR=/tmp/apk2java

rm -Rf $TMP_DIR
unzip "$1" -d $TMP_DIR
/usr/local/dex2jar/d2j-dex2jar.sh $TMP_DIR/classes.dex
