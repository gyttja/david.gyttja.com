---
author: David
categories:
  - OSX
date: '2013-06-05T10:52:24+02:00'
guid: http://gyttja.wordpress.com/?p=254
id: 254
permalink: /2013/06/05/swapping-like-crazy/
title: Swapping like crazy
url: /2013/06/05/swapping-like-crazy/
---


I've noticed that my Mac seems to be eating up quite a bit of disk space every now and then, without any action from me. I have [MenuMeters](http://www.ragingmenace.com/software/menumeters/) installed and realized that this extra disk usage is due to insane swap-file usage. I know one cannot rely completely on the reported RAM usage numbers ("used" vs "free" due to all the other states, "free", "wired", "active", "inactive"), but in my end-user mind I find it insane that though I'm currently using 7.1GB and have a total of 16GB, the OS should not be using 7.3GB of my hard drive. Use up the fast RAM first, then move the storage to the (albeit a fast SSD) slow disk. Don't pre-emptively swap! Yes, I know this is a simplistic view and probably technically incorrect. But it's annoying that OSX is using my hard drive when it doesn't need to!

<!--more-->

Restarting the Mac solves the immediate swapping issue, and my hard drive recovers the missing 7GB (in my current example, see screenshots below). But after about 3-4 days of uptime, the heavy swapping returns. Since this does not make any sense to me, I want to find the root cause. And I think I might have an inkling as to some of the swapping. Sorting the processes in Activity Monitor by virtual memory, I see that over time the [socketfilterfw memory usage grows and grows and grows](https://discussions.apple.com/thread/2757238?start=0&tstart=0).

So my solution until Apple fixes their memory leak: every now and then manually disable and enable the firewall in System Preferences to immediately flush the bloated swap. :)

You can see in the screenshots below that I recovered > 7GB disk space used by the memory hog socketfilterfw by restarting the firewall.

![before](/images/2013/06/before.png)

![memory hog](/images/2013/06/memoryhog.png)

![after](/images/2013/06/after.png)

I wonder what would happen if I left my machine on for an extended amount of time (talking many weeks here) without restarting? I bet socketfilterfw would eat up all the free space on my hard drive. Sounds like a challenge: maybe I'll leave my machine on during my summer vacation and see what happens...
