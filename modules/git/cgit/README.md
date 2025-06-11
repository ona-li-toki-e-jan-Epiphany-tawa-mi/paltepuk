Welcome to MY git server! Here you can peruse my various programming (and other)
projects in style!

Note that in the about sections for each repo, images and relative links are
borked. This is because they don't work in cgit (as far as I'm aware,) sorry in
advance!

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

### I2P

You can use this command as a base for cloning each repo. This assumes the HTTP
proxy of your router is available via localhost port 4444; modify for your
setup.

```
git -c http.proxy=http://127.0.0.1:4444 clone <url>
```

### Tor

You can use this command as a base for cloning each repo. This assumes the Tor
client daemon's SOCKSv5 proxy is available via localhost port 9050; modify for
your setup.

```
git -c http.proxy=socks5h://127.0.0.1:9050 clone <url>
```

---

---

---

o kama pona lon lipu mi a pi ilo Git. sina ken lukin e lipu lawa mi (en ijo ante
sama) lon ni!

o kama sona e ni: lon lipu About pi kama sona lon poki pi lipu lawa la sitelen
li lon ala tan ni: ona li pali ala lon ilo Cgit (mi pilin). ike!

## kama jo (kepeken ilo Git)

sina ken kama jo e poki pi lipu lawa li ken kepeken e ona kepeken nasin pi lipu
LICENSE pi nasin kepeken pona.

taso, sina lon linluwi Tor anu linluwi I2P la sina lon ala linluwi Clearnet la
sina ken ala kepeken e nimi lawa `git clone <URL>`.

kama jo li ike li pini ala pali la o pana e `--depth 1` lon pini pi nimi
lawa. ni la ona li kama jo ala e poki ale li kama jo e poki wile taso. ni la ken
la ona li pali pona. ike tan ilo HTTP.

### linluwi I2P

linluwi I2P li kepeken e ilo HTTP lon lon 127.0.0.1:4444 la o kepeken e nimi
lawa ni tawa kama jo. ni ala la sina wile ante e nimi lawa.

```
git -c http.proxy=http://127.0.0.1:4444 clone <tawa URL tawa poki pi lipu lawa>
```

### linluwi Tor

linluwi I2P li kepeken e ilo SOCKSv5 lon lon 127.0.0.1:9050 la o kepeken e nimi
lawa ni tawa kama jo. ni ala la sina wile ante e nimi lawa.

```
git -c http.proxy=socks5h://127.0.0.1:9050 clone <tawa URL tawa poki pi lipu lawa>
```
