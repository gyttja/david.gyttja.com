---
author: David
categories:
  - OSX
  - QNAP
date: '2014-10-13T09:56:37+02:00'
guid: https://david.gyttja.com/?p=365
id: 365
permalink: /2014/10/13/black-screen-on-retina-macbook-pro-and-restore-timemachine-from-nas/
tags:
  - TimeMachine
title: Black screen on retina MacBook Pro and restore TimeMachine from NAS
url: /2014/10/13/black-screen-on-retina-macbook-pro-and-restore-timemachine-from-nas/
---


In retrospect I should have seen it coming. I have an external monitor at work plugged in via displayport, the other port connected to my thunderbolt ethernet connection. Once while accidentally jiggling the ethernet adapter my screens went black for a second (looked like the resolutions needed to refresh or something, screens went black, then came back a few seconds later). Freaked me out, but the displays came back. Anyway, as I said, I should have taken that as a sign that something wicked this way was a comin'.

Fast-forward a month or so. Before work, morning coffee in hand, open the lid, login prompt appears. I get an SMS on my phone, so my attention diverts. Read the SMS, reply, etc. A few minutes later I go back to my Mac, the screen black as usual, as it has powered down since I didn't log in for a few minutes. Or so I thought. No amount of key presses, opening-and-closing of the lid got the screen back to life. The keyboard backlight was on, I knew the Mac was on. Close lid, wait a few minutes, open lid. No screen. Ok, power off and reboot. No screen. At all. Ok crap. Starting to stress now as I will be late for work if I don't leave soon. Scramble in the cabinets, looking for any monitor cables. Found an HDMI cable. Plugged the Mac into the TV. No video anywhere, black on both  screens. Ok, [reset PRAM (command-option-P-R at boot)](http://support.apple.com/kb/PH14222?viewlocale=en_US). Nope. Reset PRAM a dozen times. Nope. [Reset SMC](http://support.apple.com/kb/ht3964) (left shift-control-option-power). Nope. Reset SMC a half-dozen times. Nope. Still black screen.

<!--more-->

Googling on my phone reveals others who have had similar fates: black screen, no video whatsoever displaying on screen (even if trying to shine a flashlight through the lid from the apple on the back). I message our awesome IT staff at work as ask for help: maybe they have a loaner Mac I could use for work today, and we'll just send the Mac in for diagnosis. I'm told that the week before another retina MacBook Pro at work died similarly (the boss's, of all people!). The two of us have (had) the first generation 15" retina MacBook Pros, so maybe this is a common failure. Anyway, now I have a loaner retina MacBook Pro--my Mac is in the shop, probably getting all of its guts replaced. My money is on a fried GPU.

Now for the fun part: restore my data from TimeMachine. Unfortunately it wasn't a simple plug-n-play since my TimeMachine backup is on my NAS, but after a few strokes of commandline magic the restore occurred without a hitch!

* Boot into the recovery partition with command-R at boot (Note that choosing restore from TimeMachine won't help at this point since my QNAP TimeMachine share doesn't show up in the list of backups)

* Open the Terminal—can't remember where, but it's an option somewhere there—and mount the network share (you won't need sudo since the recovery partition is already root, replace username, password, aaa.bbb.ccc.ddd, sharename with the correct values):

    ```bash
    mkdir /Volumes/TimeMachine
    mount -t afp afp://username:password@aaa.bbb.ccc.ddd/sharename /Volumes/TimeMachine
    ```

* Mount the sparsebundle:

    ```bash
    hdid /Volumes/TimeMachine/timemachinebackupname.sparsebundle
    ```

* Now the tricky part! My timemachine sparsebundle is encrypted so I had to enter the password. Luckily I have my password saved in 1Password, and the passwords are synched across all my devices. So I brought up the password on my mobile and started entering it into the password dialog box. But no matter how many times I entered the password, I was getting a failure response (can't remember the exact text). Crap! Did I have the wrong password!?  After a few minutes of scratching my head I realized the problem: I have a Swedish keyboard, but the recovery partition defaults to a US keyboard layout! Even if I switched the keyboard layout to Swedish (using the menu bar), the layout switched back to US when the password dialog popped up! AHA! So now, I had to figure out how to enter the symbols correctly using the US layout (my password is complicated!). Success! The sparsebundle mounted!

* Now, continue using the TimeMachine restore functionality in the recovery partition, my QNAP TimeMachine share is now in the list of backups to choose from! :)


Basically, the restore process was simple, except for the tricky part of typing in my password with the wrong keyboard layout! [A few hours later](https://twitter.com/dfuchslin/status/519393706190069760) I was up and running, and then running off to work!
