---
layout: post
title: Extending Deluge's Execute on Complete Functionality
custom_css: syntax.css
---
I run Deluge on one of my headless server instances to seed several different categories 
of torrent (Linux mint ISOs, etc) and I like to have completed torrents automatically 
copied back to my home NAS over FTP. To do this, I use the 
[execute](http://dev.deluge-torrent.org/wiki/Plugins/Execute) plugin for Deluge to execute
a shell script upon download completion.

Files in different categories get saved to separate directories, so I wrote a shell script 
to identify completed torrents by the directory they were saved in and FTP them to a 
specified directory on my server. 

The script can be found on my GitHub [here:](https://github.com/pddenhar/deluge-execute-ftpscript)

The HOST, USER, and PASS variables should be filled in with your credentials. The paths 
in the if statements can then be changed to reflect the directories that your torrents are saved
in and the directories you want them sent to with FTP as shown in the following example.

{% highlight bash %}
if [ "/delugeData/UbuntuISO" == "$torrentpath" ]
then
	echo "This is an UbuntuISO torrent, sending with FTP" >> ~/execute_script.log
	if [ -f "$torrentpath/$torrentname" ]
	then
			echo "     Torrent is a single file" >> ~/execute_script.log
			lftp -u $USER,$PASS $HOST -e "cd /Storage/UbuntuISO/; put \"$torrentpath/$torrentname\"; quit" &>> ~/execute_script.log
	else
			echo "     Torrent is a folder" >> ~/execute_script.log
			lftp -u $USER,$PASS $HOST -e "mirror -P4 -R \"$torrentpath/$torrentname\" /Storage/UbuntuISO/; quit" &>> ~/execute_script.log
	fi
fi
{% endhighlight %}