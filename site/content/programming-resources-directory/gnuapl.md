+++
title               = 'GNU APL Resources'
scrollingTitleCount = 3
+++

## GNU APL - [https://www.gnu.org/software/apl *(November 15, 2024)*](https://www.gnu.org/software/apl)

APL is a pretty old language, so there's a number of different implementations
from different vendors with different extensions available. I recommend not
wasting your time with the proprietary implementations and just use GNU APL.

There's not a whole lot of easy help information on APL, like video tutorials
and Q/A on various webforms, so you'll just have to tough through the
documentation.

I've written a couple applications in GNU APL; feel free to use them as
reference:

- cowsAyPL, cowsay clone - [/cgit/cowsAyPL.git/about](/cgit/cowsAyPL.git/about)

## GNU APL Intro - [https://www.gnu.org/software/apl/apl-intro.html *(November 15, 2024)*](https://www.gnu.org/software/apl/apl-intro.html)

This intro page is less about GNU APL and more about APL in general. It will
walk you through how APL works step-by-step, so it should be enough for you to
get the hang of things.

This site hosts an *almost-verbatim* copy of this part of the GNU APL version
1.9 documentation at
[/programming-resources-directory/gnuapl/intro](/programming-resources-directory/gnuapl/intro/).

## GNU APL Special Features- [https://www.gnu.org/software/apl/apl.html *(November 15, 2024)*](https://www.gnu.org/software/apl/apl.html)

This page gets into the GNU APL-specfic features, so don't expect anything from
here to work with other APL implemenetations.

This site hosts an *almost-verbatim* copy of this part of the GNU APL version
1.9 documentation at
[/programming-resources-directory/gnuapl/special-features](/programming-resources-directory/gnuapl/special-features/).

## GNU APL Library Guidelines - [https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html *(November 15, 2024)*](https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html)

Some tips about how to write libraries for GNU APL, and also APL in general.

## fio.apl - [/cgit/fio.apl.git/about](/cgit/fio.apl.git/about/)

The ⎕FIO system function is used to interact with the operating system. However,
in my opinion, it is far too low-level for a language like APL. I created the
fio.apl library to provide a much better interface. If you find ⎕FIO is a pain
in the ass, please take a look at this.

## aplwiz - [/cgit/aplwiz.git/about](/cgit/aplwiz.git/about/)

A collection of automated testing script templates I've made to add unit testing
and similar to your GNU APL projects.

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

## *almost-verbatim?*

By almost-verbatim, I mean that I have not modified the content of the
documentation, but just the source. It is minified to work better over a slow
connection, and the relative links to CSS and images, local resources, have been
modified to work on my website.
