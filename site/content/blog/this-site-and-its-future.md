+++
title               = 'This Site and Its Future'
scrollingTitleCount = 2
date                = '2024-11-14'
+++

*Written: November 14, 2024.*

This blog post, being my very first blog post to this blog that I made so I
could blog - which makes me a blogger - details the progression of my website
from it's inception to the current day.

## First Iteration

*Made around May, 2024.*

When I first made this site, it was just a cgit
[https://git.zx2c4.com/cgit/about *(November 14, 2024)*](https://git.zx2c4.com/cgit/about/)
instance that I had thrown on Tor and I2P, running it off a measly Raspberry Pi
3B+.

I soon added Hydra
[https://wiki.nixos.org/wiki/Hydra *(November 14, 2024)*](https://wiki.nixos.org/wiki/Hydra/)
\- a CI system that integrated with Nix and NixOS. I set it up to automatically
test my software, because why not. This ended up requiring some more power, so I
used a Raspberry Pi 400 I had irresponsibly bought because I love keyboard
computers. Although, I kept getting into *altercations* with Hydra, and decided
to file for divorce. But, more importantly, with the addition of two web
services, I needed a homepage!

So, I raw-dogged some HTML together to set up a basic homepage, and it looked
something like this:

![Image of original homepage](/blog/this-site-and-its-future/first-iteration-homepage.webp)

Transcendentally beautiful, how the internet should be.

## Second Iteration

*Made around July, 2024.*

Eventually, however, I decided I wanted something a little... mmm... *better.*

So I looked for some options, and decided upon the static site generator Hugo
[https://gohugo.io *(November 14, 2024)*](https://gohugo.io/).
I found a cool theme called Lugo, standing for Luke's Hugo Theme
[https://github.com/LukeSmithxyz/lugo *(November 14, 2024)*](https://github.com/LukeSmithxyz/lugo/),
I modified it a bit and used it to whip up a new site, and even added some
extra pages, fancy! It looked something like this:

![Image of second iteration's homepage](/blog/this-site-and-its-future/second-iteration-homepage.webp)

Muuuuuuch better, and look at those web buttons! Who doesn't like web buttons?
Heathens, that's who.

## Third Iteration *(current iteration, as of November 14, 2024)*

*Made around October-November, 2024.*

Eventually, however, I decided I wanted something a little... mmm... *better.*

Specifically, I wanted something more personalized. Lugo was pretty nice, but a
personal website is a reflection of the self, and Lugo... Lugo wasn't reflecting
me.

I deleted the files from Lugo and started fresh. I came up with the idea to make
it look like a CRT. I first tried giving a border around the site to look like
the edges of a screen, but failed miserably.

With my internet sleuthing, I eventually stumbled across this awesome article on
using CSS to create CRT-like effects:
[https://aleclownes.com/2017/02/01/crt-display.html *(November 14, 2024)*](https://aleclownes.com/2017/02/01/crt-display.html)

It looked awesome, absolutely awesome, but two of the three effects had to do an
animation across the whole viewport, redrawing the entire website every frame,
which meant ***BIIIIIIG*** CPU usage. It was like someone remotely installed a
crypto miner on your system. So, with great sadness, I had to remove it -
becoming a soydev is a line I just can't cross.

However, the "screen-door" effect, which creates scanlines and bigger pixels,
wasn't an animation, and was very performant, so I kept it.

I then had the idea to move the header to the left and the body to the right,
but felt bothered by the space in-between them. I wanted some kind of
divider. At some point, I had a **divine intellect** and decided to make the
title of the page continuously scroll as a marquee to act as the divider. It was
at this moment that my keyboard set itself aflame - I was writing a really,
really baller website.

I came up with color scheme shortly after - lots, and lots, and lots of
green. So much so that the God of Green would be seething in jealousy (Mitsuba
no Monogatari.)

I decided that the website should look and feel like a terminal, and that the
webpages should look like someone using the command line. The singles, what Hugo
calls the main content pages, simply "use" cat to display their content, but I
came up with this monster of a command to "do" the listing of directories:

```sh
# I put the command on multiple lines to make it more readable.

first='true'
for file in *; do
    [ 'true' != "$first" ] && echo
    echo "$file:"
    head -c 100 "$file" | awk '{print "    "$0}'
    first='false';
done
```

Hail shell script!

I added a CSS animation to do a blinking cursor at the end of the pages, like a
terminal waiting for input. Here's the code if you're interested:

```css
.blink {
    animation: blink 1s infinite;
}
@keyframes blink {
    0% {
        opacity:                   1;
        animation-timing-function: steps(1, end);
    }
    50% {
        opacity:                   0;
        animation-timing-function: steps(1, end);
    }
    100% {
        opacity:                   1;
        animation-timing-function: steps(1, end);
    }
}
```

With that, the new site, a-la-me, was born. It looks something like this:

![Image of third iteration's homepage](/blog/this-site-and-its-future/third-iteration-homepage.webp)

After that, I decided to use a Cloudflare tunnel to slap it on the Clearnet, so
that normies could access it. That leaves us where we are today (as of writing
this post.)

## FINAL NOTE

As for the future, I probably won't change the website much from it's current
state.

I may add access from other networks, like, say, Yggdrasil
[https://yggdrasil-network.github.io *(November 14, 2024)*](https://yggdrasil-network.github.io/).

I was thinking of maybe writing a telnet BBS from scratch.

No promises though.

If you'd like a more detailed history, this website and the NixOS configuration
of it's server are fully open-source, and versioned by git. Check out the
following link for more details:

[/site-source-code](/site-source-code/)
