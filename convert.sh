#!/bin/bash
set -ex

HOST_DIR="$(pwd)/videos"
INPUT_VIDEO="sample.mov"
QUALITY="-crf 30"   # limit by CRF values
# QUALITY="-fs 98M" # limit by file size

DOCKER="docker run -i --rm"
MOUNT="--mount type=bind,source=$HOST_DIR,target=/tmp/workdir"
IMAGE="jrottenberg/ffmpeg"

# -y                Don't ask for permission to write to /dev/null
# -c:v libvpx-vp9   Codec Video set to VP9
# -b:v 0            Bitrate must bet set to 0 if using CRF quality
# -an               Don't encode video in the first pass
# /dev/null         Don't write an acutal file, jsut a log file used for the 2nd pass
# webm              The video container
FFMPEG_ARGS="-y -i /tmp/workdir/$INPUT_VIDEO -c:v libvpx-vp9 -b:v 0 $QUALITY"
PASS_1="-pass 1 -an -f webm /dev/null"
PASS_2="-pass 2     -f webm output.webm"

$DOCKER $MOUNT $IMAGE $FFMPEG_ARGS $PASS_1
$DOCKER $MOUNT $IMAGE $FFMPEG_ARGS $PASS_2