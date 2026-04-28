#!/bin/bash
if pgrep -f "flask" > /dev/null; then
    pkill -f "flask"
fi
