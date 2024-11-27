+++
title               = 'APL Has Macros'
scrollingTitleCount = 3
date                = '2024-11-19'
+++

*Written: November 19, 2024.*

## APL Has Macros?

APL is a programmming language, a very old one, that I quite like. Some like to
practice the cognitive dissonance that it stands for Array Programming Language,
but it's actually A Programming Language, lol.

I've recently been working on a complete redo of my library fio.apl, which
provides an abstraction layer to the GNU APL ⎕FIO system function.

> Here: [/cgit/fio.apl.git/about](/cgit/fio.apl.git/about/)
>
> GitHub: [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/fio.apl](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/fio.apl)

The library itself isn't the relavent part here, but rather the unit testing
system I've been adding to verify it's behavior.

The usage of this system looks something like this:

```apl
⍝ Each test function tests an area of functionality.
∇TEST
  ⍝ When assertions fail, they are displayed with their section to make them
  ⍝ easier to find.
  SECTION "1"
  ⍝ Assertions test if the result is valid, and if so, returns 1, resulting in a
  ⍝ jump to LFAIL.
  →(ASSERT 1≡1) ⍴ LFAIL

  →(ASSERT 1 2 3≡⍳3) ⍴ LFAIL

  SECTION "2"
  →(ASSERT 2 3 4≡⊖4 3 2) ⍴ LFAIL

LFAIL:
∇

∇MAIN
  ⍝ RUN sets up some behind the scene stuff and runs the test.
  RUN "TEST"
  ⍝ And REPORT then displays the final report on how the tests performed.
  REPORT
∇
MAIN

⍝ Exits interpreter on completion.
)OFF
```

Having the condition being inside of the assert and jump was annoying; it made
difficult to distinguish the actual test from the assertion boilerplate code.

So, I split them apart using a variable:

```apl
⍝ RESULT here marks it as a function-local variable.
∇TEST; RESULT
  SECTION "1"
  ⍝ Assign condition result to RESULT, and then assert RESULT.
  RESULT←1≡1 ◊ →(ASSERT RESULT) ⍴ LFAIL

  RESULT←1 2 3≡⍳3 ◊ →(ASSERT RESULT) ⍴ LFAIL

  SECTION "2"
  RESULT←2 3 4≡⊖4 3 2 ◊ →(ASSERT RESULT) ⍴ LFAIL

LFAIL:
∇
```

This is better, but you might notice the repitition of **→(ASSERT RESULT) ⍴
LFAIL**, which actually runs the assertion stuff. Unfortunately, this can't be
reduced any further with a function, because the **LFAIL** label only exists
within **TEST**, and would be out-of-scope in a subfunction. Additionally, you'd
still need to pass RESULT to the function as an argument.

So this got me thinking... does APL have macros? Some kind of expression that
could insert a predefined piece of code, like with the C preprocessor, i.e.:

```apl
#define ASSERT_MACRO →(ASSERT RESULT) ⍴ LFAIL

∇TEST; RESULT
  SECTION "1"
  RESULT←1≡1 ◊ ASSERT_MACRO

  RESULT←1 2 3≡⍳3 ◊ ASSERT_MACRO

  SECTION "2"
  RESULT←2 3 4≡⊖4 3 2 ◊ ASSERT_MACRO

LFAIL:
∇
```

And then, I had an... *epiphany.* I could use **⍎**. **⍎** is quite the devilish APL
function, which takes in a character vector (cvector, string) and evaluates it
**as APL code!**

So, I could have the macro as a cvector, and just execute it with the power of
**⍎**, and since it's executed in-function, it should have access to the
function-local label **LFAIL**. I.e.:

```apl
ASSERT_MACRO←"→(ASSERT RESULT) ⍴ LFAIL"

∇TEST; RESULT
  SECTION "1"
  RESULT←1≡1 ◊ ⍎ASSERT_MACRO

  RESULT←1 2 3≡⍳3 ◊ ⍎ASSERT_MACRO

  SECTION "2"
  RESULT←2 3 4≡⊖4 3 2 ◊ ⍎ASSERT_MACRO

LFAIL:
∇
```

And it works! Huzzah!

*GOTO considered harmful )))*
