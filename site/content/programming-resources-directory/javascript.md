+++
title               = 'JavaScript Resources'
scrollingTitleCount = 3
+++

## Statically Typed JavaScript

You can get static typing in JavaScript with the TypeScript compiler without
resorting to writing your project in TypeScript and subjecting yourself to
Microsoft's whims.

First, if you haven't already, run **"tsc --init"** in the project's directory.

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

Now tsc will use the type information it can infer and from JSDoc annotations
[https://jsdoc.app *(February 28, 2025)*](https://jsdoc.app) to typecheck
everything, just run **"tsc"**.
