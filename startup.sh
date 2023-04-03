#!/bin/bash -i

nohup Xvfb :99 -screen 0 1000x1000x16 > /dev/null &
mamba activate flatcam
python /app/app.py
