---
layout: post
title: Creating a linked clone in ESXi (the easy way)
custom_css: syntax.css
---
Linked clones are a neat feature in ESXi for installations with many virtual machines that need to be deployed off the same template, because once you've created a base image you can deploy many copies of it without consuming a few GB for each install. Linked clones only consume space for the diff between them and the base image. Currently, the [process](http://sanbarrow.com/linkedcloneswithesxi.html) of creating a linked clone is somewhat tedious if you only have vSphere, and requires downloading vmx and vdmk files to your computer and manually editing and duplicating them. I wrote a bash script to automate the process on your server which saves a lot of time and messing about.

To start with, you need a master VM created with the full install you want on each clone. In my case I installed Ubuntu LTS on a VM called "Ubuntu Base Server (Don't Touch)", installed various utility programs I would need on every clone, and copied my public SSH key to it for secure access. Any configuration that you do now will save you considerable time down the road because it won't need to be done individually on each clone. Once you are satisfied, power down the VM and take a single snapshot of it called "Base Image" or something similar. After this point you should not modify the master VM at all. 

![Single snapshot]({{ site.url }}/images/ESXi/snapshot.PNG)

At this point, turn on the ESXi SSH service and connect to it. 

![SSH Service]({{ site.url }}/images/ESXi/ssh.PNG)

Browse to your datastore containing the master VM, copy/paste my script from [its GitHub repo](https://github.com/pddenhar/esxi-linked-clone) (ESXi wget doesn't support direct wget from https), and run it. The first argument should be the folder name of your base image and the second argument should be the name of the folder you want the clone output to.
{% highlight bash %}
ls /vmfs/volumes/Datastore/
vi clone.sh # enter insert mode (i), paste code in, press escape and save file with :wq
./clone.sh Ubuntu\ Server\ Base\ \(Don\'t\ Touch\)/ Server\ Clone\ 1
{% endhighlight %}

The script will copy the virtual machine and the base image snapshot to the new directory and modify the files as necessary. All that is left is for you to add them to your inventory from the datastore browser in ESXi, naming them something like Clone 1, Clone 2, etc.

![Adding to Inventory]({{ site.url }}/images/ESXi/add.png)

Any time you need more linked clones in the future you can just run the script again with more unique names and add the resulting copies. Hopefully this script will be helpful to you if you need to quickly make a large number of linked clones in ESXi!

**Update 10/30/14:**

[oliverbock](https://github.com/oliverbock) created a nice [pull request](https://github.com/pddenhar/esxi-linked-clone/pull/2) to add some new features to clone.sh. 
The changes are pretty self explanatory, but the big new feature is that clones are automatically registered when they are created. He also added a deleteclone.sh
script that you can use to safely remove clones (using ESXi to delete a clone will also delete the base disk.)	