Welcome to MY git server! Here you can peruse my various programming (and other)
projects in style!

There's also a couple mirrors I host as well.

Note that in the about sections for each repo, images and relative links are
borked. This is because they are meant for GitHub (and don't work in cgit,)
sorry in advance!

## Cloning (with git)

In the usual open source fashion, you are, of course, able to clone the
repositories listed here and do as you wish with them in accordance with their
licenses.

However, since they are made available over Tor and I2P instead of the Clearnet,
cloning them isn't as simple as running `git clone <URL>`.

If the clone fails half-way-through (looking at you nixpkgs,) tack `--depth 1`
onto the git clone command. This will perform a shallow clone that just grabs
the state of the most recent commit, which will be more reliable due to having
less to clone. Blame HTTP.

### I2P

If you're on I2P, you can use this command as a base for cloning each repo. This
assumes the HTTP proxy of your router is available via localhost port 4444;
modify for your setup.

```
git -c http.proxy=http://127.0.0.1:4444 clone http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/cgit/<repository>
```

### Tor

If you're on Tor, you can use this command as a base for cloning each repo. This
assumes the Tor client daemon's SOCKSv5 proxy is available via localhost port
9050; modify for your setup.

```
git -c http.proxy=socks5h://127.0.0.1:9050 clone http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/cgit/<repository>
```

### Clearnet

If you would prefer the Clearnet, please visit my GitHub instead:

```
https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi
```

## Mirroring (with rsync)

Rsync is set up so you can mirror the repositories with rsync (you could use git
as well, but I wanted something to easily mirror all repositories all at once.)

To mirror a paticular repository, just append a repository name to the rsync
URL.

Rsync options used:

- `-r` - recursive. Recurses through directories and syncs their contents.
- `-u` - update. Skips files that don't need to be synced (if you've synced before.)
- `-P` - partial and progress. Shows progress, and does partial file copies so it can resume if it failed.
- `--del` - delete during. Deletes files present in the destination that are not present in the remote directory. Careful!

### I2P

If you're on I2P, you can use this command to mirror all repos. This assumes the
HTTP proxy of your router is available via localhost on the default port, 4444;
modify for your setup.

```
RSYNC_PROXY=127.0.0.1:4444 rsync -ruP --del rsync://qr7jxluq5g3nn5tvf7jmiz5rhm7eimc7vlcmzcjhrtynusymjibq.b32.i2p/git/<destination path>
```
