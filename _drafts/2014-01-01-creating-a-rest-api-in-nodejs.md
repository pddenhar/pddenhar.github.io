---
layout: post
title: Creating a REST API in node.js
custom_css: syntax.css
---
This is basically my notes page at the moment as I learn node.js and create a REST API
for a markdown application I'm building. A lot of this will be little code snippets 
I found helpful and think will be useful in the future.

To start off with, I installed [node.js](http://nodejs.org/) and [mongodb](http://www.mongodb.org/).
For mongodb, the installation after downloading and decompressing on Unix went something like:
{% highlight bash %}
sudo mv -n mongodb-osx-x86_64-2.4.8/ /usr/local/
sudo ln -s /usr/local/mongodb-osx-x86_64-2.4.8 /usr/local/mongodb
sudo mkdir -p /data/db
sudo chown `id -u` /data/db
{% endhighlight %}

Inside the /usr/local/mongodb/bin/ directory there will be at least two important executables,
mongod and mongo. mongod starts the mongo deamon, and mongo opens an interactive shell that
connects to mongod.

Now that mongo is set up, on to node.js. I would suggest installing nodemon, which automatically 
restarts the node server for you every time you change your source code. This saves a lot of 
tedium and Ctrl-Cing.

{% highlight bash %}
sudo npm install -g nodemon
nodemon app.js
{% endhighlight %}

You'll notice the -g flag in the above npm (node package manager) call. That means that the 
package should be installed globally instead of in the local project's node_modules folder,
which is the default for node.js packages. 