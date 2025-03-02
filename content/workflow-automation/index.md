+++
title = "Using Bash, Unix Tools, and Hammerspoon to Speed Up Your Workflow"
date = 2024-12-13
draft = false

[taxonomies]
categories = ["productivity"]
tags = ["unix", "tools", "cli", "bash"]

[extra]
toc = true
+++

With just a basic working knowledge of writing Bash scripts and understanding
Unix tools and their design philosophy, you can easily create scripts to
automate your workflow and improve your productivity. In this post, we'll get
our feet wet in writing Bash scripts and combine them with some powerful Unix
tools to create a powerful and versatile toolset. We'll also explore how you can
use Hammerspoon, a macOS automation tool, to take your automation to the next
level.

<!-- more -->

## Introduction

As a college student, I find that most of my peers have little to no experience  
with the command line interface (CLI) and Unix tools. This is unfortunate, as
personally after discovering Vim, tmux, and other Unix tools, I have found that
I have become more productive, enjoyed writing code more, and have a better
understanding of how my machine works. This is not to say that editors like
Visual Studio Code or IDEs are bad (I myself used Visual Studio Code for a long
time), but rather that Unix tools provide a different way of working that can
be more efficient and enjoyable for some people. Even if you don't end up using
Unix tools in your daily workflow, understanding them can be beneficial, as they
are the foundation of many modern tools and technologies.

For Vim users and those trying to minimize their mouse usage, these tools also
allow you to do everything from file navigation to text manipulation without
ever leaving the keyboard. Even for non-Vim users, these tools can still be
useful for automating repetitive tasks, managing files, and more.

---

## Your 20 Minute Intro to Bash

Bash can be a little intimidating at first, but it is actually quite simple once
you get the hang of it. In this section, we will cover the basics of Bash
scripting to get you started. By no means at the end of this will you be an
expert at writing Bash scripts, but we will know enough to write some useful
scripts of our own.

### Variables

Just like you would expect, varibles are assigned using the `=` operator. Here
is an example:

```bash

name="John"
age=20
```

Notice that there are no spaces around the `=` operator. Also, Bash does not
distinguish between different types of variables, so you can assign a string to
a variable and then assign an integer to the same variable.

Here's some basic things we can do with variables:

```bash

# Print the value of a variable using the echo command
echo $name # access the value of a variable using the $ operator

# Assign the output of a command to a variable
files=$(ls) # syntax: $(command)

# Use the value of a variable in a command
echo "Hello, $name!" # prints "Hello, John!"
```

### Supported Data Types in Bash

Bash doesn't strongly differentiate data types the way higher-level languages do.
All variables are essentially strings. For arithmetic operations, Bash evaluates
the variable contents as integers if possible. Arrays in Bash are just lists of
strings. There's no native support for complex data structures out of the box,
but you can do a lot with what is provided.

Examples:

```bash

name="Alice"    # string
count=42        # integer stored as a string, but usable in arithmetic

fruits=("apple" "banana" "cherry")
echo ${fruits[0]}  # prints "apple"
```

There’s no separate syntax for declaring a variable as an integer vs. a string.
It’s all context-based.

### Bash Loops and Comparisons

#### Bash Loops

Bash loops and conditionals have a somewhat unusual syntax when coming from
languages like Python or Java. The key patterns to remember are:

- `if ... then ... fi` for conditionals
- `for ... do ... done` for loops
- `while ... do ... done` and `until ... do ... done` for other loop constructs

Bash uses `fi` to end an `if` block, and done to end loops. This might
feel odd at first, but you’ll get used to it quickly.

`for` loops:

```bash

for file in *.txt; do
    echo "Processing $file"
done
```

This loop iterates over all `.txt` files in the current directory. The `do`
keyword starts the loop's body, and `done` ends it.

`while` loops:

```bash

count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    count=$((count+1))
done
```

This loop runs as long as the condition `[ $count -le 5 ]` is true (we'll go
over the syntax for comparisons in a bit). The `count=$((count+1))` line
increments the value of the `count` variable by 1.

`if` statements:

```bash

age=20
if [ $age -ge 18 ]; then
    echo "You are an adult."
else
    echo "You are a minor."
fi
```

