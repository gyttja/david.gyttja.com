---
author: David
categories:
  - iOS
  - Ubuntu
date: '2010-11-11T22:12:49+01:00'
guid: http://gyttja.wordpress.com/?p=3
id: 6
permalink: /2010/11/11/airprint-on-ubuntu/
tags:
  - AirPrint
title: AirPrint on Ubuntu
url: /2010/11/11/airprint-on-ubuntu/
---


## How to print from iPhone/iPad (iOS 4.2) via Ubuntu

I just noticed that with the latest 10.6.5 update, Apple at the last minute [disabled support for printing from iOS 4.2 devices to shared printers in OSX](http://www.macrumors.com/2010/11/10/steve-jobs-replies-regarding-rumors-of-airprint-issues/). Instead of trying to [overwrite new drivers with prerelease versions](http://www.macrumors.com/2010/11/10/steve-jobs-replies-regarding-rumors-of-airprint-issues/), I thought that there must be someone, somewhere out there who has figured out how to do this using the fine, free tools available to us. I like open standards, open tools, open source.

<!--more-->

From what I understand AirPrint supports printing two ways:
* Via officially-supported HP ePrint printers that advertise themselves on your subnet
* Via shared printers from Mac/Windows (this is the part that apparently got axed, at least in the latest 10.6.5 update... don't know how Windows will fare)

I don't have a new HP ePrint printer, but I do have a wonderful Ubuntu 10.04 server running avahi (open source Bonjour/mDNS responder)... I wonder if there's a way to have my server act as an AirPrint device and then send the print job to my networked printer?

Enter [this post](http://www.rho.cc/index.php/linux2/48-misc/104-printing-from-ipad-airprint-via-cups). Excellent! Set up a Bonjour service, point it to a shared printer, done!

Here's what I had to do in Ubuntu  to get printing to work, YMMV:

* Install my printer (networked HP Color LaserJet 1515n) using the graphical configuration utility (System->Administration->Printing). Make sure the printer is shared.

* Updated my `/etc/cups/cupsd.conf` configuration to allow network access (default Ubuntu configuration is for localhost only):

  ```bash
  # Only listen for connections from the local machine.
  #Listen localhost:631
  #Listen /var/run/cups/cups.sock
  Port 631
  ServerAlias *
  ```

  and

  ```bash
  # Restrict access to the server...
  <Location />
  Order allow,deny
  Allow @LOCAL
  </Location>
  ```

* Tested remote access to Ubuntu's cups web GUI from my laptop (to make sure machines other than the Ubuntu server had access to cups): http://172.16.0.50:631/printers/

* Tested that I could print remotely from my laptop to the new shared printer on Ubuntu (simple "Add Printer" in OSX and then print test page)

* Configured avahi with a new printer service `/etc/avahi/services/printer.service`. As mentioned in the original link, rp and adminurl are the most important configuration bits.
  ```xml
  <?xml version="1.0" standalone='no'?>
  <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
  <service-group>
    <name>HP 1515n</name>
    <service>
      <type>_ipp._tcp</type>
      <subtype>_universal._sub._ipp._tcp</subtype>
      <port>631</port>
      <txt-record>txtver=1</txt-record>
      <txt-record>qtotal=1</txt-record>
      <txt-record>rp=printers/hp-cp1515n</txt-record>
      <txt-record>ty=HP 1515n</txt-record>
      <txt-record>adminurl=http://172.16.0.50:631/printers/hp-cp1515n</txt-record>
      <txt-record>note=HP Color LaserJet cp1515n</txt-record>
      <txt-record>priority=0</txt-record>
      <txt-record>product=virtual Printer</txt-record>
      <txt-record>printer-state=3</txt-record>
      <txt-record>printer-type=0x801046</txt-record>
      <txt-record>Transparent=T</txt-record>
      <txt-record>Binary=T</txt-record>
      <txt-record>Fax=F</txt-record>
      <txt-record>Color=T</txt-record>
      <txt-record>Duplex=T</txt-record>
      <txt-record>Staple=F</txt-record>
      <txt-record>Copies=T</txt-record>
      <txt-record>Collate=F</txt-record>
      <txt-record>Punch=F</txt-record>
      <txt-record>Bind=F</txt-record>
      <txt-record>Sort=F</txt-record>
      <txt-record>Scan=F</txt-record>
      <txt-record>pdl=application/octet-stream,application/pdf,application/postscript,image/jpeg,image/png,image/urf</txt-record>
      <txt-record>URF=W8,SRGB24,CP1,RS600</txt-record>
    </service>
  </service-group>
  ```

* Printed a page from iOS simulator

  <a href="/images/2010/11/print-dn.png"><img class="alignnone size-full wp-image-9" title="AirPrinting DN från iOS simulator" src="/images/2010/11/print-dn.png" alt="" width="630" height="816" /></a>

* Printed a page from iPhone 3GS with iOS 4.2.1:

  <img class="alignnone size-medium wp-image-93" title="iphone-airprint" src="/images/2010/11/iphone-airprint.png?w=200" alt="" width="200" height="300" />

* Done!

I'm not sure if all printers will work out of the box with this configuration, but since my printer supports PostScript I assume it can rasterize pretty much anything iOS will send it. In any case, I didn't have to configure any filters or print settings. It just worked. Hopefully Apple won't further cripple AirPrinting by also "patching" iOS so that only HP ePrint devices are supported and it no longer recognizes Bonjour services with subtype `_universal._sub._ipp._tcp`. We'll see what happens!

Now all I need is an iPad. And a reason to print.

---

*Updated 2010-11-21: repaired some mangled XML due to Wordpress's less-than-nice HTML-parsing*

*Updated 2010-11-23: added post subtitle, added screenshot from iPhone*
