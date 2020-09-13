#!/bin/sh
pkill python3
if output=$(nohup python3 ../app.py prod1 > /dev/null 2>&1 &); then
    echo Server OK...
else
    echo FAIL
fi