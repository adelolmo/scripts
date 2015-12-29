#!/bin/sh

echo "android version $1"
cd /tmp/android-api
git checkout $1
jar cvf ../$1-src.jar -C core/java .
jar uvf ../$1-src.jar -C graphics/java .
jar uvf ../$1-src.jar -C location/java .
jar uvf ../$1-src.jar -C media/java .
jar uvf ../$1-src.jar -C opengl/java .
jar uvf ../$1-src.jar -C sax/java .
jar uvf ../$1-src.jar -C services/java .
jar uvf ../$1-src.jar -C telephony/java .
jar uvf ../$1-src.jar -C wifi/java .

