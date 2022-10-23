---
author: David
categories:
  - OSX
  - Ubuntu
date: '2010-11-18T17:59:35+01:00'
guid: http://gyttja.wordpress.com/?p=50
id: 50
permalink: /2010/11/18/reduce-the-size-of-mysql-ibdata1-on-osx/
title: Reduce the size of MySQL ibdata1 on OSX
url: /2010/11/18/reduce-the-size-of-mysql-ibdata1-on-osx/
---


So I finally figured out why my TimeMachine backups were becoming bigger and bigger, 3-4GB backing up every day when I come home from work... It seems that my MySQL database file (`/usr/local/mysql/data/ibdata1`) keeps getting larger and larger, unnecessarily, even if I deleted databases, tables, etc. It seems even if I only update a few rows in a table in a small database, the ginormous `idbdata1` file grows and then get marks as a candidate for backup into TimeMachine. Ugh.

<!--more-->

I did some digging and found this interesting tutorial on [how to clean up InnoDB storage files](http://stackoverflow.com/questions/3927690/howto-clean-a-mysql-innodb-storage-engine).  Here I'll explain what I specifically did on my OSX 10.6.5 machine with MySQL v5.1.38.

1. If you're not a cowboy, stop MySQL, backup all files, then start MySQL again (I used the System pref to stop/start MySQL, feel free to use the command-line instead):

    <img src="/images/2010/11/mysql-stop-pref.png" alt="" title="mysql-stop-pref" width="630" height="150" />

    ```bash
    $ sudo cp -R /usr/local/mysql/data /usr/local/mysql/data.bak
    ```
    <img src="/images/2010/11/mysql-start-pref.png" alt="" title="mysql-start-pref" width="630" height="150" />

2. Export all data from MySQL:
    ```bash
    $ mysqldump -u root -p --all-databases > alldatabases.sql
    ```

3. Drop databases in MySQL (except "mysql" and "information_schema"):

    ```bash
    $ mysql -u root -p
    mysql> show databases;
    mysql> drop database XXXX;
    ```

    or use [this great one-liner to delete all databases](http://rootedlabs.wordpress.com/2009/10/03/drop-all-databases-in-mysql/), modded a bit so it would work for me:

    ```bash
    # measure twice, cut once... make sure we are deleting what we should be deleting
    $ mysql -u root -p  -e "show databases" | grep -v Database | grep -v mysql | grep -v information_schema | awk '{print "drop database " $1 ";select sleep(0.1);"}'
    # now delete them
    $ mysql -u root -p  -e "show databases" | grep -v Database | grep -v mysql | grep -v information_schema | awk '{print "drop database " $1 ";select sleep(0.1);"}' | mysql -uroot -ppassword
    ```

4. Stop MySQL again

5. Add the following to the `[mysqld]` section in `/etc/my.cnf`:
    ```bash
    [mysqld]
    innodb_file_per_table
    ```

6. Remove the files:
    ```bash
    $ sudo rm /usr/local/mysql/data/ibdata1
    $ sudo rm /usr/local/mysql/data/ib_logfile0
    $ sudo rm /usr/local/mysql/data/ib_logfile1
    ```

7. Start MySQL again

8. Reload the databases from the sql dump-file:
    ```bash
    $ mysql -u root -p < alldatabases.sql
    ```

9. Verify that your database(s) are working properly

10. Delete the backup
    ```bash
    $ sudo rm -rf /usr/local/mysql/data.bak
    ```

11. Done!

After this modification my TimeMachine backups are much more reasonably-sized. Very nice!

Furthermore, I noticed the same infamously large `ibdata1` file on our continuous-integration build server at work: it was 40GB! I applied the same modifications as above. That server runs Ubuntu 10.10, the MySQL files are located in `/var/lib/mysql/data`, but otherwise the steps are pretty much the same. Even build-server bongo seems snappier now, and the total size of the MySQL data folder is 1GB (insane that there was 39GB of "dead" data in the ibdata1-file...)

Very happy.
