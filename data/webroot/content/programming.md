+++
title = 'Programming'
description = 'programming resources'
+++

I'm a big fan of programming as a recreational activity. It teaches a plethora
of skills, sharpens the mind, and is really satisfying when you do something
cool.

Finding documentation, though, can sometimes be a real pain (i.e. with
Nix/NixOS,) so I've compiled a list of resources here that I've found and think
would be good to share.

## Nix/NixOS - [https://nixos.org](https://nixos.org)

- Nix Manual Built-in Functions Reference - [https://nixos.org/manual/nix/stable/language/builtins](https://nixos.org/manual/nix/stable/language/builtins)

A reference for all of the built-in functions, as-in everything builtins.\*.

- nixpkgs Manual - [https://ryantm.github.io/nixpkgs/#preface](https://ryantm.github.io/nixpkgs/#preface)

A reference for a lot of the stuff in lib.* and pkgs.* (not counting actual
packaged software.)

- NixOS Option Types Manual - [https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html](https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html)

A reference for NixOS options and option types for making configurable NixOS
modules.

- `man configuration.nix`

You could use the websites that allow you to search for NixOS options, but it's
all installed locally, assuming you're running NixOS, so don't bother with that
JavaScript-infested garbage.

- `nixos-help`

Assuming you're running NixOS, the NixOS manual is installed locally, just run
`nixos-help`.

- nixos-hardware - [https://github.com/NixOS/nixos-hardware/tree/master](https://github.com/NixOS/nixos-hardware/tree/master)

Repository of hardware-specific NixOS configurations to optimize/bug fix NixOS
for specfic hardware configurations.

You could include it as a dependency in your NixOS configurations if you want,
but, personally, I prefer to avoid extra depedencies, even if they are
reproducable, so I just copy the relevant portions of nixos-hardware into my
configurations.

- nixos-anywhere - [https://github.com/nix-community/nixos-anywhere](https://github.com/nix-community/nixos-anywhere)

The godlike power of installing a NixOS configuration remotely via SSH is
something that cannot be understated. It will take a little time to figure out
disko ([https://github.com/nix-community/disko](https://github.com/nix-community/disko)),
which it uses a dependency, but once you do, installing NixOS and a
configuration on new machines becomes a breeze.

## GnuAPL - [https://www.gnu.org/software/apl](https://www.gnu.org/software/apl)

APL is a pretty old language, so there's a number of different implementations
from different vendors with different extensions available. I recommend not
wasting your time with the proprietary implementations and just use GnuAPL.

There's not a whole lot of easy help information on APL, like video tutorials
and Q/A on various webforms, so you'll just have to tough through the
documentation.

I've written a couple applications in GnuAPL; feel free to use them as
reference:

>> AHD, hexdump utility - [/cgit/AHD.git](/cgit/AHD.git) | [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/AHD](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/AHD)

>> cowsAyPL, cowsay clone - [/cgit/cowsAyPL.git](/cgit/cowsAyPL.git) | [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/cowsAyPL](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/cowsAyPL)

- GnuAPL Intro - [https://www.gnu.org/software/apl/apl-intro.html](https://www.gnu.org/software/apl/apl-intro.html)

This intro page is less about GnuAPL and more about APL in general. It will walk
you through how APL works step-by-step, so it should be enough for you to get
the hang of things.

- GnuAPL Special Features- [https://www.gnu.org/software/apl/apl.html](https://www.gnu.org/software/apl/apl.html)

This page gets into the GnuAPL-specfic features, so don't expect anything from
here to work with other APL implemenetations.

- GnuAPL Library Guidelines - [https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html](https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html)

Some tips about how to write libraries for GnuAPL, and also APL in general.

- gnu-apl-mode - [https://github.com/lokedhs/gnu-apl-mode](https://github.com/lokedhs/gnu-apl-mode)

You'll need some way to type the symbols APL uses. I use this with Emacs, and it
works pretty good. I do recommend adding the following to your configuration to
make it a little nicer to use:

```elisp
;; Makes the indentation more sensible IMO.
(customize-set-variable 'gnu-apl-indent-amounts '(0 2 2 2))

;; By default, it shows a view of the keyboard when gnu-apl-mode starts up,
;; which is really annoying.
(customize-set-variable 'gnu-apl-show-keymap-on-startup nil)

(defun gnu-apl-mode-setup ()
  "Runs various setup functions for gnu-apl-mode."
  ;; electric-indent-mode doesn't seem to know how to handle APL.
  (electric-indent-mode -1)
  ;; Automatically uses APL-Z, which is needed to type APL characters.
  (set-input-method "APL-Z"))
(add-hook 'gnu-apl-mode-hook             #'gnu-apl-mode-setup)
(add-hook 'gnu-apl-interactive-mode-hook #'gnu-apl-mode-setup)
```
