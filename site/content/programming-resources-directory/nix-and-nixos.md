+++
title               = 'Nix and NixOS Resource'
scrollingTitleCount = 2
+++

## Nix/NixOS - [https://nixos.org *(November 15, 2024)*](https://nixos.org)

Nix and NixOS homepage.

## Nix Manual Built-in Functions Reference - [https://nixos.org/manual/nix/stable/language/builtins *(November 15, 2024)*](https://nixos.org/manual/nix/stable/language/builtins)

A reference for all of the built-in functions, as-in everything builtins.\*.

## nixpkgs Manual - [https://ryantm.github.io/nixpkgs/#preface *(November 15, 2024)*](https://ryantm.github.io/nixpkgs/#preface)

A reference for a lot of the stuff in lib.* and pkgs.* (not counting actual
packaged software.)

## NixOS Option Types Manual - [https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html *(November 15, 2024)*](https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html)

A reference for NixOS options and option types for making configurable NixOS
modules.

## man configuration.nix

Rather than using some JavaScript-infested soysite to search for NixOS options,
just run **"man configuration.nix"**! NixOS machines install a man page for all the
options declared in the NixOS modules from nixpkgs.

## `nix search nixpkgs <package>`

Rather than using some JavaScript-infested soysite to search for Nix packages,
just run **"nix search nixpkgs \<package\>"**! This will search through the
packages from the environment-available channel just like **"apt search
\<package\>"** or **"xbps-query -Rs \<package\>"**.

## `nixos-help`

NixOS machines install the NixOS manual locally, just run **"nixos-help"**!

## nixos-hardware - [https://github.com/NixOS/nixos-hardware/tree/master *(November 15, 2024)*](https://github.com/NixOS/nixos-hardware/tree/master)

Repository of hardware-specific NixOS configurations to optimize/bug fix NixOS
for specfic hardware configurations.

You could include it as a dependency in your NixOS configurations if you want,
but, personally, I prefer to avoid extra depedencies, even if they are
reproducable, so I just copy the relevant portions of nixos-hardware into my
configurations.

## nixos-anywhere - [https://github.com/nix-community/nixos-anywhere *(November 15, 2024)*](https://github.com/nix-community/nixos-anywhere)

The godlike power of installing a NixOS configuration remotely via SSH is
something that cannot be understated. It will take a little time to figure out
disko
[https://github.com/nix-community/disko *(November 15, 2024)*](https://github.com/nix-community/disko),
which it uses a dependency, but once you do, installing NixOS and a
configuration on new machines becomes a breeze.
