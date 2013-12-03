---
layout: post
title: Creating timelapses with ffmpeg
---
I recently ran into a project where I wanted to take a folder full of JPEG images and turn them into a timelapse. 

I found a few snippets of script on the web, but nothing that did exactly what I wanted. To remedy that, I wrote a script that takes all the images in your present working directory and uses ffmpeg to create a timelapse out of them: [Download]({{ site.url }}/downloads/make_movie.sh)