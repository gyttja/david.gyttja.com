---
author: David
categories:
  - Uncategorized
date: '2022-12-28T11:00:00+01:00'
permalink: /2022/12/28/well-hello-there-cloudflare/
tags:
  - cloudflare
  - dns
title: Well, hello there, Cloudflare!
url: /2022/12/28/well-hello-there-cloudflare/
---

This site has long been self-hosted on a droplet at DigitalOcean with an ancient Wordpress (🫣) installation. I haven't given it much love whatsoever in many years. Time to remedy that!

<!--more-->

I started by testing out Github pages and was quite pleased. Excellent "free" static site hosting, auto TLS certificates, and autodeploy-on-push. All great things! But then I started to migrate another service and realized I needed some dynamic content, thus some sort of cachable (preferably) server-side rendering. I decided to go all-in with Cloudflare Pages, which easily does what Github pages does plus allows for dynamic, server-side content using [Pages Functions](https://developers.cloudflare.com/pages/platform/functions/).


## Cloudflare Pages

I first exported all my content from the Wordpress installation to Hugo-compatible yaml files (using a Jekyll export plugin). Yes, I decided on Hugo as my static-site generator. I also found a nice theme that I have hacked to death: [etch](https://github.com/LukasJoswiak/etch). This site is only static pages, so getting it hosted on Cloudflare Pages was quite simple. Following [their tutorial](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/) took maybe all of 5 minutes.

In addition, I used the following build command:
```bash
hugo --minify --baseURL "$BASE_URL"
```

And configured the following variables, setting the `BASE_URL` based on production vs preview:

| name           | value                      | environment |
| :------------- | :------------------------- | :---------- |
| `BASE_URL`     | `https://david.gyttja.com` | production  |
| `HUGO_VERSION` | `0.106.0`                  | production  |
| `BASE_URL`     | `$CF_PAGES_URL`            | preview     |
| `HUGO_VERSION` | `0.106.0`                  | preview     |



## Cloudflare DNS

In order to get my sites (including the apex domain) hosted on Cloudflare Pages, I needed to move my DNS to Cloudflare as well. I have long wanted to migrate from my DNS provider, DynDNS which was purchased by Oracle a few years ago. So now was the time. Moving to Cloudflare's free DNS was, like Cloudflare Pages, very simple. The only "important" DNS records I have are the `MX` records, everything else can suffer a little downtime if anything is misconfigured. First, I set the TTL in DynDNS down to 5 minutes, added all the corresponding entries to Cloudflare DNS, then waited a day or two for the changes to populate.

Then I went into my registrar and repointed the nameserver entries from DynDNS to Cloudflare's servers. I was a bit taken aback when I saw I hadn't changed my nameserver entries for over 20 years! Well, there's no time like the present for change!

![Nameserver entries from 2000](/images/2022/12/dns.png)

Everything worked out well -- no downtime, sites still worked, and mail still came in!

## What's next

No cookies. No comments. Just content.

So much has happened since I last wrote something here, I have an endless pit of projects that I am working on, it's time I write about them! Stay tuned 🤓
