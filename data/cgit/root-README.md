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
assumes the Tor client daemon is available via localhost port 9050; modify for
your setup.

```
git -c http.proxy=socks5h://127.0.0.1:9050 clone <URL>
```

If you would prefer the Clearnet, please visit my GitHub instead:

```
https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi
```

## Links

This git server:

- I2P: http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p
- Tor: http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion

netcatchat server (COMPLETELY UNMODERATED): 6ay2f2mmkogzz6mwcaxjttxl4jydnskavfaxgumeptwhhdjum3i6n3id.onion port 2000

Third party platforms:

- GitHub: https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi
- PyPI: https://pypi.org/user/ona_li_toki_e_jan_Epiphany_tawa_mi
- npm: https://www.npmjs.com/~ona-li-toki-e-jan-epiphany-tawa-mi
- Thingiverse: https://www.thingiverse.com/jan_epiphany/designs
- Odysee: https://odysee.com/@ona-li-toki-e-jan-Epiphany-tawa-mi:9408ca3670bd0ebb99addf196f1f9a72450bdcb1

For information on what in tarnation a "netcatchat server" is, take a look at
the `netcatchat.git` repository on this site.

## Contact

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
