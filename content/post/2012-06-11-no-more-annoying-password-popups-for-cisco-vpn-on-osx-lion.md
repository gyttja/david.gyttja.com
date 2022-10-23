---
author: David
categories:
  - OSX
date: '2012-06-11T17:51:07+02:00'
guid: http://gyttja.wordpress.com/?p=145
id: 145
permalink: /2012/06/11/no-more-annoying-password-popups-for-cisco-vpn-on-osx-lion/
title: No more annoying password popups for Cisco VPN on OSX Lion (and Mountain Lion)!
url: /2012/06/11/no-more-annoying-password-popups-for-cisco-vpn-on-osx-lion/
---


I am currently working on a development project for our office in München. Accessing their internal servers requires connection via VPN (I'm working from Stockholm). I'm using the very handy built-in Cisco IPSEC VPN client in OSX and have had some annoying problems which until today I have not been able to solve. I am documenting these configuration changes so I remember what I did, and hopefully it can also help others out there!

<!--more-->

## The problem

After being connected via VPN for about 48-54 minutes (seems to vary), OSX will throw up a "please enter password" dialog (I can't remember the exact wording...). After entering the password, the VPN connection stays active for another 48-54 minutes, at which time another password dialog pops up. Lather, rinse, repeat. Not very fun during a standard work day, especially when my application-in-progress likes to crap out as soon as it loses connectivity to those remote servers (and requires lengthy restarts).

## The solution (I thought)

After much googling I found [this solution](http://simon.heimlicher.com/articles/2011/03/17/cisco-vpn), for which I had high hopes (despite the comments from fellow OSX Lion users who couldn't get the solution to work). In short, that post goes about showing how to grant `/usr/libexec/configd` access to your keychain, in order to squelch the password dialog. Well, unfortunately that solution didn't work for me as well :(

## The working solution (finally!)

After a week or so of still getting that annoying password dialog, I managed to google the correct sequence of terms and I finally found a working solution! Over at the [Apple forums](https://discussions.apple.com/message/18164765#18164765), a very clever Mr Geordiadis posts a working solution to the problem. His solution is to modify the `racoon` configuration files for the VPN connection by tweaking a few settings and increasing the negotiated password timeout value from 3600 seconds to 24 hours (perfectly fine for my intended use). I've been connected now for over 8 hours today, haven't had a password dialog yet! So excellent! Confirmed that it works on Mountain Lion (10.8) as well.

I hope this information helps you as it helped me!

### Steps:

* Connect to the VPN so the configuration file is generated

* Create a location for the VPN configuration files
    ```bash
    $ sudo mkdir /etc/racoon/vpn
    ```

* Copy the auto-generated configuration file into the new configuration folder:
    ```bash
    $ sudo cp /var/run/racoon/1.1.1.1.conf /etc/racoon/vpn/
    ```

* Edit the `racoon.conf` file:
    ```bash
    $ sudo emacs /etc/racoon/racoon.conf
    ```

* Comment out the include line at the end of the file and include the new configuration folder:
    ```bash
    #include "/var/run/racoon/*.conf" ;
    include "/etc/racoon/vpn/*.conf" ;
    ```

* Edit the VPN configuration file:
    ```bash
    $ sudo emacs /etc/racoon/vpn/1.1.1.1.conf
    ```

* Disable dead peer detection:
    ```bash
    dpd_delay 0;
    ```

* Change proposal check to claim from obey:
    ```bash
    proposal_check claim;
    ```

* Change the proposed lifetime in each proposal (24 hours instead of 3600 seconds):
    ```bash
    lifetime time 24 hours;
    ```

* Disconnect VPN and reconnect.

---

_Updated 2012-08-07: added the detailed steps_

_Updated 2012-08-07: tested on OSX Mountain Lion (10.8)_
