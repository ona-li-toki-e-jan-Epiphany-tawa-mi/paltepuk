+++
title               = 'Offline Documentation with Nix(OS)'
scrollingTitleCount = 1
date                = '2025-03-03'
+++

Written: March 3, 2025.

---

Did you know that Nix installs local documentation for programming languages
(and probably some other stuff?) It might be enabled by
**documentation.dev.enable = true** in NixOS, or it might be that it's apart of
Nix by default; I'm not sure.

What I'm referring to isn't man pages, but HTML documents for documentation
websites like:

- [https://www.lua.org/manual/5.4 *(March 3, 2025)*](https://www.lua.org/manual/5.4/)
- [https://docs.python.org/3 *(March 3, 2025)*](https://docs.python.org/3/)
- [https://ziglang.org/documentation/master *(March 3, 2025)*](https://ziglang.org/documentation/master/)

Wouldn't it be nice to have these websites stored on your local machine?

First, you'll want to make sure to install the package with the language of
choice. For this example, I'll be using **pkgs.lua** for Lua.

Once it's installed and available in your profile (as-in it's in your PATH,) use
**nix path-info -r /run/current-system | grep \<name\>** to locate packages
related to the language:

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

Do you notice **/nix/store/hm52g3a64jlyzd64320cl06x9bl9ipyb-lua-5.2.4-doc**? You
want to look for the derivation with the schema **\<name\>-\<version\>-doc**. If
it's not there, try looking in the main derivation for the language under
**\<derivation\>/share/** for a directory named **doc**. Keep in mind that it
might not exist for that package.

Go into that derivation/directory and look at the files inside. For Lua in this example:

```sh
l /nix/store/hm52g3a64jlyzd64320cl06x9bl9ipyb-lua-5.2.4-doc/share/doc/lua-5.2.4/
total 368K
dr-xr-xr-x 1 root root  166 Dec 31  1969 .
dr-xr-xr-x 1 root root   18 Dec 31  1969 ..
-r--r--r-- 2 root root  29K Dec 31  1969 contents.html
-r--r--r-- 2 root root 4.2K Dec 31  1969 logo.gif
-r--r--r-- 2 root root 1.6K Dec 31  1969 lua.css
-r--r--r-- 2 root root  414 Dec 31  1969 manual.css
-r--r--r-- 2 root root 300K Dec 31  1969 manual.html
-r--r--r-- 2 root root 3.7K Dec 31  1969 osi-certified-72x60.png
-r--r--r-- 2 root root  13K Dec 31  1969 readme.html
```

Jackpot! Lets open up **contents.html** in a web browser:

![Screenshot of the Lua Reference Manual](/blog/offline-documentation-with-nix-os/lua-reference-manual.webp)

Nice!

Now, granted, this doesn't mean much in Lua's case, since there is an easy download:
[https://www.lua.org/ftp/#manuals *(March 3, 2025)*](https://www.lua.org/ftp/#manuals),
but what about Zig? I cringe every time I connect to the internet just to look
at some documentation, so this is nice.

Though, of course, the exact derivation with the documentation is will change if
the package is updated, and thus the path. To solve this, in NixOS anyways,
we'll be abusing **environment.etc**.

The purpose of **environment.etc** is to provide configuration to various
programs, but we'll abuse its symlink functionality to give a consistent path to
the current documentation, where ever it happens to be in the Nix store:

```nix
{ pkgs
, ...
}:

{
  environment.etc."documentation/Lua" = {
    # You may need to change this path depending on the package, as it can vary.
    target = "${pkgs.lua.doc}/share/doc/${pkgs.lua.name}";
  };
}
```
