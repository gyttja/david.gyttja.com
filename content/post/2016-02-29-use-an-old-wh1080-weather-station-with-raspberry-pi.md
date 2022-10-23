---
author: David
categories:
  - Raspberry Pi
date: '2016-02-29T22:20:56+01:00'
guid: https://david.gyttja.com/?p=407
id: 407
permalink: /2016/02/29/use-an-old-wh1080-weather-station-with-raspberry-pi/
tags:
  - weather
title: Use an old WH1080 weather station with a raspberry pi
url: /2016/02/29/use-an-old-wh1080-weather-station-with-raspberry-pi/
---


I have an [old WH1080 weather station](http://www.clasohlson.com/se/Väderstation-med-pekskärm/Pr363242000) and was thinking, "I bet I could wire up a 433MHz receiver to an arduino or raspberry pi and read the wireless sensors to chart the weather data". I found lots of links for reading the wireless sensors, but then I looked closely at my weather station display and noticed the USB port: I had forgotten that there was a port there! Excellent! Problem solved, and I could solve it without extra hardware!

![wh1080](/images/2016/02/wh1080.jpg)

I found a [great, oldish blog entry](http://blog.schwabl.net/2013/02/21/wfrog-on-a-raspberry-pi-visualize-wh1080-weather-station/) to help me out with the basic steps of reading the data via USB on a raspberry pi. The code dependencies that were manually compiled in that link are now included in the latest raspbian distro (jessie), so those manual compilation steps are no longer necessary.

The basic steps are:

1. Install python and required dependencies
2. Install [Python software for USB Wireless WeatherStations](http://pywws.readthedocs.org/en/latest/)
3. Verify WH1080 weather station can be read from raspberry pi (using pywws)
4. Install a weather station logger (like [wfrog](https://github.com/wfrog/wfrog) or [weewx](http://www.weewx.com))

<!--more-->

I tested both wfrog and weewx (both very capable weather loggers), but decided to stick with the very simple wfrog. Here's how I did it:

* Make sure your Raspbian is up to date (I'm on Jessie):
    ```bash
    sudo apt-get update
    sudo apt-get upgrade
    ```

* Install python, dependencies, usb library, etc:
    ```bash
    sudo apt-get install python python-pip python-dev libudev-dev libusb-1.0-0 libusb-1.0-0-dev
    ```

* Install pip (python package manager):
    ```bash
    sudo pip install --upgrade pip
    ```

* Install required python packages:
    ```bash
    sudo pip install tzlocal
    sudo pip install libusb1
    sudo pip install pyusb --pre
    ```

* Install pywws:
    ```bash
    sudo pip install pywws
    ```

* Plug in the WH1080 weather station

* Test connectivity:
    ```bash
    sudo pywws-testweatherstation
    ```
    You should get something like this:
    ```
    21:58:02:pywws.Logger:pywws version 15.12.0
    0000 55 aa ff ff ff ff ff ff ff ff ff ff ff ff ff ff 1e 20 02 33 09 00 00 00 01 00 00 63 00 00 20 07
    0020 3e 28 ca 27 00 00 00 00 00 00 00 16 02 29 21 57 41 23 c8 00 00 00 46 2d 2c 01 64 80 c8 00 00 00
    0040 64 00 64 80 a0 28 80 25 a0 28 80 25 00 b4 00 00 68 01 00 0a 00 f4 01 12 00 00 00 00 00 00 00 00
    0060 00 00 50 0a 63 0a 57 01 5f 00 ce 01 c7 80 ce 01 c7 80 73 01 2b 80 b0 28 27 25 3d 29 60 25 de 02
    0080 be 00 a2 00 23 01 b0 01 36 03 5c 10 00 11 09 12 09 04 10 01 05 21 23 12 04 14 16 07 10 07 04 18
    00a0 01 09 06 30 19 34 15 02 04 04 47 07 01 01 12 00 10 02 22 08 19 07 01 01 12 00 10 02 22 08 19 07
    00c0 01 01 12 00 16 02 29 21 54 12 01 29 20 35 15 01 11 00 25 13 02 25 21 34 12 01 04 11 23 09 12 03
    00e0 20 40 09 07 07 09 46 14 08 15 21 33 09 06 15 04 41 14 08 10 03 02 14 08 27 00 42 12 11 29 02 43
    ```

* Install wfrog:
    ```bash
    sudo apt-get install wfrog
    ```

* Create the configuration, answer the questions and the configuration file will be created:
    ```bash
    sudo wfrog -S
    ```
    There seems to be a minor bug in this wfrog distribution which prevents it from starting up and prevents it from creating a new configuration, you will most likely need to delete the default (empty) configuration file and let it be regenerated automatically if you get this message:
    ```bash
    This is the setup of wfrog 0.8.2-svn user settings that will be written in /etc/wfrog/settings.yaml
    Traceback (most recent call last):
      File "/usr/bin/wfrog", line 132, in <module>
        settings = wflogger.setup.SetupClient().setup_settings(SETTINGS_DEF, settings, settings_file)
      File "/usr/lib/wfrog/wflogger/setup.py", line 70, in setup_settings
        self.recurse_create(defs, source, target)
      File "/usr/lib/wfrog/wflogger/setup.py", line 80, in recurse_create
        if source_node.has_key(k):
    AttributeError: 'NoneType' object has no attribute 'has_key'
    ```

    So, do this:
    ```bash
    sudo rm /etc/wfrog/settings.yaml
    ```
    Then, start wfrog again manually to create the configuration file:
    ```bash
    sudo wfrog -S
    ```

* The installed wfrog package automatically creates an initd script, start it up:
    ```bash
    sudo service wfrog start
    ```

* Surf to the report: [http://raspberrypi.local:7680](http://raspberrypi.local:7680)</a>

* Done! Or almost... a few hours later I noticed a bug while perusing the logs (`/var/log/wfrog.log`), and repaired it [with help from this comment](https://github.com/wfrog/wfrog/issues/106). Hopefully in a future version this gets patched, otherwise I'll manually make the change again.

![wfrog report](/images/2016/02/wfrog.png)

On a sidenote, now that I have graphs and historical sensor data, one interesting thing I noticed is that in the middle of the day, the temperature spikes up to nearly 15˚C, which it most definitely is not. We've had some very beautiful and sunny days these past few days in Stockholm, but not that warm... I think I'll have to move the temperature sensor out of the direct sunlight, and see if that helps prevent these spikes.

---

_Updated 2016-03-01: minor typos, readability._
