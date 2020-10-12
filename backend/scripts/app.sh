#!/bin/sh
pkill gunicorn
if output=$(cd ../; nohup gunicorn -w 4 -t 4 --bind 0.0.0.0:5000 app:app > /dev/null 2>&1 &); then
    echo Server OK...
else
    echo FAIL
fi