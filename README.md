# paltepuk

`pal` - building, `tep` - person, `uk` - my.

Paltepuk is my personal website, and also the server that runs it. This
repository contains the website itself and the NixOS configuration for the
server.

This server hosts the following sites/services:

- Personal website:
  - I2P: http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p
  - Tor: http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion
- cgit git server web interface:
  - I2P: http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/cgit
  - Tor: http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/cgit
- Hydra continuous integration server:
  - I2P: http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/hydra
  - Tor: http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/hydra
- netcatchat server (COMPLETELY UNMODERATED): 6ay2f2mmkogzz6mwcaxjttxl4jydnskavfaxgumeptwhhdjum3i6n3id.onion port 2000

For information on what in tarnation a "netcatchat server" is, please visit one of the following links:

- I2P: http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/cgit/netcatchat.git/about
- Tor: http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/cgit/netcatchat.git/about
- Clearnet: https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/netcatchat

---

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

- Add dark mode for cgit.
- Peertube or something else for my videos (maybe tube.)
- Add issue tracker for projects.
- Consider adding access from Lokinet, Freenet, and GNUnet(?).
- If moved to a VPS:
  - Add access from the regular Clearnet and Yggdrasil.
  - See about adding IPFS gateway.
  - Add Tor non-exit relay.
