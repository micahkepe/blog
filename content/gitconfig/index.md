+++
title = "Git Gud: Setting Up a Better Git Config"
date = 2025-07-23
draft = false

[taxonomies]
categories = ["programming"]
tags = ["tools", "git"]

[extra]
toc = true
+++

There's tons of little goodies you can add to your `.gitconfig` to make your
life easier. From hidden gems in the git Man pages to aliases and shell
functions, here's a few things I've found useful to reduce friction in my Git
workflow.

<!-- more -->

## Quality of Life Improvements

These are some of the little things I've done that I think have contributed the
most to improving my experience with Git.

### Verbose Commit Context

When you run `git commit` with no message specified, Git will open an editor
with a template that looks like this:

```COMMIT_EDITMSG
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# On branch main
# Your branch is up to date with 'origin/main'.
# ...
```

All lines starting with `#` will be ignored, so Git will not include them in
your commit message. By default, Git will just list what files you've changed
and what branch you're on, but we can make it more verbose by adding a
`commit.verbose` setting to our `.gitconfig`:

```ini
[commit]
  verbose = true
```

Or run:

```bash
git config --global commit.verbose true
```

Now, when you run `git commit`, Git will include the file diffs as well at the
end of the template so that you can see what exactly you're committing:

{{ responsive(
  src="images/verbose-commit.png",
  caption="Example of a Git commit with verbose output",
  alt="Example of a Git commit with verbose output"
) }}

### Intuitive Sorting and Listings of Branches and Tags

By default, Git comes with some not-so-sane defaults in my opinion for
displaying branches and tags. But we can fix them!

#### Sorting Out Branches

Two flaws in the default sorting of branches:

1. Branches are sorted alphabetically

2. Branches are listed as a single column (no matter how many branches you have)

   So if we have a ton of branches, we'll get output like this on `git branch`:

```
  and-so-on
  another-branch-1
  another-branch-2
  another-branch-3
  another-branch-4
  another-branch-5
  i-think-you-get-the-point
  i-think-you-get-the-point-1
  i-think-you-get-the-point-2
  i-think-you-get-the-point-3
  list
* main
  yet-another-branch-1
  yet-another-branch-2
  yet-another-branch-3
  yet-another-branch-4
  yet-another-branch-5
```

To fix **(1)** let's set `branch.sort` to `-committerdate` so that branches
are sorted by their commit date:

```ini
[branch]
sort = -committerdate
```

Or run `git config --global branch.sort -committerdate`.

Now, when you run `git branch`, we'll get our branches sorted with the most
recently modified at the top.

To fix **(2)**, let's set `column.ui` to `auto` so that branches are listed as a
column:

```ini
[column]
  ui = auto
```

Or run `git config --global column.ui auto`.

Now, when you run `git branch`, we'll get our branches listed as a column:

```
and-so-on                     another-branch-3              i-think-you-get-the-point     i-think-you-get-the-point-3   yet-another-branch-1          yet-another-branch-4
another-branch-1              another-branch-4              i-think-you-get-the-point-1   list                          yet-another-branch-2          yet-another-branch-5
another-branch-2              another-branch-5              i-think-you-get-the-point-2 * main                          yet-another-branch-3
```

#### Sorting Out Tags

Since tags are also sorted alphabetically by default, if you run `git tag`
you'll get non intuitive listings for your tags:

```
v1.0.0
v1.1.1
v1.1.10
v1.1.2
.
.
.
v1.0.9
```

Instead, let's set `tag.sort` to `version:refname` so that tags are sorted by
their version number:

```ini
[tag]
  sort = -version:refname
```

Or run `git config --global tag.sort -version:refname`.

> Note: The `-` in front of `version:refname` is to reverse the sort order so
> that the most recent tags are listed first. You can omit it if you want the
> tags to be sorted in ascending order.

Now, when you run `git tag`, you'll get a nicely sorted list of tags:

```
v1.0.10
v1.0.9
.
.
.
v1.1.2
v1.1.1
v1.0.0
```

