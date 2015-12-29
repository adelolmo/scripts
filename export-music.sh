#!/bin/bash
MUSIC_HOME="/media/ich/Dropbox/Musica/"
TMP_MUSIC_DIR="/tmp/music/"
BIT_RATE=128000

echo MUSIC_HOME = $MUSIC_HOME
echo TMP_MUSIC_DIR = $TMP_MUSIC_DIR

usage(){
    echo
    echo "Usage: $(basename $0) (dir|list) path"
    exit 1
}

export_dir(){
    ALBUM_DIR="$1"
    echo ALBUM_DIR = $ALBUM_DIR

    rm -fR $TMP_MUSIC_DIR
    mkdir -p "$TMP_MUSIC_DIR$ALBUM_DIR"

    cd $MUSIC_HOME
    find "$ALBUM_DIR" -name "*.mp3" -type f -print0 | xargs -0 -I path avconv -i "$MUSIC_HOME"path -ab $BIT_RATE "$TMP_MUSIC_DIR"path
#find "$ALBUM_DIR" -name "*.mp3" -type f -print0 | xargs -0 -I path echo path
}

export_list(){
    LIST="$1"
    echo LIST = $LIST
    rm -fR $TMP_MUSIC_DIR
    cat $LIST | while read album_dir; do 
        echo ${album_dir}
        mkdir -p "$TMP_MUSIC_DIR${album_dir}"
        cd $MUSIC_HOME
        find "${album_dir}" -name "*.mp3" -type f -print0 | xargs -0 -I path avconv -i "$MUSIC_HOME"path -ab $BIT_RATE "$TMP_MUSIC_DIR"path
    done    
}


COMMAND="$1"

if [ -z "$1" ]; then
    usage
fi
if [ -z "$2" ]; then
    usage
fi


case $COMMAND in
dir)
    echo "Directory mode"
    export_dir "$2"
    ;;
list)
    echo "List mode"
    export_list "$2"
    ;;
*)
    usage
esac

#find "$ALBUM_DIR" -name "*.mp3" -type f | xargs -I path echo "$MUSIC_HOME"path 

#avconv -i /media/ich/Dropbox/Musica/Queen\ -\ Greatest\ Hits\ 3CD/Queen\(GreatestHitsI\)-\(11\)NowImHere.mp3 -ab 192000 queen-192.mp3