In Bash, `if` blocks always end with `fi`. Also notice we use `[` and `]`
around the condition; this is part of Bash's test syntax.

#### Bash Comparisons

Bash has wonky syntax for comparisons that you just have to memorize
unfortunately.

Bash uses different forms of brackets and parentheses for distinct purposes,
which can be confusing at first. The single brackets `[ ]` are essentially a
shorthand for the `test` command and are used for conditional checks. The
double brackets `[[ ]]` are a Bash-specific enhancement that provides more
features, like regular expression matching and simplified handling of strings
without the need for extensive quoting. For arithmetic operations, double
parentheses `(( ))` treat variables as integers and allow direct arithmetic
evaluation, while command substitution uses `$( )` to run a command and
capture its output.

**tldr**: `[ ]` and `[[ ]]` are for conditionals, with `[[ ]]` being more
versatile and safer in many cases; `(( ))` handles arithmetic cleanly, and
`$( )` executes commands and returns their results. Understanding these
subtle differences will make your Bash scripts more reliable and easier to read.

<details open>
<summary>Arithmetic Comparisons</summary>

| **Bash** | **Meaning** |
| -------- | ----------- |
| `-lt`    | <           |
| `-gt`    | >           |
| `-le`    | <=          |
| `-ge`    | >=          |
| `-eq`    | ==          |
| `-ne`    | !=          |

</details>

Example:

```bash

num=10
if [ $num -gt 5 ]; then
  echo "$num is greater than 5"
fi
```

<details open> 
<summary>String Comparisons</summary>

| **Bash** | **Meaning**              |
| -------- | ------------------------ |
| `=`      | equal                    |
| `!=`     | not equal                |
| `<`      | less than                |
| `>`      | greater than             |
| `-n s1`  | string `s1` is not empty |
| `-z s1`  | string `s1` is empty     |

</details>

Example:

```bash

str="hello"
if [ "$str" = "hello" ]; then
    echo "The strings match"
fi
```

### Reading User Input and Trapping

The `read` command will let us retrieve data from `stdin`.

```bash

echo "Enter your name:"
read user_name
echo "Hello, $user_name!"
```

Next, we can use the `trap` command to execute another command after an event
like a sent signal such as `SIGINT` (Ctrl + C):

```bash

trap 'echo "Caught CTRL+C, exiting..."; exit 1' INT

while true; do
    echo "Press Ctrl+C to stop..."
    sleep 2
done
```

### Executing Bash files

To actually be able to run a Bash scripts, we need to do two things: (1) make
the file executable and (2) add a shebang to the file.

The shebang is a special line at the beginning of a script that tells the
operating system what interpreter to use to run the script. The shebang for
Bash scripts is `#!/bin/bash`. Here is an example of a simple Bash script:

```bash

#!/bin/bash
echo "Hello, World!"
```

Breaking down the shebang, you'll notice that `#!` is the shebang character
sequence, and `/bin/bash` is the path to the Bash interpreter. The shebang line
**must** be the first line of the script, as it tells your operating system how
to run the script. Without it, the script will not run since the operating system
will not know what interpreter to use.

Now to actually run the script, save it to a file (e.g. `hello.sh`), make it
executable using the `chmod` command, and then run it:

```bash

chmod +x hello.sh
```

Then to run the script, use `./hello.sh`.

That's it for our 20 minute intro to Bash. There is still a lot more to learn,
but this should be enough to get you started writing some simple scripts.
If you are interested in learning more, I recommend checking out the resources I
have linked at the end of this post or this Youtube video:

{{ youtube(id="tK9Oc6AEnR4", width=80)}}

---

## Unix Tools 101

### Unix Philosophy

Before diving into Unix tools, it is important to understand the Unix philosophy,
not only because it is the foundation of Unix tools, but also because it is a
design philosphy that leads to the powerful combinations and versatility of Unix
tools.

This philosophy can be summarized as follows:

