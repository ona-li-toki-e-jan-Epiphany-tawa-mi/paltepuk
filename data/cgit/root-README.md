# jan Epiphany's Public Git Server

Welcome to MY git server! Here you can peruse my various programming (and other)
projects in style!

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
assumes the Tor client daemon is available via localhost on the default "slow"
SOCKS port, 9050; modify for your setup.

```
git -c http.proxy=socks5h://127.0.0.1:9050 clone <URL>
```

If you would prefer the Clearnet, please visit my GitHub instead:

```
https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi
```

## Contact

Want to get in contact with me? Here's a few methods:

- Briar

Do you have [(CLEARNET) Briar?](https://code.briarproject.org/briar "Briar GitLab instance")
Add me with my address:

```
briar://aafr55yjjtk65vqtmmxk6bloewweabxzi6lfkjnv7mlscekwf46uk
```

Note that you will have to send me your Briar address through a different
contact method as well before we can message each other.

- Email

You can send me email over the Clearnet at the following address:

```
ona-li-toki-e-jan-Epiphany-tawa-mi@protonmail.com
```

Please use my PGP key to encrypt your mail (and make sure to send me yours!):

```
-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEZcPZ3xYJKwYBBAHaRw8BAQdAlPVXJAb+CcTMMF5hosIEtBa6fYTWUcNA
v7zmZfBR1m7NZW9uYS1saS10b2tpLWUtamFuLUVwaXBoYW55LXRhd2EtbWlA
cHJvdG9ubWFpbC5jb20gPG9uYS1saS10b2tpLWUtamFuLUVwaXBoYW55LXRh
d2EtbWlAcHJvdG9ubWFpbC5jb20+wowEEBYKAD4FgmXD2d8ECwkHCAmQwbQh
p/P+Kv0DFQgKBBYAAgECGQECmwMCHgEWIQTf8AA07Ej6cuqKAhLBtCGn8/4q
/QAA8wEA/3Q9hOdlqD5PV6zti0hHRMh691Cal4TAyO4UpmmR/Sf1AQD3EuwE
E61kAq83eqz/079MxTxSTl9gwImc1waC+62/As44BGXD2d8SCisGAQQBl1UB
BQEBB0DouJTY5TLrfqZ0KXP5nv7hQShRezhSlgv2kOeDrOaTGgMBCAfCeAQY
FgoAKgWCZcPZ3wmQwbQhp/P+Kv0CmwwWIQTf8AA07Ej6cuqKAhLBtCGn8/4q
/QAAXHcBAK8q0zNxD+d4xUpLWuZ31IcIIwdgCIYFxvE2NrWz5soZAP44UWm1
0aIqznMVOt2PUZfM5bz1RXL7bgrUuGNeO9C5Bg==
=Wqd7
-----END PGP PUBLIC KEY BLOCK-----
```

## Source

This website, and the NixOS configuration for it's server, is open sourced under
the GNU Affero General Public License version 3 or Later. You can view it here
in the `paltepuk.git` repository, or at the following link on GitHub:

```
https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/paltepuk
```
