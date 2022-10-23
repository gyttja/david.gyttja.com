---
author: David
categories:
  - Uncategorized
date: '2018-12-13T21:53:13+01:00'
guid: https://david.gyttja.com/?p=467
id: 467
permalink: /2018/12/13/connecting-to-a-remote-dockerd-on-rancheros-on-freenas/
tags:
  - docker
  - FreeNAS
title: Connecting to a remote dockerd on RancherOS on FreeNAS
url: /2018/12/13/connecting-to-a-remote-dockerd-on-rancheros-on-freenas/
---



Last summer I migrated from an old QNAP NAS to FreeNAS. I also started using docker containers with RancherOS, via [the FreeNAS-provided virtual machine image](https://www.ixsystems.com/documentation/freenas/11/vms.html#docker-rancher-vm). I initially installed all my containers using the RancherOS cli (ssh into the machine), but now I am moving my container configurations out of the VM cli and versioning them so that I can at any point rebuild (or upgrade) the RancherOS disk image, and be able to reload all my containers. So I want to be able to run docker commands from my localhost cli, but have them be run on the RancherOS docker daemon.

<!--more-->

### Expose docker in RancherOS

To simplify life, copy your public ssh key to the RancherOS VM to enable passwordless login:
```bash
ssh-copy-id rancher@<rancheros-ip>
```

From MacOS with docker installed, run [the following command](https://docs.docker.com/machine/drivers/generic/#example) to set up a docker connection from localhost to RancherOS, as well as magically open dockerd for TCP connections on port 2376 on the RancherOS VM:

```bash
docker-machine create \
  --driver generic \
  --generic-ip-address=<rancheros-ip> \
  --generic-ssh-key ~/.ssh/id_rsa \
  --generic-ssh-user=rancher \
  rancheros-docker
```

To verify the new machine configuration was created run the following:

```bash
$ docker-machine ls
NAME               ACTIVE   DRIVER    STATE     URL                         SWARM   DOCKER        ERRORS
rancheros-docker   *        generic   Running   tcp://<rancheros-ip>:2376           v17.09.1-ce
```

### Use docker from RancherOS on localhost

Switch the docker context to the newly created docker machine configuration:

```bash
eval "$(docker-machine env rancheros-docker)"
```

Now, any docker commands will be executed on the RancherOS docker, not localhost.

### Reset docker on localhost back to defaults

To reset localhost back to normal (use the locally installed docker):

```bash
eval "$(docker-machine env -u)"
```

## Upcoming changes

Starting with [Docker 18.09](https://docs.docker.com/engine/release-notes/#1809), connecting to a remote docker can be done much more easily as [ssh connections are supported in the `DOCKER_HOST` variable](https://github.com/docker/cli/pull/1014)! So that means all of the above can be replaced by just a simple export:

```bash
export DOCKER_HOST=ssh://rancher@<rancheros-ip>
```

This will require Docker 18.09 both locally and on the RancherOS VM, but it looks it will be a while before both RancherOS and FreeNAS have 18.09 available. The latest stable FreeNAS 11.2 has RancherOS 1.4.2, which has Docker 18.06, perhaps FreeNAS 11.3?
