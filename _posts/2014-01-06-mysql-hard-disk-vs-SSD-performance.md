---
layout: post
title: Relative performance of mySQL on an SSD vs. a spinning disk
custom_css: syntax.css
---

One of our embedded devices at work reports in to a central control server about once a second and several different pieces of diagnostic information are logged in a mySQL database by the control server. Recently as more devices have been added to the network we have been seeing poor performance on the control servers as queues of diagnostics fill up while waiting for database inserts to complete. I performed some benchmarks comparing the performance of a mySQL database stored on an SSD vs. one stored on a spinning hard disk.

What follows here are some quantitative results that compare the performance of several computers I had around the office, all running mySQL on Ubuntu 12.04. I used the mysqlslap program to run the tests, with a command similar to the one shown here:

{% highlight bash %}
sudo mysqlslap -u root -p --concurrency=8 --iterations=5 --number-int-cols=4 --number-char-cols=3 --number-of-queries=640 --auto-generate-sql
{% endhighlight %}

The three computers used were a laptop with an Intel SSD, a desktop computer with a 500GB WD hard drive, and an older server with dual Pentium 4s and a server class hard drive. 

| Test | SSD Runtime [s] | Desktop Runtime [s] | Server Runtime [s] |
| ---- | ----------- | --------------- | -------------- |
| Running 80 queries using a single mysql connection | 0.057 | 2.100 | 1.552 |
| Running 80 queries each from 8 concurrent mysql connections (640 total) | 0.083 | 4.201 | 3.422 |
| Running 80 queries each from 30 concurrent mysql connections (2400 total) | 0.522 | 4.393 | 9.203 |

My conclusions here are that database performance is extremely disk IO bound in the case of a single connection (one gateway) and a low number of concurrent connections (8 gateways). As the number of concurrent connections grows to 30, performance becomes more compute bound. The desktop runtime stayed almost the same while running 3.75x more queries as the number of concurrent connections was increased to 30, while the old server had a significant increase in runtime, most likely due to its much slower processor. The laptop with the SSD also had a large runtime increase, likely because the SSD was able saturate the processor.  

The database stored on the SSD performed more than an order of magnitude faster (~27x). From these results we decided that although we would need to upgrade our database servers to SSDs. increasing the parallelism of our insertion code would also enable a considerable increase in TPS for our given hardware.