+++
title               = 'Statically Typed JavaScript'
scrollingTitleCount = 2
date                = '2025-02-28'
+++

Written: February 28, 2025.

---

In a previous blog post,
[/blog/statically-typed-lua](/blog/statically-typed-lua),
I talked about my desire for static typing in Lua and how you could achieve it,
and more importantly, how to do that without introducing extra build steps and
dependencies, all with lua-language-server.

There's nothing inherently wrong with depending on things, nor is there in
having to build software, but I prefer to make software as simple as I resonably
can. Why introduce extra moving parts if I don't have to?

I came to the same problem with JavaScript (I know) while working on reviving
one of my previous projects, multiply-by-n
[/cgit/multiply-by-n.git/about](/cgit/multiply-by-n.git/about/).
I originally wrote this in high school, and then abandoned it, and then rewrote
it later, and then abandoned it again, and then finally I decided to clean it up
and slap it on paltepuk because it looks cool
[/game-and-simulations/multiply-by-n](/game-and-simulations/multiply-by-n/).

After I finished cleaning it up, I thought, as I usually do with
dynamically-typed languages: "Man, I'd really like static typing on this..."

## TypeScript?

Of course, you're probably aware of the many-praised TypeScript. However, let me
tell you this: TypeScript is trash. Why? **Microsoft**. By rewriting your
JavaScript project in TypeScript you now depend on a piece of **Microsoft**
software. Additionally, this means you have more dependencies and extra build
steps too.

But, what if I told you that you can have your cake and eat it too?

You see, the TypeScript compiler can actually typecheck JavaScript code. That's
right, you can use TypeScript without depending on it!

## How?

First, if you haven't already, run **"tsc --init"**.

Then, in the generated **tsconfig.json**, set **checkJS** and **noEmit** to
**true**, i.e.:

```json
{
  "compilerOptions": {
    "checkJs": true,
    "noEmit":  true,
  }
}
```

**checkJS** instructs tsc to typecheck JavaScript code, and **noEmit** stops it
from outputting files, else it will crash with an error about overwriting your
files.

That's it!

Now tsc will use the type information it can infer and from JSDoc annotations
[https://jsdoc.app *(February 28, 2025)*](https://jsdoc.app) to typecheck
everything, just run **"tsc"**!
