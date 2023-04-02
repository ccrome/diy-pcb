#!/bin/bash -i

echo "starting Xvfb"
nohup Xvfb :99 -screen 0 1000x1000x16 > /dev/null &
echo "xvfb started"
echo "sleeping 1"
mamba activate flatcam
sleep 1
echo "starting gerber2stl"
python /app/gerber2stl.py /in.gerber /output.stl