---
author: David
categories:
  - QNAP
date: '2012-12-16T22:03:11+01:00'
guid: http://gyttja.wordpress.com/?p=194
id: 194
permalink: /2012/12/16/update-crashplan-on-qnap/
tags:
  - backup
  - cloud
  - CrashPlan
title: Update CrashPlan on QNAP
url: /2012/12/16/update-crashplan-on-qnap/
---


It's happened to me twice now: CrashPlan stops backing up my files apparently due to a failed software update. I usually don't know CrashPlan has stopped backing up until I get the weekly email status update. Fortunately, the files that I back up to CrashPlan are not changed often at all, and missing a backup for a couple days isn't the end of the world.

<!--more-->

I have CrashPlan installed on my QNAP (see [my previous post about that](https://david.gyttja.com/2011/10/09/crashplan-on-qnap/)), and CrashPlan smartly autoupdates their software every now and then. Unfortunately this autoupdate doesn't seem to work when installed on QNAP. The following instructions should help get CrashPlan updated and running again smoothly.

Connect to the CrashPlan server running on QNAP by first creating an SSH tunnel to QNAP and then open the GUI client locally (connecting to the CrashPlan server through the ssh tunnel). The GUI reports that "CrashPlan Upgrade Failed. CrashPlan failed to apply an upgrade and will try again automatically in one hour..."
![crashplanupgradefailed](/images/2012/12/crashplanupgradefailed.png)

How to upgrade (I had version 3.2.1 installed, version 3.4.1 was available):

* Stop the CrashPlan server:
    ```bash
    $ /share/MD0_DATA/.qpkg/crashplan/cprun.sh stop
    ```
* Move the existing CrashPlan installation out of the way:
    ```bash
    $ mv /opt/crashplan /opt/crashplan.bak
    ```

* Download the latest linux version of CrashPlan, decompress the tarball, etc
    ```bash
    $ wget http://download.crashplan.com/installs/linux/install/CrashPlan/CrashPlan_3.4.1_Linux.tgz
    $ tar xzvf CrashPlan_3.4.1_Linux.tgz
    $ rm CrashPlan_3.4.1_Linux.tgz
    ```

* Edit the CrashPlan install.sh, replace the bash path and add <code>BINSLOC</code> at the top:
    ```bash
    $ cd CrashPlan-install
    $ nano install.sh
    #!/opt/bin/bash
    BINSLOC="/bin /opt/bin /usr/bin /usr/local/bin";
    ```

* Now, run the install script:
    ```bash
    $ ./install.sh
    Would you like to switch users and install as root? (y/n) [y] n
      installing as current user
    No Java VM could be found in your path
    Would you like to download the JRE and dedicate it to CrashPlan? (y/n) [y] y
      jre will be downloaded

    ...

    Do you accept and agree to be bound by the EULA? (yes/no) yes

    What directory do you wish to install CrashPlan to? [/root/crashplan] /opt/crashplan
    /opt/crashplan does not exist.  Create /opt/crashplan? (y/n) [y] y

    What directory do you wish to store backups in? [/opt/crashplan/manifest]
    /opt/crashplan/manifest does not exist.  Create /opt/crashplan/manifest? (y/n) [y]

    Your selections:
    CrashPlan will install to: /opt/crashplan
    And store datas in: /opt/crashplan/manifest

    Is this correct? (y/n) [y] y

    ...

    ./install.sh: /opt/crashplan/bin/CrashPlanEngine: /bin/bash: bad interpreter: No such file or directory

    CrashPlan has been installed and the Service has been started automatically.
    ```

* Oops, need to fix some paths in `/opt/crashplan/bin/CrashPlanEngine`. Add the `BINSLOC` at the top of the file, and add the full path to `nice`:
    ```bash
    #!/opt/bin/bash
    BINSLOC="/bin /opt/bin /usr/bin /usr/local/bin"
    ...
    /opt/bin/nice -n 19 $JAVACOMMON $SRV_JAVA_OPTS -classpath $FULL_CP com.backup42.service.CPService > $TARGETDIR/log/engine_output.log 2>
    $TARGETDIR/log/engine_error.log &
    ```

* Now, move the backed up configuration/cache folders into place:
    ```bash
    $ mv /opt/crashplan.bak/conf /opt/crashplan/
    $ mv /opt/crashplan.bak/cache /opt/crashplan/
    $ mv /opt/crashplan.bak/manifest /opt/crashplan/
    ```

* Then start CrashPlan:
    ```bash
    $ /share/MD0_DATA/.qpkg/crashplan/cprun.sh start
    ```

* Connect from the client and verify in the GUI that the server is now working:
    ![crashplanupgradesuccessful](/images/2012/12/crashplanupgradesuccessful1.png)

* And finally, clean up the unused, old crashplan backup (mine was 2.1GB as there seemed to be 100s of failed yet downloaded upgrade attempts):
    ```bash
    $ rm -rf /opt/crashplan.bak
    ```

Happy CrashPlanning!
