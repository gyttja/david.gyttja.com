---
author: David
categories:
  - MacOS
  - Homelab
date: '2023-01-07T13:37:00+01:00'
permalink: /2023/01/07/jviewer-on-apple-silicon/
tags:
  - java
  - jviewer
title: JViewer on Apple Silicon
url: /2023/01/07/jviewer-on-apple-silicon/
---

My homelab server runs on a nice, oldish [Asrock Rack D1541D4U-2T8R](https://www.asrockrack.com/general/productdetail.asp?Model=D1541D4U-2T8R). Unfortunately, Asrock has not provided recent firmware updates for the motherboard and to access the remote KVM-capabilities of the BMC, the antiquated java-webstart-based JViewer software is still required. In contrast, Supermicro motherboards (ok, at least this one: [X10SDV-4C-TLN2F](https://www.supermicro.com/en/products/motherboard/x10sdv-4c-tln2f)) with the same Aspeed AST2400 BMC support remote KVM via a nice web-based GUI.

<!--more-->

JViewer itself is not all bad: it works, it does what it needs to do. Unfortunately, when I bought my new M1-based Mac a year ago JViewer stopped working completely. I couldn't open it. Not good. What I found out is that JViewer (for my Asrock Rack motherboard) must have Java 8, not newer, and must be of type x64 architecture, not aarch64 (Apple Silicon). [Openwebstart](https://openwebstart.com/) is a great solution for executing jnlp files, but no matter what I tried, I couldn't _force_ JViewer to use the JVM it needed, even when removing all other JVM configurations and only having a Rosetta-based x64-based JVM configured:

![Openwebstart failing to open JViewer, even with a x64 Java 8 JVM](/images/2023/01/jviewer-fail.png)


## jviewer-starter

Tl;DR: [Use my modified jviewer-starter to simplify starting JViewer on your ASRock Rack D1541D4U-2T8R](https://github.com/dfuchslin/jviewer-starter)

Scouring the internet led me to this great script: [jviewer-starter.py](https://github.com/arbu/jviewer-starter/blob/master/jviewer-starter.py). Instead of manually logging into the webportal of the server's BMC, downloading the jnlp, double-clicking, accepting the security warning, then clicking another security warning or two, the script simplifies this. In very general and nonspecific terms, a jnlp (java webstart) file contains the server path(s) to the class/jar files for the application as well as the arguments. If you were to download the specified files you could manually instantiate the java application from the command line, such as `java -cp path/to/downloaded/jars main.class.FileName arg1 arg2`. You can skip jnlp and all the hassle around "Java Web Start" completely. This is what the jviewer-starter script does.

## Java + Rosetta

JViewer still requires Java 8 _and_ Java 8 for Intel, not Apple Silicon. I chose to install the [Zulu OpenJDK build](https://www.azul.com/downloads/?version=java-8-lts&os=macos&package=jdk), for x64 architecture, of course also installing Rosetta. I also installed the JDK manually so I could install the native Apple Silicon Zulu JDK with homebrew (`brew install zulu8`) and have them both installed, side-by-side, in `/Library/Java/Frameworks` to easily switch between the two if I desired.
```bash
❯ ls -l /Library/Java/JavaVirtualMachines
total 0
drwxr-xr-x  3 root  wheel  96 Aug  2 11:03 zulu-8-x64.jdk
drwxr-xr-x  3 root  wheel  96 Oct 19 20:59 zulu-8.jdk
```

Then I set `JVIEWER_JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8-x64.jdk` in my `.zshrc` so jviewer-starter would pick up the correct `JAVA_HOME`.

## Running it

After symlinking to `/usr/bin/local` (which is in my `$PATH`), I can now access jviewer very easy now, skipping Openwebstart completely.
```bash
❯ jviewer-starter --host <server_ipmi_ip> --username <username> --password <password>

Starting jviewer
Using java: /Library/Java/JavaVirtualMachines/zulu-8-x64.jdk/Contents/Home/bin/java
IPMI host: <server_ipmi_ip>
Username: <username>
Password: **************
/Library/Java/JavaVirtualMachines/zulu-8-x64.jdk/Contents/Home/bin/java -Djava.library.path=/Users/david/Library/Application Support/jviewer-starter -cp /Users/david/Library/Application Support/jviewer-starter/* com.ami.kvm.jviewer.JViewer -apptype JViewer -hostname ******* -kvmtoken ******** -kvmsecure 0 -kvmport 7578 -vmsecure 0 -cdstate 1 -fdstate 1 -hdstate 1 -cdport 5120 -fdport 5122 -hdport 5123 -cdnum 0 -fdnum 0 -hdnum 0 -extendedpriv 259 -localization EN -keyboardlayout AD -singleportenabled 0 -webcookie ********** -oemfeatures 11
```

![JViewer opens successfully!](/images/2023/01/jviewer-success.png)

## Future"proofing" with docker

I assume Rosetta won't be around forever, so I also encapsulated the script within a x64-based docker container that exposes the Java Swing GUI components (is it still called Swing these days??) by pointing the `DISPLAY` variable to the docker host within the running container. This requires X-Quartz to be installed on MacOS, and I also found out there is a [strange rendering bug specific to Java GUI applications](https://github.com/XQuartz/XQuartz/issues/31) in XQuartz 2.8.2+ (apparently still not fixed?). This can be remedied by appling some arguments to `JAVA_OPTIONS`, which I applied in the docker startup script.

Using the docker container means I'm not dependent upon having a specific java installed on the host machine. Nice!

# All the code

The project is described a bit more in detail [here on GitHub](https://github.com/dfuchslin/jviewer-starter), I hope this helps someone!
