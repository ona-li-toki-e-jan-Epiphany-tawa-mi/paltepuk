+++
title               = 'Nix and NixOS Resources'
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

Nix often installs documentation along with it's packages. You can easily copy
the files out of the package for offline viewing, or symlink them to a
predictable location if you're on NixOS.

First, you'll want to make sure to install the package with the language of
choice. For this example, I'll be using **pkgs.lua** for Lua.

Once it's installed and available in your profile use **nix path-info -r
/run/current-system | grep \<name\>** to locate packages related to the
language:

```sh
$ nix path-info -r /run/current-system | grep lua
/nix/store/hhim69blnh8ws0pglw8r17w3g4f6xm2c-lua-5.2.4
/nix/store/kcvj18010ssgb3n0m3lf35dqfn43y0aq-lua-5.4.7
/nix/store/hm52g3a64jlyzd64320cl06x9bl9ipyb-lua-5.2.4-doc
/nix/store/h1683by56j6r6ragif398av8f44m76q7-luajit-2.1.1713773202
/nix/store/vvn3qnq88lnavldgn7bkhkvlnincs4a4-lua5.2-luasocket-3.1.0-1
/nix/store/dciknj5zii9fk0rdkmy2kwcmwlqlqfnh-lua-5.2.4-env
/nix/store/d8w9glrqd619y04sdzd4ar8g431cgfbp-emacs-lua-mode-20231023.947
/nix/store/gchhmwrl379fjagqah6xwia0bznank8a-lua-language-server-3.13.0
/nix/store/lgfq2lxzv3c7kxnmkskvsp2kdcxgzrra-lua-5.2.4
/nix/store/ikfjm5yqq7a81ry6skidbksqwyv0zdqs-luarocks_bootstrap-3.11.1
/nix/store/qjnawi8a9wvv5l7f3yvviajgfzl4xa9a-wrap-lua-hook
/nix/store/rbaywyq25pl013mdrq7db1vg1a28kvx2-lua5.2-luafilesystem-1.8.0-1
/nix/store/vdykmgyjw1pc9dimg4yzlr7mdzmjm3dc-lua5.2-argparse-0.7.1-1
/nix/store/qb721wbh9c50al9h3nhhflcwz1nbzh0z-luacheck-luarocks-config.lua
/nix/store/vmf437xva82dfn7hv4ydc5mc4wsg5dcs-lua5.2-luacheck-1.2.0-1
```

You want to look for the derivation with the schema **\<name\>-\<version\>-doc**
(i.e: **/nix/store/hm52g3a64jlyzd64320cl06x9bl9ipyb-lua-5.2.4-doc**.) If it's
not there, try looking in the main derivation for the language under
**\<derivation\>/share/** for a directory named **doc**. Keep in mind that it
might not exist for that package.

Though, of course, the exact derivation with the documentation will change if
the package is updated, and thus the path. You can just copy out the files to
somewhere outside of the Nix store to keep them. Alternatively, in NixOS, you
can abuse **environment.etc**'s symlink functionality to give a consistent path
to the current documentation, where ever it happens to be in the Nix store:

```nix
{ pkgs, ... }:

{
  environment.etc."documentation/Lua" = {
    # You may need to change this path depending on the package, as it can vary.
    source = "${pkgs.lua.doc}/share/doc/${pkgs.lua.name}";
  };
}
```

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
