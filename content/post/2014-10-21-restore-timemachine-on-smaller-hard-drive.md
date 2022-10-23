---
author: David
categories:
  - OSX
date: '2014-10-21T08:17:37+02:00'
guid: https://david.gyttja.com/?p=377
id: 377
permalink: /2014/10/21/restore-timemachine-on-smaller-hard-drive/
tags:
  - TimeMachine
title: Restore TimeMachine on "smaller" hard drive
url: /2014/10/21/restore-timemachine-on-smaller-hard-drive/
---


Recently my Mac died and I have been temporarily using a loaner Mac. The loaner has a 1TB SSD, whereas my Mac has only a 250GB SSD. I restored my TimeMachine backup onto the loaner Mac, and chose the option to "take over" the TimeMachine backup in order to maintain backups of my files while my Mac was in the shop getting repaired.

Now I have my Mac back, and to make things simple I thought I'd just do a TimeMachine restore on my Mac. Unfortunately, when selecting my TimeMachine backup, I get the woeful message:
"This disk does not have enough space to restore your system"

<!--more-->

My TimeMachine backup is only ~150GB, so realistically I should be able to restore onto my 250GB hard drive. Googling around I found that if you happen to have exluded items in your TimeMachine configuration, the total size of those items may be included in some metadata somewhere in your TimeMachine backup, thus increasing the required size for restore (even though those files are not at all backed up).

![timemachine excluded items](/images/2014/10/tm-ignore.png)

In my case, I have 120GB of virtual machines (various databases, OSes, snapshots, etc) excluded from my backup. I usually keep them on a USB3 external drive, but since I had a 1TB drive for a week, I decided to move them to the primary hard drive. So, now I have copied the VMs back to the external drive, removed them from the main hard drive, and performed a TimeMachine backup.

Now, boot into the recovery console (command-R at boot) on my repaired Mac, mount my NAS TimeMachine, select TimeMachine restore, and the restore is successful! Strange that even though the excluded items are not being backed up that their disk space is being used to determine how large the destination hard drive should be...

Happy restoring!
