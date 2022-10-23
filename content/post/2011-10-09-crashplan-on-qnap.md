---
author: David
categories:
  - QNAP
date: '2011-10-09T21:09:41+02:00'
guid: http://gyttja.wordpress.com/?p=111
id: 111
permalink: /2011/10/09/crashplan-on-qnap/
tags:
  - backup
  - cloud
  - CrashPlan
title: CrashPlan on QNAP
url: /2011/10/09/crashplan-on-qnap/
---


First up on my [QNAP](https://david.gyttja.com/2011/10/08/auf-wiedersehen-frankenstein-hello-qnap/): offsite backup of my data in "the cloud". QNAP's recommended and integrated cloud backup provider was a bit too expensive for my taste, especially since I plan to backup nearly 1TB of data. After some serious googling I found the perfect candidate: [CrashPlan](http://www.crashplan.com/).

<!--more-->

CrashPlan's software–written in Java–has two components, a server and a GUI client. This makes it a perfect candidate for QNAP. Get the server running in headless mode on my QNAP, then connect to it via the GUI client from my desktop machine.

* First up with the QNAP, install [Optware IPKG](http://wiki.qnap.com/wiki/Install_Optware_IPKG).

* Then follow Cokeman's excellent guide for [CrashPlan on a QNAP](http://cokeman.dk/qnap/crashplan).

* Installed [CrashPlan for OSX](http://www.crashplan.com/consumer/download.html?os=Mac) and modded the `ui.properties` file to `servicePort=4200` as in [CrashPlan's docs](http://support.crashplan.com/doku.php/how_to/configure_a_headless_client) (to edit I used TextMate):
    ```bash
    $ mate /Applications/CrashPlan.app/Contents/Resources/Java/conf/ui.properties
    ```

* Added a tunnel to my QNAP in [SSHKeyChain](http://sshkeychain.sourceforge.net/) (an excellent program to manage SSH connections and tunnels):

    ![SSHKeyChain CrashPlan tunnel configuration](/images/2011/10/crashplan-tunnel.png "SSHKeyChain CrashPlan tunnel configuration")


* Open CrashPlan on Mac. Because of the `ui.properties` configuration change, you will now be connecting from CrashPlan's Mac GUI to the CrashPlan engine on QNAP. Go through the CrashPlan setup, configure backup options, done!

    ![Connecting to headless CrashPlan engine via OSX GUI](/images/2011/10/crashplan-remote.png "Connecting to headless CrashPlan engine via OSX GUI")
