Welcome to MY git server! Here you can peruse my various programming (and other)
projects in style!

Note that in the about sections for each repo, images and relative links are
borked. This is because they are meant for GitHub (and don't work in cgit,)
sorry in advance!

## Cloning (with git)

In the usual open source fashion, you are, of course, able to clone the
repositories listed here and do as you wish with them in accordance with their
licenses.

However, if you're on Tor or I2P instead of the Clearnet, cloning them isn't as
simple as running `git clone <URL>`.

If the clone fails half-way-through, tack `--depth 1` onto the git clone
command. This will perform a shallow clone that just grabs the state of the most
recent commit, which will be more reliable due to having less to clone. Blame
HTTP.

### Clearnet

You can use git clone as usual. Or, if you'd prefer, you can visit my GitHub
account instead:

```
https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi
```

### I2P

You can use this command as a base for cloning each repo. This assumes the HTTP
proxy of your router is available via localhost port 4444; modify for your
setup.

```
git -c http.proxy=http://127.0.0.1:4444 clone http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/cgit/<repository>
```

### Tor

You can use this command as a base for cloning each repo. This assumes the Tor
client daemon's SOCKSv5 proxy is available via localhost port 9050; modify for
your setup.

```
git -c http.proxy=socks5h://127.0.0.1:9050 clone http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/cgit/<repository>
```
