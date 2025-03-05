+++
title               = 'Haskell Resources'
scrollingTitleCount = 3
+++

## Haskell

- Homepage (Clearnet) [https://www.haskell.org *(March 4, 2025)*](https://www.haskell.org/)

*Warning(s): makes 3rd-party requests.*

## Hoogle

- Clearnet - [https://hoogle.haskell.org *(March 4, 2025)*](https://hoogle.haskell.org/)

Hoogle is *THE GOAT* when it comes to Haskell. It is a search engine that can
find functions matching a paticular name or function signature. One very common
problem in Haskell is how to get from type A to type B, so it is a god-tier
resource.

You can also install it for offline use
[https://github.com/ndmitchell/hoogle/blob/master/docs/Install.md *(March 4, 2025)*](https://github.com/ndmitchell/hoogle/blob/master/docs/Install.md)!

And, if you're a NixOS user, you may find the following module enlightening:

```nix
{ ... }:

let port = <port number goes here>;
in
{
  services.hoogle = {
    enable = true;
    inherit port;
    home = "http://127.0.0.1:${builtins.toString port}";

    # Any Haskell packages you put here will add their documentation to Hoogle's
    # search index.
    packages = hpkgs: with hpkgs; [];

    # Allows access to local files so you can view source code. If this is set,
    # don't allow access from the internet!
    extraOptions = [ "--local" ];
  };

  # systemd service settings to restrict connections to localhost just in case.
  systemd.services.hoogle.serviceConfig = {
    IPAddressDeny  = "any";
    IPAddressAllow = [ "localhost" ];
  };
};
```

## HLint

- Clearnet - [https://github.com/ndmitchell/hlint *(March 4, 2025)*](https://github.com/ndmitchell/hlint)

HLint is a program that lints your Haskell code. It looks for improvements and
simplifications that you could do.

The main benefit of HLint, in my opinion, is that it will help teach Haskell,
but you will need to exercise some critical thinking in reading it's output.
