#!/bin/sh
pkill python3
if output=$(nohup python3 ../app.py dev > /dev/null 2>&1 &); then
    echo Server OK...
else
    echo FAIL
fi