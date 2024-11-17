+++
title               = 'GnuAPL Resources'
scrollingTitleCount = 3
+++

## GnuAPL - [https://www.gnu.org/software/apl *(November 15, 2024)*](https://www.gnu.org/software/apl)

APL is a pretty old language, so there's a number of different implementations
from different vendors with different extensions available. I recommend not
wasting your time with the proprietary implementations and just use GnuAPL.

There's not a whole lot of easy help information on APL, like video tutorials
and Q/A on various webforms, so you'll just have to tough through the
documentation.

I've written a couple applications in GnuAPL; feel free to use them as
reference:

- AHD, hexdump utility - [/cgit/AHD.git/about](/cgit/AHD.git/about) | [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/AHD](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/AHD)

- cowsAyPL, cowsay clone - [/cgit/cowsAyPL.git/about](/cgit/cowsAyPL.git/about) | [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/cowsAyPL](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/cowsAyPL)

## GnuAPL Intro - [https://www.gnu.org/software/apl/apl-intro.html *(November 15, 2024)*](https://www.gnu.org/software/apl/apl-intro.html)

This intro page is less about GnuAPL and more about APL in general. It will walk
you through how APL works step-by-step, so it should be enough for you to get
the hang of things.

## GnuAPL Special Features- [https://www.gnu.org/software/apl/apl.html *(November 15, 2024)*](https://www.gnu.org/software/apl/apl.html)

This page gets into the GnuAPL-specfic features, so don't expect anything from
here to work with other APL implemenetations.

## GnuAPL Library Guidelines - [https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html *(November 15, 2024)*](https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html)

Some tips about how to write libraries for GnuAPL, and also APL in general.

## gnu-apl-mode - [https://github.com/lokedhs/gnu-apl-mode *(November 15, 2024)*](https://github.com/lokedhs/gnu-apl-mode)

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