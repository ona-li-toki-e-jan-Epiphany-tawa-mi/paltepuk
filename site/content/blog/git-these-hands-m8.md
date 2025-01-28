+++
title               = 'git These Hands m8'
scrollingTitleCount = 3
date                = '2025-01-27'
+++

Written: January 27, 2025.

---

Since a while ago, I have three different git servers that I host my software
projects on: "my" GitHub account, this website, and my homelab (which I also
have some private projects on.)

One of the problems that came up with this setup was: how do I keep them in
sync?

I ended up solving it with the following shell script:

```sh
for remote in $(git remote); do
    git push "$remote" "$@"
done
```

Yep, that's it. It iterates each remote in the git repository and pushes to
them.

git gud scrub.
