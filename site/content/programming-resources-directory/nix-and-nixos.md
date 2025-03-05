+++
title               = 'Nix and NixOS Resource'
scrollingTitleCount = 2
+++

## Nix/NixOS

- Homepage (Clearnet) - [https://nixos.org *(March 4, 2025)*](https://nixos.org)

## man configuration.nix

Rather than using some JavaScript-infested soysite to search for NixOS options,
just run **"man configuration.nix"**! NixOS machines install a man page for all the
options declared in the NixOS modules from nixpkgs.

## `nix search nixpkgs --offline <package>`

Rather than using some JavaScript-infested soysite to search for Nix packages,
just run **"nix search nixpkgs --offline \<package\>"**! This will search
through the packages from the environment-available channel just like **"apt
search \<package\>"** or **"xbps-query -Rs \<package\>"**.

**--offline** specifies for Nix to use a local package index rather than call
out to the internet. Consider making a command alias.

## `nixos-help`

NixOS machines install the NixOS manual locally, just run **"nixos-help"**!

## Offline Documentation with Nix(OS)

- Here - [/blog/offline-documentation-with-nix-os](/blog/offline-documentation-with-nix-os/)

A blog post I made about how you can get offline documentation for programming
languages and other things through Nix(OS).

## Nix Manual

- Clearnet - [https://nix.dev/manual/nix *(March 4, 2025)*](https://nixos.org/manual/nix)

Reference manuals for Nix and the Nix language. It's a good reference for the
builtin.\* functions.

## nixpkgs Manual

- Clearnet - [https://ryantm.github.io/nixpkgs *(March 4, 2025)*](https://ryantm.github.io/nixpkgs/)

A reference for a number of things in nixpkgs, like the functions in lib.\*, and
pkgs.\* stuff like builders, fetchers, etc..

## NixOS Manual

- Clearnet - [https://nlewo.github.io/nixos-manual-sphinx/index.html *(March 4, 2025)*](https://nlewo.github.io/nixos-manual-sphinx/index.html)

A reference for various things in NixOS. Most of it is a copy of the
locally-installed NixOS manual, but the "Development" page is of paticular use,
as it has information on a lot of juicy stuff like defining custom options,
option types, etc..

## NixOS Wiki

- Clearnet - [https://nixos.wiki *(March 4, 2025)*](https://nixos.wiki/)

Contains a lot of useful information on how to do various things in NixOS.

## Arch Wiki

- Clearnet - [https://wiki.archlinux.org/title/Main_page *(March 4, 2025)*](https://wiki.archlinux.org/title/Main_page)

The almighty Arch Wiki is a indespensible resource for Linux, irregardless of
which distribution you happen to be using.

## nixos-hardware

- Clearnet - [https://github.com/NixOS/nixos-hardware *(March 4, 2025)*](https://github.com/NixOS/nixos-hardware)

Repository of hardware-specific NixOS configurations to optimize/bug fix NixOS
for specfic hardware configurations.

You could include it as a dependency in your NixOS configurations if you want,
but, personally, I prefer to avoid extra depedencies, even if they are
reproducable, so I just copy the relevant portions of nixos-hardware into my
configurations.

## nixos-anywhere

- Clearnet - [https://github.com/nix-community/nixos-anywhere *(March 4, 2025)*](https://github.com/nix-community/nixos-anywhere)

The godlike power of installing a NixOS configuration remotely via SSH is
something that cannot be understated. It will take a little time to figure out
disko
[https://github.com/nix-community/disko *(March 4, 2025)*](https://github.com/nix-community/disko),
which it uses a dependency, but once you do, installing NixOS and a
configuration on new machines becomes a breeze.
