---
layout: post
title: Simplified Multiprocess Concurrency in Python with Decorators
custom_css: syntax.css
---
[Alex Sherman](http://alex.vector57.net/deco/) and I recently finished a project we call deco, which is a simplified way to run code concurrently in Python. Because of the CPython global interpreter lock, runnning concurrent code in Python currently requires using multiple independent processes and serializing and piping function calls and arguments to them.

We implemented a new model, with the only programmer interation required being the insertion of two decorators ```@concurrent``` and ```@synchronized```. The ```@concurrent``` marks a function you wish to be run in parallel, and the ```@synchronized``` decorator marks a function where the concurrent function will be called. For example: 

{% highlight python %}
@concurrent   #Identify the concurrent function
def do_work(key):
  return some_calculations(...)

data = {}
@synchronized
def run():
  for key in data:
    data[key] = do_work(key)
  print data # data will be automatically synchronized here
{% endhighlight %}

The powerful part of deco comes from the fact that you can mutate the arguments to the concurrent function and the changes will be synchronized back to the parent process. This is different than Python's ```multiprocess.pool```, which requires any changed state to be returned from the concurrent function and throws away modification to arguements. For example, you could have a dictionary of longitude ranges and call a ```@concurrent``` function which computes the average temperature over a given range and updates the key for that range. As long as you call the function in a loop with each call to the function updating a unique key in the dictionary, your calculations will happen in parallel and the results will of the seperate processes will be synchronized automatically before you access the data in the parent process (the ```@synchronized``` decorator handles that).

Alternatively, as shown in the example above you can assign results of concurrent function calls to indexed or keyed objects (lists and dicts) and they will be synchronized into those locations as the parallel calls complete and before you access the data in the parent process. Again, this is made possible by the ```@synchronized``` decorator which actually rewrites the assignments inside the parent function body to allow them to happen concurrently and synchronize later.

You can read more about the design of deco in our [technical report]({{ site.url }}/downloads/Decorated_Concurrency.pdf) or clone it on [GitHub](https://github.com/alex-sherman/deco).