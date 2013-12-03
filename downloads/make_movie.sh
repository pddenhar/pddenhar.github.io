#! /bin/bash
#Author: Peter Den Hartog - 2012
OUTNAME=timelapse.mp4
OF=$(pwd)
echo Converting all images in $OF
mkdir /tmp/make_movie/
x=1; for i in `ls -tr *.jpg`; 
do 
    counter=$(printf %d $x); 
    ln "$i" /tmp/make_movie/img"$counter".jpg; 
    x=$(($x+1)); 
done
/opt/local/bin/ffmpeg -f image2 -r 18 -i /tmp/make_movie/img%d.jpg -b 1200k $OUTNAME
echo "Removing temporary files"
rm -rf /tmp/make_movie/