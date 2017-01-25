#!/bin/bash

minetest --config minetest.vr.conf &

# Well I want to translate PID to windows id, but wmctrl -l -p shows 0
# for minetest

sleep 1s
minetest_id=`wmctrl -l | grep Minetest | awk '{print $1}'`

windows_info=`xwininfo -id $minetest_id`

x=`echo "$windows_info" | grep "Absolute upper-left X:" | awk -F: '{print $2}' | bc`
y=`echo "$windows_info" | grep "Absolute upper-left Y:" | awk -F: '{print $2}' | bc`
width=`echo "$windows_info" | grep "Width:" | awk -F: '{print $2}' | bc`
height=`echo "$windows_info" | grep "Height:" | awk -F: '{print $2}' | bc`

#echo $x , $y , $width, $height

video_dimensions=`echo "$width"x"$height"`
windows_position=`echo :0.0+"$x","$y"`

#~ ffmpeg -video_size $video_dimensions \
	#~ -c:v mpeg2video -q:v 20 -pix_fmt yuv420p -g 1 -threads 2 \
	#~ -framerate 30 -f x11grab -i $windows_position \
	#~ -f mpegts - | nc -l -p 9000

#~ ffmpeg -video_size $video_dimensions -framerate 30 -f x11grab -i $windows_position \
	#~ -vcodec libx264 -crf 26 -preset fast \
	#~ -f mpegts - | nc -l -p 9000

ffmpeg -video_size $video_dimensions -framerate 30 -f x11grab -i $windows_position \
	-vcodec libx264 -crf 26 -preset fast \
	-f rtp rtp://127.0.0.1:1234


#~ ffmpeg -video_size 598x360 -framerate 30 -f x11grab -i :0.0+765,30 -c:v libx264 -preset veryfast -tune zerolatency -pix_fmt yuv444p -x264opts crf=20:vbv-maxrate=3000:vbv-bufsize=100:intra-refresh=1:slice-max-size=1500:keyint=30:ref=1 -fflags nobuffer -f mpegts udp://127.0.0.1:5678


#~ ffmpeg -video_size 598x360 -framerate 30 -f x11grab -i :0.0+765,30  -c:v libx264 -crf 0 -preset veryfast -tune zerolatency -f mpegts udp://127.0.0.1:5678
 

#~ -f rtp "rtp://127.0.0.1:1234"


#echo "ffmpeg -video_size $video_dimensions -framerate 25 -f x11grab -i :0.0+$x,$y output.mp4"

#vlc tcp://127.0.0.1:9000