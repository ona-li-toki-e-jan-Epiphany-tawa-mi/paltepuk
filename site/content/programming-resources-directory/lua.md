+++
title               = 'Lua Resources'
scrollingTitleCount = 3
+++

## Lua Homepage

- Clearnet - [https://www.lua.org *(March 4, 2025)*](https://www.lua.org)

## Lua Reference Manual

- Clearnet - [https://www.lua.org/manual *(March 4, 2025)*](https://www.lua.org/manual/)
- Here - [/programming-resources-directory/lua/documentation/contents.html](/programming-resources-directory/lua/documentation/contents.html)

## json.lua

- Clearnet - [https://github.com/rxi/json.lua *(December 30, 2024)*](https://github.com/rxi/json.lua)

A single-file JSON serialization and deserialization library that only depends
on the Lua standard libraries.

## Statically Typed Lua

There a number of ways to get static types with Lua. I found that using
lua-language-server works good.

It has a **--check** flag you can pass via CLI to have it syntax and typecheck a
given file or project without needing an LSP client, and it will just output a
report in JSON to the path you specify with **--logpath**.

For my Lua projects, I wrote a little script that runs lua-language-server with
**--check**, parses the report (with the help of json.lua [#json.lua](#json.lua)
and then outputs the issues, and a non-0 exit code, if there were any.

You can find an example in the **.tools/** directory in gigatools
[/cgit/gigatools.git/about](/cgit/gigatools.git/about/).