---

### Prettier Diffs with [`diff-so-fancy`](https://github.com/so-fancy/diff-so-fancy)

By default, Git will show you diffs in a very compact form chalk full of @#$%!
symbols that are hard to read, especially when you have a lot of cross file
changes:

{{ responsive(
    src="images/diff-default.png",
    caption="Example of a Git diff with a lot of cross file changes",
    alt="Example of a Git diff with a lot of cross file changes"
) }}

Instead, let's use [`diff-so-fancy`](https://github.com/so-fancy/diff-so-fancy)
to make your `git diff` look like it deserves a frame.

Here's how to set it up:

1. Install `diff-so-fancy` with the pakcage manager of your choice. For example,
   if you're using Homebrew, run `brew install diff-so-fancy`. Check the GitHub
   repo for other installation options.

2. Update your `core.pager` and `interactive.diffFilter` settings to use
   `diff-so-fancy` instead of the default `less` pager:

   ```bash
   git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
   git config --global interactive.diffFilter "diff-so-fancy --patch"
   ```

{{ responsive(
    src="images/diff-so-fancy-sample.png",
    caption="Example of a Git diff with a lot of cross file changes using diff-so-fancy",
    alt="Example of a Git diff with a lot of cross file changes using diff-so-fancy"
) }}

#### **Bonus**: Change the Diff Algorithm

By default, Git uses a diff algorithm called patience diff, but it's not the
only algorithm out there. Personally, I have changed my default diff algorithm
to `histogram`, which in some cases leads to a more readable diff.

To change the diff algorithm, run:

```bash
git config --global diff.algorithm histogram
```

Or add the following to your `.gitconfig`:

```ini
[diff]
  algorithm = histogram
```

The difference is not huge, but it's worth it if you're looking for a more
readable diff on certain edge cases.

### Rebasing on Pull Conflicts

This one might be a smidge controversial, but I personally like rebasing on pull
conflicts as it keeps the commit history clean without all the extra "Merge
branch 'main' into 'main'" commits.

We can enable rebase on pull conflicts with:

```ini
[pull]
  rebase = true
```

Or run:

```bash
git config --global pull.rebase true
```

Now, instead of a messy merge commit, `git pull` rewrites your local changes on
top of the updated upstream branch.

### Setting Your Editor

