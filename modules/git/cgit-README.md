Welcome to MY git server! Here you can peruse my various programming (and other)
projects in style!

There's also a couple mirrors I host as well.

Note that in the about sections for each repo, images and relative links are
borked. This is because they are meant for GitHub, sorry in advance!

## Cloning

In the usual open source fashion, you are, of course, able to clone the
repositories listed here and do as you wish with them in accordance with their
licenses.

However, since they are made available over Tor and I2P instead of the Clearnet,
cloning them isn't as simple as running `git clone <URL>`.

If you're on I2P, you can use this command as a base for cloning each repo. This
assumes the HTTP proxy of your router is available via localhost on the default
port, 4444; modify for your setup.

```
git -c http.proxy=http://127.0.0.1:4444 clone <URL>
```

If you're on Tor, you can use this command as a base for cloning each repo. This
assumes the Tor client daemon is available via localhost port 9050; modify for
your setup.

```
git -c http.proxy=socks5h://127.0.0.1:9050 clone <URL>
```

If you would prefer the Clearnet, please visit my GitHub instead:

```
https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi
```

If the clone fails half-way-through (looking at you nixpkgs,) tack `--depth 1`
onto the git clone command. This will perform a shallow clone that just grabs
the state of the most recent commit, which will be more reliable due to having
less to clone. Blame HTTP.
