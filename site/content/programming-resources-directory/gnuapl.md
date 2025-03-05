+++
title               = 'GNU APL Resources'
scrollingTitleCount = 3
+++

## GNU APL

- Homepage (Clearnet) - [https://www.gnu.org/software/apl *(March 4, 2025)*](https://www.gnu.org/software/apl)

APL is a pretty old language, so there's a number of different implementations
from different vendors with different extensions available. I recommend not
wasting your time with the proprietary implementations and just use GNU APL.

There's not a whole lot of easy help information on APL, like video tutorials
and Q/A on various webforms, so you'll just have to tough through the
documentation. You can find quite in a bit in the source after cloning it under
**doc/** and **HOWTOs/**.

I've written application(s) in GNU APL; feel free to use them as reference:

> Name - cowsAyPL.{{< br >}}
> Description - Cowsay in GNU APL.{{< br >}}
> Link - [/cgit/cowsAyPL.git/about](/cgit/cowsAyPL.git/about/)

## GNU APL Intro

- Clearnet - [https://www.gnu.org/software/apl/apl-intro.html *(March 4, 2025)*](https://www.gnu.org/software/apl/apl-intro.html)
- Here (GNU APL 1.9) - [/programming-resources-directory/gnuapl/intro](/programming-resources-directory/gnuapl/intro/)
- License - GNU Free Documentation License.

This intro page is less about GNU APL and more about APL in general. It will
walk you through how APL works step-by-step, so it should be enough for you to
get the hang of things.

## GNU APL Manual

- Clearnet - [https://www.gnu.org/software/apl/apl.html *(March 4, 2025)*](https://www.gnu.org/software/apl/apl.html)
- Here (GNU APL 1.9) - [/programming-resources-directory/gnuapl/special-features](/programming-resources-directory/gnuapl/special-features/)
- License - GNU Free Documentation License.

This page gets into the GNU APL-specfic features, so don't expect anything from
here to work with other APL implemenetations.

## GNU APL Library Guidelines

- Clearnet - [https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html *(March 4, 2025)*](https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html)

Some tips about how to write libraries for GNU APL, and also APL in general.

## fio.apl

- Here - [/cgit/fio.apl.git/about](/cgit/fio.apl.git/about/)

The ⎕FIO system function is used to interact with the operating system. However,
in my opinion, it is far too low-level for a language like APL. I created the
fio.apl library to provide a much better interface. If you find ⎕FIO is a pain
in the ass, please take a look at this.

## aplwiz

- Here - [/cgit/aplwiz.git/about](/cgit/aplwiz.git/about/)

A collection of automated testing script templates I've made to add unit testing
and similar to your GNU APL projects.

## gnu-apl-mode

- Clearnet - [https://github.com/lokedhs/gnu-apl-mode *(March 4, 2025)*](https://github.com/lokedhs/gnu-apl-mode)

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
