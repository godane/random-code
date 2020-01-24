#!/bin/bash
# run as:
#   capture.sh /dev/video0 hw:2,0 output.mkv
# Be sure pulseaudio is dead if this isn't working.
# stop and start pulseaudio in debian
#systemctl --user stop pulseaudio.socket
#systemctl --user stop pulseaudio.service
#systemctl --user start pulseaudio.socket
#systemctl --user start pulseaudio.service
VIDEO_DEVICE="$1"
AUDIO_DEVICE="$2"
OUTPUT_FILE="$3"
#TIME="-t 02:00:00"
#when rsyncing audio
#ffmpeg -i the-beast-nbc-woc-1996-04.mpg -itsoffset 0.3 -i the-beast-nbc-woc-1996-04.mpg -map 0:v -map 1:a -vcodec copy -acodec copy the-beast-nbc-woc-1996-04-resync.mpg
w="720"
h="480"
v4l2-ctl --device "$VIDEO_DEVICE" --set-fmt-video=width="$w",height="$h"
#ffmpeg -f v4l2 -i "$VIDEO_DEVICE" -f alsa -i "$AUDIO_DEVICE" -vcodec libx264 -crf 22 -acodec pcm_s16le "$OUTPUT_FILE"
vbitrate="10000k"
abitrate="320k"
time="03:30:00"
#ffmpeg -f v4l2 -i "$VIDEO_DEVICE" -thread_queue_size 1024  -f alsa -i "$AUDIO_DEVICE" -vcodec mpeg2video -pix_fmt yuv420p -threads 8 -bf 2 -r 29.97 -g 15 -s 720x480 -b $vbitrate -bt 300k -acodec mp2 -ac 2 -ab $abitrate -ar 44100 -async 1 -t 08:30:00 -y -f vob "$OUTPUT_FILE"
ffmpeg -thread_queue_size 60000 -f v4l2 -i "$VIDEO_DEVICE"  -thread_queue_size 50000  -f alsa -i "$AUDIO_DEVICE" -vcodec mpeg2video -pix_fmt yuv420p -threads 8 -bf 2 -r 29.97 -g 15 -s $wx$h -b:v $vbitrate -bt 300k -acodec mp2 -ac 2 -b:a $abitrate -ar 44100 -async 1 -t $time -y -f vob "$OUTPUT_FILE"