When you run a command that opens an editor, like `git commit` with no message
specified, it will open an editor (default is usually `vi`, which is fine
if you're stuck in 1975).

{{ note(
header="Note on Editor Variable Precedence",
hidden=true,
body='
You can also set the editor with the `GIT_EDITOR` environment variable, which
has greater precedence than the `core.editor` configuration option:

From the `git-var(1)` man page:

> ```
> GIT_EDITOR
>    Text editor for use by Git commands. The value is meant to be interpreted by the shell when
>    it is used. Examples: ~/bin/vi, $SOME_ENVIRONMENT_VARIABLE, "C:\Program Files\Vim\gvim.exe"
>    --nofork. The order of preference is $GIT_EDITOR, then core.editor configuration value, then
>    $VISUAL, then $EDITOR, and then the default chosen at compile time, which is usually vi.
> ```

However, it probably makes more sense if for whatever reason you do not want to
set the editor in your `.gitconfig`, you could set it with the `VISUAL`
environment variable instead since it will work with most other programs as
well.

') }}

Go ahead and set your editor to `nvim` (or `emacs` if you're a weirdo).

### Automatically Setup Remote Repositories

How many times have you been pushing a new branch to a remote resository and you
are hit with a wall of text telling you to run `git push --set-upstream origin
<branch>` and then `git push` again? Let's make it so that you never have to
see this again:

In your `.gitconfig`, add the following:

```ini
[push]
autoSetupRemote = true
```

Or run:

```bash
git config --global push.autoSetupRemote true
```

Now, when you run `git push`, Git will automatically set up the remote
repository for you.

---

## Optimizations and Maintenance

With very little effort, we can cash in on performance boosts and disk space
savings.

### Maintenance Scheduling

Git’s maintenance tasks optimize repository size and performance by running
tasks like garbage collection and repacking.[^1],[^2] You can enable automatic
maintenance to run in the background:

```ini
[maintenance]
  auto = true
  strategy = incremental
```

Or run:

```bash
git config --global maintenance.auto true
git config --global maintenance.strategy incremental
```

This sets up a cron-like job to periodically optimize your repositories,
reducing disk usage and improving performance. It’s a "set it and forget it"
feature, perfect for keeping your repositories lean without manual intervention.

### Compression

To reduce repository size, I set Git’s compression to the maximum level (9):

```ini
[core]
    compression = 9
```

Or run:

```bash
git config --global core.compression 9
```

Values range from -1 (default, platform-dependent) to 9 (maximum compression).
Higher compression saves space but takes slightly longer. Since my worktrees are
small, the tradeoff is worth it.

---

## Git Shortcuts with Aliases

There's two types of aliases that I use: Git-defined and shell-defined. Git
aliases are defined in the `.gitconfig` file, while shell aliases are defined
in the shell's configuration file.

### Git Aliases

Git aliases are defined in the `.gitconfig` file and are prefixed with `git
<alias>`.

In `.gitconfig`:

```ini
[alias]
  graph = log --all --graph --decorate --oneline
  l = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
  ignore = "!gi() { local IFS=','; curl -sL https://www.toptal.com/developers/gitignore/api/\"$*\"; }; gi"
```

- `graph`is a Git alias that shows a graph of your commit history with one
  commit per line instead of the default, which I think is very cluttered. Run
  with`git graph` to see it in action.

- `l` will pretty print your commit history with a custom format. I stole this
  one from a coworker and never looked back. Run with `git l`.

- `ignore` is so I can quickly add a bunch of files to my `.gitignore` file. I
  already was using [`gitignore.io`](https://www.toptal.com/developers/gitignore)
  all the time to generate my `.gitignore` files, so I figured I'd just add a
  little helper function to my `.gitconfig` to make it easier. This one does
  require an internet connection since it fetches the response via `curl`.

  > The `!` at the beginning of the function tells Git to run it as a shell
  > command rather than a Git built-in command.

  Now I can run `ignore` and it will fetch the response from `gitignore.io`:

  ```bash
  # In new Java project
  git ignore java > .gitignore

  # Append to existing .gitignore
  git ignore python node >> .gitignore

  # Languages can be comma-separated and/or space-separated because of the
  # `$*` expansion
  git ignore python,node >> .gitignore # same as above
  ```

{{ note(
header="Note on `$*` Expansion",
hidden=true,
body="
This is not directly related to Git, but I had fun figuring out how to do
this with my `ignore` alias.

This script originally came from the [gitignore.io Command Line
Docs](https://docs.gitignore.io/install/command-line),
but they use the `$@` variable instead of `$*` for the language list:

```bash
gi() {
    curl -sL https://www.toptal.com/developers/gitignore/api/$@;
};
```

The `$@` variable is a special variable in Bash that expands to all the
arguments/ fields passed. However, the fields are separated by spaces, which
means that for the original script, the language list necessarily had to
strictly comma-separated without spaces like this:

```
git ignore python,node
```

This because it passes the arguments to the `curl` command and the request
expects them to be separated by commas.

However, I didn't like this inflexibility, so I changed the script to use `$*`
instead of `$@`. `$*` is another special variable that expands to all the fields
passed BUT with a special internal field separator variable, `IFS`, which is
space by default. So, if we locally set `IFS` to a comma, we can pass the
language list as a space-separated list as well and get the same result:

```
git ignore python node
```

Now we have the same request sent but with the flexibility to pass a space-
separated list and/or a comma-separated list.
"
)}}

### Shell Aliases

Next up are all of my Git-related shell aliases. While you could define these
in your `.gitconfig`, I prefer to define them in my shell's configuration file
to make them shorter since we can forgo the `git` prefix and use two or three
letters instead.

<details open>
<summary>Bash/Zsh</summary>

In `~/.bashrc` or `~/.zshrc`:

```bash
alias gs="git status --short"
alias gc="git commit"
alias gi="git init"
alias gcl="git clone"
alias ga="git add"
alias gap="git add --patch"
alias gd="git diff"
alias gr="git restore"
alias gp="git push"
alias gu="git pull"
```

</details>

And for my fellow Fish users:

<details open>
<summary>Fish</summary>

`~/.config/fish/config.fish`:

```fish
function gs; git status --short $argv; end
function ga; git add $argv; end
function gap; git add --patch $argv; end
function gi; git init $argv; end
function gc; git commit $argv; end
function gl; git log $argv; end
function gcl; git clone $argv; end
function gp; git push $argv; end
function gu; git pull $argv; end
function gd; git diff $argv; end
function gr; git restore $argv; end
```

</details>

Everything is a mneumonic so it's easy to remember:

- `ga` for '**g**it **a**dd'
- `gc` for '**g**it **c**ommit'
- `gd` for '**g**it **d**iff'
- `gl` for '**g**it **l**og'
- `gp` for '**g**it **p**ush'
- `gcl` for '**g**it **cl**one'
- ...

I'll admit, "gu" for `git pull` breaks this pattern since "gp" is already taken
by `git pull`, but I think of it as '**g**it **u**pdate'.

The alias for `git status --short` is something I stole from the [codingjerk
YouTube channel](https://www.youtube.com/@codingjerk)[^3]. What I like about
this is that the normal `git status` command just gives too much information and
when I just want to quickly see modified files, it fills up nearly the entire
vertical space of my terminal.

Default `git status` output:

```
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
	modified:   sample.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

(I think after the thousandth time I've used `git status`, I got the point that
I can add files to the staging area with `git add`.)

With `git status --short`:

```
## main
 M README.md
 M sample.txt
```

I also recommend setting `status.branch = true` to show the branch name in the
status output, even if you are using the `--short` flag:

```ini
[status]
  branch = true
```

Or run:

```bash
git config --global status.branch true
```

---

## GPG Signing: Verifying You and Your Commits

Want that sweet little “Verified” badge on your commits? You’ll need to set up
GPG signing.

**GPG** (GNU Privacy Guard) is an open-source implementation of the PGP (Pretty
Good Privacy) standard. It lets you encrypt, decrypt, and—most relevant
here—**sign** things to prove they came from you.

When you generate a GPG key, you get two keys:

- **Public key** — Share this with the world. Others use it to verify your
  signature or send you encrypted messages.
- **Private key** — Keep this secret. It proves your identity when signing
  things (like commits). Don’t lose it. Don’t leak it.

### Signing Commits with GPG

Here’s the basic flow to get going:

1. **Generate a key**
   Run:

   ```bash
   gpg --full-generate-key
   ```

   Pick the defaults unless you know what you’re doing.

2. **List your GPG key ID**
   Run:

   ```bash
   gpg --list-secret-keys --keyid-format=long
   ```

   Grab the long key ID (`XXXXXXXXYYYYZZZZ`) for the next step.

3. **Tell Git to use it**
   Add this to your Git config:

   ```bash
   git config --global user.signingkey <your-key-id>
   git config --global commit.gpgsign true
   ```

4. **Add your public key to GitHub**
   Export your public key:

   ```bash
   gpg --armor --export <your-key-id>
   ```

   Then go to [https://github.com/settings/gpg/new](https://github.com/settings/gpg/new),
   paste it in, and you’re set.

Now when you commit and push, GitHub will show a "Verified" badge if everything
lines up.

> On macOS, you might want to install [GPG Suite](https://gpgtools.org/) for
> better integration.

### Bonus: Email Signing

GPG isn’t just for Git—you can use it to sign emails too. Clients like NeoMutt
or Mutt support this, though fair warning: it’ll attach your public key to every
message, which might not be your vibe. I don’t use this personally, but it’s
there if you want it.

---

## Miscellaneous Goodies

Here's a collection of some small tweaks that you can brag to your coworkers
about.

### Rerere

I know what you're thinking, "What the hell does that even mean?"

"Rerere" stands for "**re**use **re**corded **re**solution". Again this is still
a little mysterious, but we can see from the `git-rerere(1)` man page:

> ```
> DESCRIPTION
>        In a workflow employing relatively long lived topic branches, the developer sometimes needs to
>        resolve the same conflicts over and over again until the topic branches are done (either merged to
>        the "release" branch, or sent out and accepted upstream).
>
>        This command assists the developer in this process by recording conflicted automerge results and
>        corresponding hand resolve results on the initial manual merge, and applying previously recorded
>        hand resolutions to their corresponding automerge results.
> ```

In English: When you have resolved a conflict in the past, `git rerere` will
keep track of the resolution and apply it to future conflicts.

Resolve a conflict once, and `rerere` saves it. Same conflict later? It’s
auto-fixed, but you still check with `git diff` and `git add` to make sure
everything is okay.

### Whitespace

I already have whitespace highlighted in my editor, but if some were to slip
through, I'd like to highlight them in diffs so I can strip them out.

In your `.gitconfig`, we can specify what types of whitespace we want Git to
flag in diffs with a comma-separated list:

```ini
[core]
  whitespace = trailing-space
```

Or run:

```bash
git config --global core.whitespace trailing-space
```

For me, I just highlight trailing whitespace in diffs, but some other options
you could try:

- `space-before-tab`
- `space-before-tab,space-in-empty-line`
- `space-before-tab,space-in-empty-line,indent-with-non-tab`

### Help Prompts for Command Misspellings

If you are typing out a git command in full and you make a typo, by default
you'll get a message like this:

```
$ git psuh

git: 'psuh' is not a git command. See 'git --help'.

The most similar command is
        push
```

So you retry again (in my case probably making another typo or two) until you
get the right command you were going for.

Instead, just adjust your `.gitconfig` to prompt you:

```ini
[help]
  autocorrect = prompt
```

Or run:

```bash
git config --global help.autocorrect prompt
```

Now, when you make a typo, you'll get a prompt instead:

```
$ git psuh

WARNING: You called a Git command named 'psuh', which
 does not exist.
Run 'push' instead [y/N]?
```

Ahh, much better! Now you can just type `y` and you're good to go.

There's also more options for `autocorrect` that you can read about in the
[git-config man page](https://git-scm.com/docs/git-config#Documentation/git-config.txt-helpautocorrect),
such as running the suggested command immediately without prompting.

---

## Conclusion

I hope this post sheds some light on the configurability of Git and a small
subset of the options available. For such a ubiquitous tool, I think it's worth
it to spend the time to tailor it to your needs instead of just rolling with the
basic setup of configuring your username and email.

My full `.gitconfig` can be found [here](https://github.com/micahkepe/dotfiles/blob/main/.gitconfig).

If you have any questions, or if there's something I've missed, feel free to
comment below!

---

## References

[^1]:
    YouTube: [So You Think You Know Git - FOSDEM 2024](https://www.youtube.com/watch?v=aolI_Rz0ZqY)

    Scott Chacon (one of the founders of GitHub) goes over a lot hidden tricks
    and tips for Git.

[^2]:
    YouTube: [Scott Chacon - So you think you know Git. Advanced Git Tips and
    Tricks - DevWorld 2024](https://www.youtube.com/watch?v=38iySnesryU)

    A follow up to the above video, this one goes over some more advanced
    configurations and tips.

[^3]:
    YouTube: [Configure your Git](https://youtu.be/G3NJzFX6XhY?si=lP3bDIBIim1W0_Ve)

    A video by [codingjerk](https://www.youtube.com/@codingjerk) going over his
    personal `.gitconfig` and how he uses it, and a large inspiration for me to
    make this post.
