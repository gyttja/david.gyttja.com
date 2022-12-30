---
author: David
categories:
  - Uncategorized
date: '2022-12-30T13:37:00+01:00'
permalink: /2022/12/30/quiet-hacker-news-on-cloudflare-pages/
tags:
  - hackernews
  - cloudflare
title: Quiet Hacker News on Cloudflare Pages
url: /2022/12/30/quiet-hacker-news-on-cloudflare-pages/
---

I've been reading [Hacker News](https://news.ycombinator.com/) for years, but about four of five years ago a friend told me about (now defunct) ["quiet" hacker news](https://github.com/DylanGraham/quiet-hacker-news), a quick, unstyled, simple site showing the top Hacker News stories without commentary. Of course, commentary on HN is entertaining to read, but after trying quiethn, I found I liked to focus on the articles and instead buily my own opinion on what I read, for better or worse.

<!--more-->

The original quiet hacker news site was taken offline (I don't even remember the original domain, quiethn.com??), but the sourcecode was on github and I forked it, compiiled it, and spun it up on one of my Digital Ocean droplets. It worked great and without problem for a couple years. Now, I have decided to simplify my cloud hosting and move to a more "serverless" approach with Cloudflare. [I moved this website](/2022/12/28/well-hello-there-cloudflare/) and its apex domain, but I also needed to move quiet hacker news!

## Cloudflare Pages to the rescue

The original quiethn implementation queries the HN API and caches the results for one hour. Rendering of the HTML reads the cached API response. I wanted a similar approach: cache the HN API response, render the page on-demand. There are of course mulitple approaches to this. I started out by trying the first and easiest: request-bound trigger.

Cloudflare Pages launched support for [server-side processing](https://developers.cloudflare.com/pages/platform/functions/), leveraging their excellent functions implementation while serving up fast, static content, all from the same codebase.

### Stale while revalidate

I started with a simple setup. Request comes in to `/`, if the page is found in the cache, return. If not, then query the HN API, parse the results, render the HTML, and cache the response. I also found some help online ([https://gist.github.com/wilsonpage/a4568d776ee6de188999afe6e2d2ee69](https://gist.github.com/wilsonpage/a4568d776ee6de188999afe6e2d2ee69)) that provided a stale-while-revalidate mechanism so that the response would return quickly even if had an expired TTL in the cache. This implementation worked very well! Until I launched it and added my uptime monitor, which checks from multiple locations around the world.

It seems that each Cloudflare edge node caches independently of one another, so when I tested from my internet connection and refreshed a bazillion times, I got great response times, as I was always hitting the same edge node. This, however, was not true if a request came in from another location in the world, as my uptime monitor does. These requests would hit the site with a cold cache, blocking until the upstream request to HN API returned.

Something was up. Even though this site is generally meant for my personal consumption, since it is public, anyone can access. And I want it to be performant, and I do not want to access the HN APIs unnecessarily. Once per hour should be enough, not once per hour at each Cloudflare edge node on the entire internet.

### Scheduled Function + Workers KV + Pages = 🫶

I instead looked at Cloudflare's KV storage in combination with a scheduled function. Schedule a function call the HN API every hour, save the result in a KV (which is pushed to all edge nodes), then a Cloudflare Pages function that, at request time, retrieves the value from the KV, renders the HTML, and returns the response. I pretty much already had all the code, I just had to move things around a bit. And unfortunately, when I did this (November 2022), Functions deployed in Pages did not have the ability to be scheduled -- they were (are?) request-bound only. So I now had two deploys: commit and push to main triggers the Cloudflare Pages build, and a separate subdirectly has a manual deploy (via CLI) to the Cloudflare Function for the scheduled HN API call.

This resulted in much better, more consistent performance. Plus I could feel better that I would not be unduly overloading the HN API! Here's a screenshot from my uptime monitoring, you can see the Apdex index improves remarkably with this new implementation!

![KV cache vs request-bound](/images/2022/12/qhn-updown.png)

Looking at the [current uptime monitoring response times](https://updown.io/jfei), I'm seeing mostly around 250ms. This is totally acceptable for my use case, especially considering my hosting cost: zero.

## The result

I've linked to my Cloudflare Pages implementation up in my menu or go here: [https://quiethn.gyttja.com/](https://quiethn.gyttja.com/). The source code is on GitHub: [https://github.com/gyttja/qhn.gyttja.com](https://github.com/gyttja/qhn.gyttja.com).

Enjoy the silence!
