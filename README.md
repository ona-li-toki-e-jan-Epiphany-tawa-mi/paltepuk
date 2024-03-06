# paltepuk

`pal` - building, `tep` - person, `uk` - my.

Paltepuk is my personal website, and also the server that runs it. This
repository contains the website itself and the NixOS configuration for the
server.

At the moment this only has a git server with a web interface, which you can
view at the following links:

- I2P: http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p
- Tor: http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion

It's only accessible from I2P and Tor for now because it's running on my home
internet; I don't want people reversing my location from the IP address or
DDoS-ing my network.

This could be solved by setting up a reverse proxy on a VPS and pointing it at my
home server, but at that point I may as well shove the entire website on a VPS
and call it a day.

I will eventually move it to a VPS, but setting up a couple hidden services on a
random spare computer is a million times easier and comes with domains, encryption, and
site validation out of the box.

## TODO List

- Put cgit on private network.
- Add dark mode for cgit.
- Peertube or something else for my videos.
- Add custom homepage.
- If moved to a VPS, add access from the regular Clearnet and Yggdrasil.
