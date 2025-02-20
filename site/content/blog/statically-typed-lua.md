+++
title               = 'Statically Typed Lua'
scrollingTitleCount = 2
date                = '2024-12-30'
+++

Written: December 30, 2024.

---

## Context

I was recently working on finishing up a Luanti
[https://www.luanti.org *(December 30, 2024)*](https://www.luanti.org/)
modpack that I was procrastinating on.

It's called gigatools [/cgit/gigatools.git/about](/cgit/gigatools.git/about/),
and it adds and API for tools, and some actual tools, that can dig nodes in
large areas defined by lines, planes, and cuboids. I wanted something like the
big tools you can make from the tool forge in Tinker's Construct
[https://github.com/SlimeKnights/TinkersConstruct *(December 30, 2024)*](https://github.com/SlimeKnights/TinkersConstruct).

## Dynamic Types: The Original Sin

Dynamic typing and it's consequences have been a disaster for the human race. It
is nice and convienient when you're quickly hacking together a prototype, or a
script to automate some random task, but when you try to scale it up to powering
libraries and applications, its flaws become painfully obvious.

For one, you may not be 100% certain that all given functions/code paths are
getting and/or returning the types you expect. You can quite easily miss bugs
and possibly have to rollback changes or roll out patches for silly little type
errors that would have been rendered impossible with a proper static typing
system.

Secondly, a proper compiler/validator helps immensly when it comes to
refactoring. Say I want to rename something, or split a thing into multiple
different types, or some other thing, I can just shove the build command in
Emacs' compilation buffer for some good ol' compiler assisted refactoring. The
build tooling tells me where things break, and then Emacs parses that output and
creates a link to that location. Press enter on the link -> fix the issue ->
rerun command; rip and tear until it is done.

Doing such refactoring *is* possible in dynamically typed languages, but I can't
be 100% sure that it takes me to all code paths where things break, because I
might never run them.

These issues can be compensated for with unit testing, but who wants to write a
bunch of extra unit tests just to compensate for a lack of static typing?
Doesn't that just defeat the point?

## Lua and Types

Lua is the langauge used for writing mods, modpacks and games for Luanti. It's a
decent choice, since it's easy to embed, and is pretty fast with the help of
LuaJIT [https://luajit.org *(December 30, 2024)*](https://luajit.org/), but it
has the cancer of runtime types.

One way to compensate for this is to use a statically typed language that
compiles to Lua, like Teal
[https://github.com/teal-language/tl *(December 30, 2024)*](https://github.com/teal-language/tl).

But, this introduces the need of an extra system to build and run your
project. It's probably a good idea anyways, but I wanted to try and find
something that wouldn't complicate things too much.

You could also use lua-language-server
[https://github.com/LuaLS/lua-language-server *(December 30, 2024)*](https://github.com/LuaLS/lua-language-server),
which can do type-checking based on annotations provided in code comments
[https://luals.github.io/wiki/annotations *(December 30, 2024)*](https://luals.github.io/wiki/annotations/).
The only problem is this requires an LSP client, which I don't have set up in
Emacs, and can't be used in CI.

Or can it? Turns out lua-language-server has a **--check** flag you can pass via
CLI to have it syntax and typecheck a given file or project without needing an
LSP client, and it will just output a report in JSON to the path you specify
with **--logpath**.

So I just wrote a little Lua script that runs lua-language-server with
**--check**, parses the report (with the help of the single-file JSON library
json.lua
[https://github.com/rxi/json.lua *(December 30, 2024)*](https://github.com/rxi/json.lua),)
and then outputs the issues, and a non-0 exit code, if there were any.

Pretty cool right? And people don't need lua-language-server to build and run
the project (and it doesn't even need to be built.) It's only needed for
development.

You can find the code for the testing script in the **.tools/** directory in the
gigatools repository linked above.
