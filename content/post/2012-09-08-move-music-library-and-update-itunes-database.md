---
author: David
categories:
  - OSX
date: '2012-09-08T20:55:07+02:00'
guid: http://gyttja.wordpress.com/?p=179
id: 179
permalink: /2012/09/08/move-music-library-and-update-itunes-database/
tags:
  - itunes
title: Move music library and update iTunes database
url: /2012/09/08/move-music-library-and-update-itunes-database/
---


I'm doing some reorganization of my network shares. My music is saved on the server under its own share, "Music". In the new scheme, I want the music folder to be located in a subfolder in the share "Multimedia". This poses a small problem: I have to update iTunes to recognize the new file locations. I've got iTunes 10.6.3 on OS X Mountain Lion 10.8.1.

<!--more-->

## Edit iTunes Music Library.xml

The simple solution is to modify the Location values in the `iTunes Music Library.xml` file, mangle the `iTunes Library.itl` file, then open iTunes. iTunes will then rebuild the database file based on the xml (the .itl file is the active database file, the .xml file is regenerated based on the .itl database).  To find and replace all the locations I tried this:

```bash
cat ~/Music/iTunes/iTunes Music Library.xml | perl -pe 's//Volumes/Music///Volumes/Multimedia/music//i' > itunes.xml
```

Then quickly checked to see if I was missing any other locations:

```bash
cat itunes.xml | grep &quot;Location&quot; | grep -v &quot;/Volumes/Multimedia/music&quot;
```

Then erase `iTunes Library.itl`, replace `iTunes Music Library.xml` with this new copy (making backups of the originals first, of course).

An unfortunate side effect of rebuilding the .itl based on the xml: the Date Added values for the entire library are reset (probably other values are reset as well). I wanted to move my library files and keep all the metadata intact.

## Edit iTunes Library.itl

So, instead of editing the xml file, what about editing the itl file? Unfortunately, the .itl file is a proprietary format binary file. Luckily, there are some who have tinkered with the file in order to edit .itl database entries. Enter [Tools for iTunes Libraries (titl)](http://code.google.com/p/titl/): excellent! I cloned the mercurial repository, built the code and tried to move some files:

```bash
$ hg clone https://code.google.com/p/titl/ titl
$ cd titl
$ mvn verify
$ java -Xmx512m -XX:MaxPermSize=256m -jar titl-core/target/titl-core-0.3-SNAPSHOT.jar MoveMusic --use-urls ~/Music/iTunes/iTunes Library.itl &quot;file://localhost/Volumes/Music&quot; &quot;file://localhost/Volumes/Multimedia/music&quot;
```

That resulted in a `Exception in thread "main" java.io.EOFException`, the exact same issue as [this one](http://code.google.com/p/titl/issues/detail?id=18). Downloaded the patch file that the user thankfully uploaded, applied the patch to the code, and tried again (disabling the now broken unit tests with `-Dmaven.test.skip=true`): success! Excellent!

Final step: rename the `iTunes Library.itl.processed` file to `iTunes Library.itl` (making backup first of the original file of course). iTunes works as expected, music files are found, play count still there, "last added" dates still there.

Not that I use iTunes very often (or really at all) anymore to play music. Spotify is the scheisse these days! ;)

---

_Updated 2011-12-16: Uploaded the [patched + compiled jar](http://dl.dropbox.com/u/381583/titl-core-0.3-SNAPSHOT.zip) (for those of you who want it)_
