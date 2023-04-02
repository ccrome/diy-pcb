#!/bin/bash

(nohup Xvfb :99 -screen 0 1000x1000x16 &) > /dev/null
mamba init
. ~/.bashrc
mamba activate flatcam
which flatcam

#python /app/gerber2stl.py /in.gerber /output.stl
