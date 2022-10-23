---
author: David
categories:
  - Hybris
date: '2015-05-18T22:42:01+02:00'
guid: https://david.gyttja.com/?p=390
id: 390
permalink: /2015/05/18/generate-dependency-graph-for-hybris/
title: Generate dependency graph for Hybris
url: /2015/05/18/generate-dependency-graph-for-hybris/
---


I'm currently working as a developer on a large [Hybris](https://www.hybris.com/en/) e-commerce solution. The codebase has been delivered to us with a large number of extensions and I was having a hard time visualizing how all the extensions were interconnected. I put together this simple script one evening, and made some quick tweaks at work to get it to work with our codebase. After generating the graph, we could immediately see where we were having dependency issues and were able to make adjustments.

<!--more-->

Anyway, as the Hybris community is such a closed community I thought I'd share this utility. Perhaps it will also be useful for some of you Hybris developers out there!

The script: [https://github.com/dfuchslin/hybris-tools/tree/master/dependency-graph](https://github.com/dfuchslin/hybris-tools/tree/master/dependency-graph)

Sample dependency graph output:
![extensions](/images/2015/05/extensions.svg)
