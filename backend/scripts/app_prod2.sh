#!/bin/sh
if output=$(nohup python3 ../app.py prod2 > /dev/null 2>&1 &); then
    echo Server OK...
else
    echo FAIL
fi