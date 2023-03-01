#!/bin/sh
CUR_DIR=$(dirname $(readlink -f $0))
pidfile=$CUR_DIR/wallpic.pid

if [ -f "$pidfile" ] && kill -0 `cat $pidfile` 2>/dev/null; then
	echo still running
    feh --randomize --bg-scale ~/Pictures/wallpaper/*
    exit 1
fi
echo $$ > $pidfile

while true; do
    #find ~/Pictures -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |
    #    shuf -n1 -z | xargs -0 feh --bg-scale
    feh --randomize --bg-scale ~/Pictures/wallpaper/*
    sleep 15m
done
