---
author: David
categories:
  - OSX
  - QNAP
date: '2015-05-01T11:01:40+02:00'
guid: https://david.gyttja.com/?p=384
id: 384
permalink: /2015/05/01/disable-crashplanservice-on-osx/
tags:
  - CrashPlan
title: Disable CrashPlanService on OSX
url: /2015/05/01/disable-crashplanservice-on-osx/
---


Since I run [CrashPlan on my QNAP](/2011/10/09/crashplan-on-qnap/) to back up my personal data, yet I still want to use the CrashPlan GUI on my Mac, I don't need the CrashPlanService running in the background on my Mac all the time.

<!--more-->

To disable the always-running CrashPlan service on OSX (verified with the latest CrashPlan app, version 3.7):

1. See if the service is running:
    ```bash
    ps aux | grep CrashPlanService
    ```

2. Disable service:
    ```bash
    sudo launchctl unload /Library/LaunchDaemons/com.crashplan.engine.plist
    ```

3. Verify the service is not running anymore:
    ```bash
    ps aux | grep CrashPlanService
    ```

4.  Delete the launch control plist so the CrashPlanService doesn't reload the next time OSX is restarted:
    ```bash
    sudo rm /Library/LaunchDaemons/com.crashplan.engine.plist
    ```

That's it!