{{ note(body="

1. Write programs that do one thing and do it well.
2. Write programs to work together.
3. Write programs to handle text streams, because that is a universal interface.

")}}

These rules are simple but have powerful implications. By writing programs that
do one thing well, you can create a set of tools that can be combined in
different ways to accomplish complex tasks. By writing programs to work together,
you can create powerful tool chains that can accomplish tasks that would be
difficult or impossible with a single program. By writing programs to handle text
streams, you can create tools that can be used in a wide variety of contexts,
since text streams are a universal interface.

### Common Unix-like Tools

#### `tldr`: simpler man pages

`tldr` provides simplified man page that provides practical examples of how to
use a command.

You can also get platform-specific man pages with the `--platform` flag like
this:

```bash

# - Print the tldr page for a command from a specific [p]latform:
#     tldr --platform android|common|freebsd|linux|osx|netbsd|openbsd|sunos|windows command
# Example:
tldr --platform linux htop
```

#### `fzf`: powerful fuzzy finder

For basic use, just running `fzf` will fuzzy find recursively on all files in
the present working directory. However, the `tldr` page for `fzf` also lists out
some more complex commands with `fzf`:

```bash

# - Start `fzf` on all files in the specified directory:
find path/to/directory -type f | fzf

# - Start `fzf` for running processes:
ps aux | fzf

# - Select multiple files with `Shift + Tab` and write to a file:
find path/to/directory -type f | fzf --multi > path/to/file

# - Start `fzf` with a specified query:
fzf --query "query"

# - Start `fzf` on entries that start with core and end with either go, rb, or py:
fzf --query "^core go$ | rb$ | py$"

# - Start `fzf` on entries that not match pyc and match exactly travis:
fzf --query "!pyc 'travis"
```

`fzf` will list the files in a nicely formatted list that you can navigate using
either the arrow keys or Vim-like bindings using `Ctrl + <hjkl>`.

`fzf` also has shell integration functions that are very helpful. To set up the
integration you'll need to add the following to your shell's respective
configuration file:

```bash

# Zsh
source <(fzf --zsh)

# Bash
eval "$(fzf --bash)"

# Fish
fzf --fish | source
```

Relaunch your shell to source the new configuration. Now we can use the provided
shell functionality.

> **Note for fish shell**: I use Fish shell, and while `fzf` has a fish plugin,
> but it doesn't seem well maintained and I had issues, use [fzf.fish](https://github.com/PatrickF1/fzf.fish)
> instead, which actually has a lot of bonus features as well like finding
> processes and variables.

#### `tmux`: terminal manager

`tmux` is a terminal multiplexer, in the future I will most likely have a whole
post dedicated to tmux and how I use it, but for now, just know that it is a
terminal multiplexer that allows you to split your terminal into multiple panes,
create sessions, and more. For now, let's just look at some basic commands.

By default, `tmux` uses `Ctrl + b` as a "prefix" key, which means that you press
`Ctrl + b` and then another key to execute a command. (You can change this to
a more convenient keybinding, a common one is `Ctrl + a`; you can do this by
adding `set -g prefix C-a` to your `~/.tmux.conf` file.)

Here are some common `tmux` commands:

```bash

# Create a new session:
tmux new-session

# Attach to a session:
tmux attach-session -t session_name

# Create a new window:
Ctrl+b c

# Split a pane horizontally:
Ctrl+b %

# Split a pane vertically:
Ctrl+b "
```

When you are in a `tmux` session, you can press `Ctrl + b` and then `?` to see
a list of all the keybindings available to you.

#### `sed` (Stream Editor)/ `grep`/ `awk`: text processing

`sed` and `awk` are text processing tools that allow you to manipulate text
files in various ways. `grep` is a tool that allows you to search for specific
lines in a file.

Here are some examples:

```bash

# Replace "old_text" with "new_text" in a file:
sed 's/old_text/new_text/g' file.txt

# Print lines containing "keyword" from a file:
grep "keyword" file.txt

# Extract the second column from a CSV file:
awk -F',' '{print $2}' file.csv
```

#### `htop`: system processes management

`htop` is an interactive process viewer that provides a more user-friendly
interface than the traditional top command. It allows you to sort, filter,
and kill processes easily.

Here are some examples:

```bash

# Start `htop`:
htop

# Start `htop` displaying processes owned by a specific user:
htop --user username
```

I recommend checking out the `tldr` page for `htop` for more examples and
exploring around in `htop` to see what it can do.

#### `bat`: `cat`, but better

`bat` is a drop-in replacement for `cat` that adds syntax highlighting, line
numbers, and Git integration.

Examples:

```bash

# print a file with syntax highlighting
bat main.py

# show all supported languages
bat --list-languages
```

#### `rg`: faster `grep`

`rg` (ripgrep) a faster alternative to `grep`, which is optimized for searching
large files and directories. It is a drop-in replacement for `grep` and is
faster than both `grep` and `ag` (The Silver Searcher).

Examples:

```bash

# search for "main" in current directory
rg main

# search including hidden files
rg --hidden main

# limit search to certain file types
rg main --glob '*.py'
```

### Practial Examples of Combining Unix-like Tools

#### Finding Files with a Certain Keyword

```bash

# Find all files in the current directory that contain the word "foo"
# and display the file name and line
rg foo | fzf | awk '{print $1, $2}'
```

#### Enhanced `nvim` Command

By default, we can open a new Neovim session in the current directory by simply
running `nvim` in the terminal. This is perfectly fine, but we can fine tune it
more by adding in some of the tools that we have looked at.

First, let's add the file selected from `fzf` to be what we open the Neovim
session in:

```bash

nvim $(fzf)
```

Let's also pass a `bat` command to `fzf`'s `'--preview` to let us see the files
as we navigate them with `fzf`.

```bash

nvim $(fzf --preview="bat --color=always {}")
```

Another thing we can enable with `fzf` is the `-m` flag, which will allow us to
select multiple files with TAB and then these will be put in open buffers when
we open Neovim!

```bash

nvim $(fzf -m --preview="bat --color=always {}")
```

To make this the default behavior for when we open Neovim, we can save this
enhanced command as an alias for `nvim`. Instead your `~/.zshrc`, `~/.bashrc`,
`~/.config/fish/config.fish`, etc.:

```bash

alias nvim='nvim $(fzf -m --preview="bat --color=always {}")'
```

#### ThePrimeagen's `tmux-sessionizer` Script

Another great example of combining tools is this `tmux-sessionizer.sh` script
that I adapted from [ThePrimeagen](https://www.youtube.com/c/theprimeagen):

```bash

#!/usr/bin/env bash

# Adapted from: https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer
#
# Description:
#   A script to create a new tmux session either by passing in a directory or
#   selecting one with fzf. For ease of use, add this script to your $PATH and
#   create an alias in your shell configuration file (e.g. .bashrc, .zshrc) like:
#   alias tmux-sessionizer='tmux-sessionizer.sh'
#
#   Then you can simply run with `tmux-sessionizer`
#
# Usage:
#  tmux-sessionizer.sh [directory]
#  tmux-sessionizer.sh


if [[ $# -eq 1 ]]; then
    selected=$1
else
    # if no directory is passed in, use fzf to select one
    # NOTE: change the directories to search in the find command as you wish
    selected=$(FZF_TMUX=1 find ~/coding ~ ~/vislang/ ~/rice/* -mindepth 1 -maxdepth 1 -type d | fzf)
fi

# exit if no directory is selected from fzf
if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# create new session if not in tmux
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

# create new session if name doesn't exist
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

if [[ -n $TMUX ]]; then
    tmux switch-client -t $selected_name
else
    # if running outside of tmux, attach to the new session
    tmux attach-session -t $selected_name
fi

```

Add this script to your `$PATH` and create an alias in your shell configuration
file (e.g. `.bashrc`, `.zshrc`) like:

```bash

alias tmux-sessionizer='tmux-sessionizer.sh'
```

Then you can simply run with `tmux-sessionizer`. You'll be prompted to select a
directory with `fzf` and then a new `tmux` session will be created with that
directory as the working directory.

---

## **EXTRA**: Automating with Hammerspoon **(MacOS)**

> **NOTE:** Sorry Windows and Linux users, this section is MacOS-specific. If you
> have any suggestions for similar tools on Windows or Linux, please let me know!

Hammerspoon is a powerful macOS automation tool that allows you to write Lua
scripts to automate your workflow. It is similar to Automator, but with more
power and flexibility. Hammerspoon can be used to automate window management,
launch applications, and more.

To be fair, I there is still so much of Hammerspoon's capabilities that I just
haven't had the time to look at or don't know about, but the biggest thing that
I use it for is window management. I have a script that I use to manage my
windows that I will share below. These make it easy to move windows around,
resize them, and switch between them without ever having to touch the mouse.

## Getting Started with Hammerspoon

### Installation and Getting Started

With Homebrew, you can install Hammerspoon with the following command:

```bash

brew install --cask hammerspoon
```

Now with Hammerspoon installed, we can start scripting using Lua. Our scripts
will live in the `~/.hammerspoon` directory and and then load the modules in
`~/.hammerspoon/init.lua` using `require(<modname>)` statements.

### Window Sizing

Let's create a file called `window.lua` in `~/.hammerspoon/` and add the
following code:

```lua

-- window.lua

-- Window grid layout
local grid = {
	{ x = 0, y = 0, w = 0.5, h = 1 }, -- Left half
	{ x = 0.5, y = 0, w = 0.5, h = 1 }, -- Right half
	{ x = 0, y = 0, w = 1, h = 0.5 }, -- Top half
	{ x = 0, y = 0.5, w = 1, h = 0.5 }, -- Bottom half
}

-- Function to move the current window to a specific screen grid location
local function moveWindowToGrid(location)
	local win = hs.window.focusedWindow()
	local screen = win:screen()
	local frame = screen:frame()

	local newFrame = {
		x = frame.x + (grid[location].x * frame.w),
		y = frame.y + (grid[location].y * frame.h),
		w = grid[location].w * frame.w,
		h = grid[location].h * frame.h,
	}

	win:setFrame(newFrame)
end

-- Window movement keybinds
-- NOTE: "alt" is the Option key on mac
hs.hotkey.bind({ "cmd", "alt" }, "left", function()
	moveWindowToGrid(1)
end) -- Move window to left half
hs.hotkey.bind({ "cmd", "alt" }, "right", function()
	moveWindowToGrid(2)
end) -- Move window to right half
hs.hotkey.bind({ "cmd", "alt" }, "up", function()
	moveWindowToGrid(3)
end) -- Move window to top half
hs.hotkey.bind({ "cmd", "alt" }, "down", function()
	moveWindowToGrid(4)
end) -- Move window to bottom half

-- quarter of screen
hs.hotkey.bind({ "shift", "alt", "cmd" }, "left", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 0.5 })
end)
hs.hotkey.bind({ "shift", "alt", "cmd" }, "right", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0.5, 0.5, 0.5 })
end)
hs.hotkey.bind({ "shift", "alt", "cmd" }, "up", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 0.5 })
end)
hs.hotkey.bind({ "shift", "alt", "cmd" }, "down", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0.5, 0.5, 0.5 })
end)

-- full screen
hs.hotkey.bind({ "alt", "cmd" }, "f", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 1 })
end)
```

To actually include the this window script, add the following to
`~/.hammerspoon/init.lua`:

```lua

-- ~/.hammerspoon/init.lua
require("window")
```

Save the file and reload your Hammerspoon configuration (you can do this by
clicking on the Hammerspoon icon in the menu bar and selecting "Reload Config").

Now try using the keybinds you set up to move your windows around. Use `Alt +
CMD + <arrow>` to move the active window to one of the four halves (vertically
and horizontally split) of the screen. You can also use `Alt + CMD + SHIFT +
<arrow>` to move the window to one of the window quarters.

### Window Switching

While macOS has a provided `CMD + Tab` shortcut for context switching windows,
there aren't previews for the windows and hidden/minimized windows are not
available. Hammerspoon's [window.switcher](https://www.hammerspoon.org/docs/hs.window.switcher.html)
API allows for overcoming both of these shortcomings.

Add the following to the end of your `~/.hammerspoon/window.lua` file:

```lua

-- window.lua

-- Window switching
-- better than cmd + tab:
--  * preview of the window
--  * can switch between minimized windows
-- adapted from: https://www.hammerspoon.org/docs/hs.window.switcher.html

-- set up windowfilter
-- include minimized/hidden windows, current Space only
switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter({}))

-- Other example options:
-- -- default windowfilter: only visible windows, all Spaces
-- switcher = hs.window.switcher.new()
--
-- specialized switcher for your dozens of browser windows
-- switcher_browsers = hs.window.switcher.new({ "Brave", "Safari", "Google Chrome" })

-- Adjust default window switcher UI
hs.window.switcher.ui.showTitles = false -- no titles on preview panes

-- bind to hotkeys; WARNING: at least one modifier key is required!
hs.hotkey.bind("alt", "tab", "Next window", function()
	switcher_space:next()
end)
hs.hotkey.bind("alt-shift", "tab", "Prev window", function()
	switcher_space:previous()
end)
```

Now with these key bindings I can quickly switch windows using `Alt + Tab` and
have previews! Try them out yourself. `Alt + Tab` will iterate through the
windows in order, and `Alt + Shift + Tab` will iterate through the windows in
reverse order.

---

## Bringing It All Together: Crafting a Powerful, Personalized Workflow

Up to this point, we’ve looked at individual tools and scripting techniques—Bash
basics, command-line utilities like `fzf` and `rg`, terminal multiplexing with
`tmux`, text manipulation with `sed` and `awk`, and system automation via
Hammerspoon. While each tool stands on its own, the true power emerges when
you combine them to fit the way you work.

**Imagine this scenario:** You’re working on a large codebase and need to
quickly find a function definition. Instead of manually poking around
directories, you can run a single command:

```bash

nvim $(rg "myFunctionName" --files-with-matches | fzf --preview="bat --color=always {}")
```

With this pipeline, you’ve integrated multiple tools at once:

- `rg` searches your codebase blazingly fast.
- `fzf` lets you quickly narrow down results interactively.
- `bat` provides syntax-highlighted previews as you navigate files.
- `nvim` opens the selected file immediately in your preferred editor.

Need to juggle multiple projects and keep different tasks compartmentalized?
Use `tmux-sessionizer` to jump into dedicated tmux sessions for each
directory you’re working in—no more manually cd’ing and setting up your
environment each time. Once inside `tmux`, you can split panes to run `htop`
and monitor processes on one side, while coding on the other. If you’re on
macOS, you can rearrange or tile your windows effortlessly with Hammerspoon
keybindings. Each tool handles a specific part of your workflow, and together
they create a frictionless environment where you move seamlessly between
searching, editing, monitoring, and organizing.

**In short:** The point of learning these tools and techniques isn’t just to
have a bag of fancy tricks. It’s about building a workflow that’s tailored to
your needs—reducing repetitive actions, speeding up navigation, and keeping
you focused on your real work rather than on the mechanics of your environment.
As you become comfortable with these tools, you’ll naturally discover even
more combinations, customizing your setup to become a personal productivity
powerhouse.

If there's any tool or script that you found particularly useful or interesting,
I recommend exploring it further and seeing how you can integrate it into your
workflow. And if you have a favorite tool or script that I didn't cover here,
feel free to share it in the comments!

## References and Resources

- [Unix Philosophy Wikipedia page](https://en.wikipedia.org/wiki/Unix_philosophy)
- [typescraft: This may be my favorite CLI tool ever](https://www.youtube.com/watch?v=oTNRvnQLLLs&list=WL&index=1)
- [Josean Martinez: 7 Amazing CLI Tools You Need To Try](https://www.youtube.com/watch?v=mmqDYw9C30I&t=248s)
- [Bash Scripting Tutorial: How to Write a Bash Script](https://linuxconfig.org/bash-scripting-tutorial)
- [Bash Scripting Tutorial for Beginners](https://www.youtube.com/watch?v=tK9Oc6AEnR4)
- [`fzf` GitHub Repository](https://github.com/junegunn/fzf)
- [`fzf.fish` GitHub Repository](https://github.com/PatrickF1/fzf.fish)
- [`ripgrep` GitHub Repository](https://github.com/BurntSushi/ripgrep)
