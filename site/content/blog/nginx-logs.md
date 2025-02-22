+++
title               = 'nginx Logs'
scrollingTitleCount = 3
date                = '2025-02-22'
+++

Written: February 22, 2025.

---

It's always pretty funny taking a look at the nginx logs for this website. It's
current configuration only logs 404s.

---

I often see bots trying to access WordPress stuff, which makes me very glad I
don't use it:

```javascript
...
request: "GET /wp-info.php HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /wp-includes/bak.php HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /wp-admin/wp-login.php HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-includes/cloud.php HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-content/index.php HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /wp-admin/about.php HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-content/themes/404.php HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-admin/index.php HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-content/themes.php HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-content/dropdown.php HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-includes/404.php HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-content/upgrade/index.php HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /wp-content/cloud.php HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /wp-includes/function.php HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /blog/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /web/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wordpress/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /website/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /news/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /2018/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /2019/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /shop/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp1/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /test/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /media/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp2/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /site/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /cms/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /sito/wp-includes/wlwmanifest.xml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /media/system/js/core.js HTTP/1.1", host: "paltepuk.xyz"
request: "GET /wp-includes/js/jquery/jquery.js HTTP/1.1", host: "paltepuk.xyz"
...
```

There's also a bunch of other requests for PHP files. They're not explicitly
WordPress, but I image they relate.

---

There's also some other frameworks they seem to like targeting:

```javascript
...
request: "GET /config.js HTTP/1.1", host: "paltepuk.xyz"
request: "GET /symfony/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /symfony/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /django/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /django/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /flask/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /flask/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /next/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /next/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /nuxt/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /nuxt/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /react/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /react/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /vue/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /vue/.env HTTP/1.1", host: "paltepuk.xyz"
...
```

---

There's quite a log of attempted credential stealing (in addition to the
previous):

```javascript
...
request: "GET /.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /public/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /public/.env HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /.aws/credentials HTTP/1.1", host: "paltepuk.xyz"
request: "GET /.aws/credentials HTTP/1.1", host: "paltepuk.xyz"
...
request: "GET /.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /.env HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /.env HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /.aws/credentials HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /.aws/credentials HTTP/1.1", host: "paltepuk.xyz"
request: "GET /.aws/credentials HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /.env.example HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /.env.example HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /.env.example HTTP/1.1", host: "paltepuk.xyz"
request: "GET /.env.production HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /.env.production HTTP/1.1", host: "paltepuk.xyz"
request: "GET /.env.production HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /admin/.env HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /admin/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /admin/.env HTTP/1.1", host: "www.paltepuk.xyz"
request: "GET /api/.env HTTP/1.1", upstream: "fastcgi://unix:/run/phpfpm/paltepuk.sock:", host: "www.paltepuk.xyz"
...
request: "GET /aws-secret.yaml HTTP/1.1", host: "paltepuk.xyz"
request: "GET /awstats/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /conf/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /cron/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /www/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /docker/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /docker/app/.env HTTP/1.1", host: "paltepuk.xyz"
request: "GET /env.backup HTTP/1.1", host: "paltepuk.xyz"
...
```

---

These Tor requests... might I be popular???:

```javascript
request: "GET /pgp.txt HTTP/1.1", host: "4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion"
request: "GET /canary.txt HTTP/1.1", host: "4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion"
request: "GET /mirrors.txt HTTP/1.1", host: "4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion"
```

---

I made a mistake in my featured sites page, as this unfortunate onion bro found out. I fixed it though!:

```javascript
request: "GET /featured-sites/www.bentasker.co.uk HTTP/1.1", host: "4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion"
```

---

What's dirty-shade.png supposed to be?!?:

```javascript
request: "GET /dirty-shade.png HTTP/1.1", host: "4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion"
```

---

Apparently binance.com is reffering to my website??? What's going on???:

```javascript
request: "GET /wp-admin/css/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /.well-known/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /sites/default/files/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /admin/controller/extension/extension/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /uploads/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /images/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /files/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
...
request: "GET /wp-admin/css/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /.well-known/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /sites/default/files/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /admin/controller/extension/extension/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /uploads/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /images/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /files/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
...
request: "GET /wp-admin/css/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /.well-known/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /sites/default/files/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /admin/controller/extension/extension/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /uploads/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /images/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /files/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
...
request: "GET /wp-admin/css/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /.well-known/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /sites/default/files/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /admin/controller/extension/extension/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /uploads/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /images/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
request: "GET /files/ HTTP/1.1", host: "paltepuk.xyz", referrer: "binance.com"
```

---

This person thinks too little of me:

```javascript
request: "GET /home HTTP/1.1", host: "paltepuk.xyz"
request: "GET /tmp HTTP/1.1", host: "paltepuk.xyz"
request: "GET /dev HTTP/1.1", host: "paltepuk.xyz"
```

I'm not that foolish! Only a little ;).

---

A lot of bot activity from the Clearnet! Sasuga...

Sorry botnets! My website's simple AF and your sausage fingers are too big to
firmly grasp it.

I have a full copy of the logs (with timestamps and other metadata stripped)
from a couple days ago up till today available for you to read here if you so
please:

[/blog/nginx-logs/logfile.txt](/blog/nginx-logs/logfile.txt)
