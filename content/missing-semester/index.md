+++
title = "Biggest Takeaways from The Missing Semester of Your CS Education"
date = 2024-05-05
draft = false

[taxonomies]
categories = ["programming"]
tags = ["productivity"]

[extra]
toc = true
+++

Nearly a year ago, I took an online course called
[The Missing Semester of Your CS Education](https://missing.csail.mit.edu/). The
course was created by a group of MIT students and covers a wide range of topics
that are often overlooked in traditional computer science curriculums. The
course is designed to help students become more productive and efficient
programmers by teaching them essential skills that are not typically taught in
school.

<!-- more -->

Still to this day, I find myself using many of the tools and techniques that I
learned in the course. In this post, I will share some of the biggest takeaways
from The Missing Semester of Your CS Education and how they have helped me
become a better, more productive programmer.

## 1. Version Control with Git

For such a widely used tool, it is surprising how little formal education is
given on Git beyond perhaps a brief introduction to `git clone`, `git add`,
`git commit`, and `git push`. Personally, it wasn't until I began my first
internship how little I knew about Git and how much I had to learn on the job.
The course provides a greater overview of Git and its capabilities, including
some of the more advanced features that can help you become a more efficient and
effective programmer.

Below are some of the less common but very useful commands that I learned from
the course and through my own exploration:

### 1.1 Using switch instead of checkout

```bash

# Using `switch` instead of `checkout`
git switch -c new-branch

# Switching to the previous branch
git switch -
```

`switch` is a newer command that was introduced in Git 2.23. It is meant to be a
more user-friendly alternative to `checkout` for switching branches. The
`switch` command is more intuitive and easier to use than `checkout`, especially
for beginners. It is also more consistent with other Git commands, such as
`git branch` and `git merge`.

### 1.2 Learning to use rebase

```bash

# Rebasing a feature branch on top of the main branch to keep the commit
# history clean
git switch main
git pull
git switch feature-branch
git rebase main

# After resolving any conflicts, switch back to the main branch and merge the
# feature branch
git switch main
git merge feature-branch
```

A diagram of the rebase process:

1\. Initial State

<pre>
main:       A---B---C
                 \
feature-branch:   D---E
</pre>

As you can see, the feature branch has diverged from the main branch with
commits `D` and `E`, which are behind commit `C` on the main branch.

2\. After running `git rebase main` on the feature branch

<pre>
main:       A---B---C
                     \
feature-branch:       D'---E'
</pre>

After rebasing, two **new** commits `D'` and `E'` are created on the feature
branch, which have new commit hashes from the original commits `D` and `E`.
If there are any conflicts during the rebase process, you will need to resolve
them before continuing.

3\. After running `git switch main` and `git merge feature-branch`

<pre>
main: A---B---C---D'---E'
</pre>

Finally, the feature branch is merged back into the main branch. Now we have a
**linear commit history**!

A key benefit of rebasing is that it keeps the commit history clean and linear,
making it easier to understand and navigate.

> **NOTE** It is important to note that rebasing rewrites commit history, so
> it should be used _with caution_, especially when working on shared
> branches with collaborators. If working with others, use the
> `--force-with-lease` flag when pushing rebased commits to a shared branch.
> This flag ensures that if your changes conflict with the remote branch, you
> will not overwrite someone else's work.

### 1.3 Stashing changes

```bash

# Stashing changes before switching branches
git stash

# Applying the stashed changes
git stash apply

# Listing all stashes
git stash list

# Applying a specific stash
git stash apply stash@{2}
```

There are many other useful Git commands and techniques, but these are some of
the ones that I use most frequently in my day-to-day work. The best way to learn
Git is by actually using it, struggling with it, and learning from others.
Again, Git can be tricky and it takes practice— Linus Torvalds, the creator of
Git, wrote in the initial commit message of Git that it stands for:

{{ note(body="

- 'global information tracker': you're in a good mood, and it actually
  works for you. Angels sing, and a light suddenly fills the room.
- 'goddamn idiotic truckload of sh\*t': when it breaks

")}}

<br>

## 2. Hammerspoon

Hammerspoon is an automation tool available for macOS that runs on custom Lua
scripts. The greatest use case that I found for it was for writing scripts to
allow me to use custom keyboard bindings to control the sizing and location of
my windows without having to use the mouse.

While this seems like it a relatively small enhancement, the seconds saved from
every time I need to resize a window compound into minutes and hours saved over
time. Here's a snippet of the `window.lua` script I wrote to do this:

```lua

-- Bind Option+Command+Arrow keys to move windows
hs.hotkey.bind({"cmd", "alt"}, "left", function() moveWindowToGrid(1) end)   -- Move window to left half
hs.hotkey.bind({"cmd", "alt"}, "right", function() moveWindowToGrid(2) end)  -- Move window to right half
hs.hotkey.bind({"cmd", "alt"}, "up", function() moveWindowToGrid(3) end)     -- Move window to top half
hs.hotkey.bind({"cmd", "alt"}, "down", function() moveWindowToGrid(4) end)   -- Move window to bottom half
```

I have not yet explored all the capabilities of Hammerspoon, but this one
feature alone has made it a valuable tool for me. I highly recommend checking it
out if you are a macOS user and are looking to automate repetitive tasks or
create custom keyboard shortcuts. For more information on Hammerspoon, check out
the [official documentation](https://www.hammerspoon.org/).

## 3. Dotfiles

Dotfiles are configuration files that are used to customize the settings of
various programs and tools. They are typically stored in the home directory of a
user and are prefixed with a `.` (e.g., `.bashrc`, `.vimrc`, `.gitconfig`). The
course introduced me to the concept of dotfiles and the benefits of storing them
in a version-controlled repository. Additionally, setting up aliases dotfiles
can help you streamline your workflow and make your development environment more
efficient.

By storing your dotfiles in a version-controlled repository, you can easily
synchronize your configurations across multiple machines and share them with
others. Additionally, you can keep track of changes to your configurations over
time and revert to previous versions if needed. If you ever switch to a new
machine or need to set up a new environment, you can quickly install your
dotfiles and have your familiar configurations ready to go, especially if you
write a bootstrap script to automate the process.

### 3.1 Helpful aliases

Aliases are shortcuts that you can define in your dotfiles to make common
commands easier to type and remember. Here are some examples of aliases that you
can add to your `.bashrc` or `.zshrc` file to make your life easier:

```bash

# Example aliases
alias ll="ls -la"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gco="git checkout"
alias gb="git branch"
alias gl="git log"
```

In my `.gitconfig` file, I have also set up aliases to enhance the `graph` and
`log` commands:

```bash

# .gitconfig
[alias]
    graph = log --all --graph --decorate --oneline
    l = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

### 3.2 Setting up a dotfiles repository

To set up a dotfiles repository, you can follow these steps:

1\. Create a new directory for your dotfiles repository in your home directory:

```bash

mkdir ~/.dotfiles # or any other name you prefer
```

2\. Initialize a new Git repository in the directory:

```bash

cd ~/.dotfiles
git init
```

3\. Move your dotfiles into the repository and create symbolic links to them in
your home directory:

```bash

mv ~/.bashrc ~/.dotfiles
ln -s ~/.dotfiles/.bashrc ~/.bashrc
```

You can view all of your configuration files with the following command:

```bash

ls -a ~
```

Configuration files that are prefixed with a `.` are typically hidden by
default, so you may need to use the `-a` flag to display them.

If you have set up the symbolic links correctly, running the `ls -a ~` command
should show the symbolic links in your home directory pointing to the dotfiles
in your repository like so:

{{ responsive(
    src="symlinks.png",
    alt="Dotfiles in home directory",
    caption="Above: My dotfiles in my home directory symlinked to my dotfiles
        repository."
    width=90
) }}

4\. Add, commit, and push your dotfiles to your remote repository (e.g.,
GitHub):

```bash

git add .
git commit -m "Initial commit"
git remote add origin
git push -u origin master
```

By following these steps, you can create a centralized repository for your
dotfiles and easily manage your configurations across multiple machines. You can
also share your dotfiles with others and benefit from the productivity
enhancements that they provide.

The great thing about dotfiles repositories is that doing a simple search on
GitHub will yield many examples of how others have set up their dotfiles. You
can learn from their configurations and customize them to suit your own
preferences. If you're interested in seeing an example of a dotfiles repository,
you can check out [mine](https://github.com/micahkepe/dotfiles).

## Conclusion

The Missing Semester of Your CS Education is a fantastic course that covers a
wide range of topics that are essential for becoming a more productive and
efficient programmer. The course has helped me improve my skills in version
control, automation, and configuration management, and I continue to use many of
the tools and techniques that I learned in my day-to-day work.
