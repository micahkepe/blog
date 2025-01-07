+++
title = "Setting Up a Supercharged Neovim Configuration"
date = 2024-10-13
draft = false

[taxonomies]
categories = ["tools"]
tags = ["neovim", "lua", "vim", "productivity"]

[extra]
toc = true
+++

Over the summer, after finally getting around to learning Vim motions (see blog
post [#9](https://micahkepe.com/blog/vimtutor-sequel)), I quickly fell down the
Neovim rabbithole and have been procrastinating work by tinkering away at my
configurations ever since! This post will be sharing setup that I have currently
landed at to turn my Neovim editor into a supercharged workhorse.

<!-- more -->

# **TL;DR**

I think my setup is pretty sweet. If you want to try out my setup without having
to do the configuration yourself, you can run these commands to add my setup as a
"profile" that you can switch to in Neovim:

1.  Clone the repository and install plugins:

```bash

git clone git@github.com:micahkepe/dotfiles ~/.config/micahkepe/dotfiles
```

2.  Open Neovim with this configuration:

```bash

NVIM_APPNAME=micahkepe/dotfiles/nvim nvim
```

**If you're interested in the nerdy details of my setup, keep reading!**

{{ gif(sources=["demos/nvdash.mp4"]
width=80) }}

---

# What is Neovim Anyway?

Vim (short for Vi Improved) was created by Bram Moolenaar in 1991 as an enhanced
version of the Vi editor, which was originally developed in 1976 by Bill Joy for
Unix systems. Vim quickly became popular due to its efficiency and ability to
perform complex text manipulations with minimal keystrokes.

{{ responsive(src="early-vi.png",
alt="The original Vi program running with visuals.",
caption="The original Vi program running with 'visuals'", width=80) }}

However, Vim had its limitations, especially with handling modern development
features such as better plugin systems, scripting flexibility, and ease of
configuration. [Neovim](https://neovim.io/), a fork of Vim, was initiated in 2014
to address these challenges and provide a more modern, extensible framework.

Neovim differentiates itself by embracing the Lua programming language for
faster, more customizable configurations. This shift has given rise to a
flourishing ecosystem of plugins that are tailored to extend Neovim’s
capabilities—from file navigation and autocompletion to even embedding images
inside your text editor.

# Getting Started with Neovim

If you want to follow along with setup, you can install Neovim by following the
instructions below. If you already have Neovim installed, you can skip ahead to
[the setup](#the-setup).

To install Neovim, check the
[INSTALL.md](https://github.com/neovim/neovim/blob/master/INSTALL.md) file on
the Neovim repository for the instructions for your machine.

<br>

{{ responsive(src="neovim-logo.png", alt="Neovim logo") }}

<br>

# The Setup

First off, a confession. I am not using off the shelf Neovim but starting from
a very strong base configuration provided by the awesome folks at
[NVChad](https://nvchad.com/). NVChad is not a Neovim distro, but an opinionated
starting Neovim configuration that provides a great starting place.

I particularly like NVChad for the following reasons:

- **Pre-configured LSP**: NVChad provides a hassle-free Language Server Protocol
  ([LSP](https://microsoft.github.io/language-server-protocol/)) setup.

- **Lazy-loading Plugins**: With the [lazy.nvim](https://lazy.folke.io/) plugin
  manager, NVChad optimizes startup time by only loading plugins when necessary.

- **Rich Theming**: NVChad comes with lots of themes and color schemes to choose
  from (I am currently using
  [`palenight`](https://github.com/drewtempelmeyer/palenight.vim)).

- **Community Support**: NVChad’s [community](https://discord.com/invite/gADmkJb9Fb)
  is active, and the configuration gets frequent updates and improvements.

<br>

{{ responsive(src="nvchad-logo.png", alt="NVChad logo", width=40) }}

If you are following along, let's first install NVChad before we continue:

**For Mac and Linux Users**:

```bash

git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
```

**Windows Users**:

A little more complicated (as usual), check out the install documentation
[here](https://nvchad.com/docs/quickstart/install)

## Changes to NVChad's Default Settings

### Diagnostics Menu

One of the things I changed from NVChad was the diagnostics display. By default,
NVChad has the diagnostics displayed inline in red text. One consequence of this
is that long diagnostic messages do not wrap at the end of the buffer, making it
difficult to read the entire message:

{{ responsive(
    src="default-diagnostics.png",
    width=80, alt="Diagnostics display in red text",
    caption="NvChad default diagnostics"
) }}

To make the diagnostics more readable and "Visual-Studio-Code-like", I changed
the diagnostics to underline the offending line and display to a floating window
at the offending line on a cursor hold:

{{ responsive(
    src="new-diagnostics-ex1.png",
    alt="Diagnostics display in a floating window on the screen"
) }}

<br>

{{ responsive(
    src="new-diagnostics-ex2.png",
    alt="Diagnostics display in a floating window at the bottom of the screen"
) }}

To do this, I created a separate file for the diagnostics configuration in
`nvim/lua/configs/diagnostics.lua`:

```lua

-- nvim/lua/configs/diagnostics.lua
local M = {}

M.setup = function()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false, -- no inline diagnostics
    underline = true, -- underline problematic code
  })

  -- Set the update time for diagnostics
  vim.o.updatetime = 250

  -- Automatically show diagnostics on cursor hold
  vim.cmd [[
    autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus = false })
  ]]
end

return M
```

Then to load this configuration, I added the following lines to the top of my
`nvim/lua/configs/lspconfig.lua`:

```lua

-- nvim/lua/configs/lspconfig.lua
local diagnostics = require "configs.diagnostics"

-- Diagnostics popup
diagnostics.setup()
```

### Enable Hidden Files in `nvim-tree` Display

Another change I made was to show hidden files in the `nvim-tree` file explorer.
By default, hidden files are not displayed in the file explorer, which can be a
little annoying when you need to access a `.gitignore`, configuration files, or
a `.env` file, for example.

To do this, I altered the section in the `nvim/lua/init.lua` file that loads
NvChad's defined plugins:

```lua

-- nvim/lua/init.lua
-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
      -- Override nvim-tree settings
      local nvim_tree_options = require "nvchad.configs.nvimtree"
      nvim_tree_options.filters.dotfiles = false
      nvim_tree_options.git = { enable = true }
      nvim_tree_options.filters.git_ignored = false
      nvim_tree_options.filters.custom = { "^\\.git$", "DS_Store" }
    end,
  },

  { import = "plugins" },
}, lazy_config)
```

In the `nvim_tree_options.filters.custom` table above, I added `"^\\.git$"` and
`"DS_Store"` regular expressions to not display files from the `.git/` folder,
and to ignore the `.DS_Store` files that macOS creates, respectively.

---

## Plugins

I won't be detailing every plugin that I use, but instead the ones that have
become staples in my editing experience. All plugins snippets that follow will
be using `lazy.nvim` install configurations. I will break this section into the
plugins that come by default from NVChad and the plugins that I have added on.

> **Note:** If you are curious about all of my plugins, you can see them
> [here](https://github.com/micahkepe/dotfiles/tree/main/nvim/lua/plugins).

<br>

### NVChad Plugins

NVChad comes with a carefully curated set of plugins that provide a solid
foundation for your Neovim setup. Here are some of the key plugins included:

1. [**nvim-tree/nvim-tree.lua**](https://github.com/nvim-tree/nvim-tree.lua): A
   file explorer tree for Neovim written in Lua. It provides a sleek and
   customizable way to navigate your project files.

2. [**nvim-treesitter/nvim-treesitter**](https://github.com/nvim-treesitter/nvim-treesitter):
   Treesitter configurations and abstraction layer for Neovim. It provides better
   syntax highlighting and code understanding.

3. [**lewis6991/gitsigns.nvim**](https://github.com/lewis6991/gitsigns.nvim):
   Git integration for buffers. It shows which lines have been added, removed, or
   modified in the gutter.

4. [**hrsh7th/nvim-cmp**](https://github.com/hrsh7th/nvim-cmp): A completion
   plugin for Neovim coded in Lua. It provides autocompletion functionality similar
   to what you'd find in modern IDEs.

5. [**williamboman/mason.nvim**](https://github.com/williamboman/mason.nvim):
   Portable package manager for Neovim that runs everywhere Neovim runs. Easily
   install and manage LSP servers, [DAP](https://microsoft.github.io/debug-adapter-protocol/)
   debugger servers, linters, and formatters.

6. [**neovim/nvim-lspconfig**](https://github.com/neovim/nvim-lspconfig): A
   collection of common configurations for Neovim's built-in LSP client.

7. [**folke/which-key.nvim**](https://github.com/folke/which-key.nvim): Displays
   a popup with possible key bindings of the command you started typing.
   Incredibly useful for discovering and remembering mappings.

8. [**nvim-telescope/telescope.nvim**](https://github.com/nvim-telescope/telescope.nvim):
   A highly extendable fuzzy finder over lists. It helps you search, filter, find,
   and pick things in your Neovim setup.

These plugins work together to provide a fully-featured IDE-like experience
right out of the box. NVChad's setup ensures that these plugins are configured
to work well together, providing a smooth and cohesive editing experience.

{{ gif(sources=["demos/nvchad-demo.mp4"], width=80)}}

<br>

### Added Plugins "Musts"

In no particular order, here are the plugins that I have added to augment
NVChad's base.

#### [`gelguy/wilder.nvim`](https://github.com/gelguy/wilder.nvim)

{{ gif(sources=["demos/wilder-cmds.mp4"], width=80)}}

Makes navigating the Neovim command line much faster with fuzzy search
capabilities, providing instant suggestions as you type commands.

When executing a command or searching, `wilder.nvim` offers a real-time list of
suggestions based on your command history, file paths, and available commands.
This dramatically speeds up workflows that involve repeated or complex command
usage.

**lazy.nvim**:

```lua

-- nvim/lua/plugins/wilder.nvim

return {
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local wilder = require "wilder"
      wilder.setup { modes = { ":", "/", "?" } }
      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.python_file_finder_pipeline {
            file_command = function(_, arg)
              if string.find(arg, ".") ~= nil then
                return { "fd", "-tf", "-H" }
              else
                return { "fd", "-tf" }
              end
            end,
            dir_command = { "fd", "-td" },
            filters = { "fuzzy_filter", "difflib_sorter" },
          },
          wilder.cmdline_pipeline(),
          wilder.python_search_pipeline()
        ),
      })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer {
          highlighter = wilder.basic_highlighter(),
          left = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar { thumb_char = " " } },
          highlights = {
            default = "WilderMenu",
            accent = wilder.make_hl("WilderAccent", "Pmenu", {
              { a = 1 },
              { a = 1 },
              { foreground = "#f4468f" },
            }),
          },
        }
      )
    end,
  },
}
```

#### [`3rd/image.nvim`](https://github.com/3rd/image.nvim)

{{ gif(sources=["demos/image-nvim.mp4"], width=80)}}

Enables image rendering in Neovim, essential for tasks like markdown previews
and documentation editing. When editing markdown files or any other file format
that supports images, image.nvim renders inline images. This eliminates the need
to switch to a browser or other external tool, making Neovim more than just a
text editor—it's a media-enabled workspace.

Honestly this one was a pain in the ass to setup but worth it.

I did have to make the switch to the [Kitty](https://sw.kovidgoyal.net/kitty/)
terminal emulator from [iTerm2](https://iterm2.com/index.html) as they implement
different terminal image protocols (`kitty` vs. `imgcat`) and Kitty's protocol
has more support as of writing. Additionally, getting the right Luarocks
version (5.1) is a little tricky as it is an older version of Luarocks.

Honestly, I needed images in Neovim in order to even consider making the switch
from Visual Studio Code, so getting this plugin working was a non-negotiable for
me.

> **Note:** This particular configuration of the plugin must be run in Kitty to
> work. See the `backend` option if you want to use a different emulator.

**lazy.nvim**:

```lua

-- nvim/lua/plugins/image-nvim.lua

-- For dependencies see
-- `~/github/dotfiles-latest/neovim/nvim-lazyvim/README.md`
--
-- -- Uncomment the following 2 lines if you use the local luarocks installation
-- -- Leave them commented to instead use `luarocks.nvim`
-- -- instead of luarocks.nvim
-- Notice that in the following 2 commands I'm using luaver
-- package.path = package.path
--   .. ";"
--   .. vim.fn.expand("$HOME")
--   .. "/.luaver/luarocks/3.11.0_5.1/share/lua/5.1/magick/?/init.lua"
-- package.path = package.path
--   .. ";"
--   .. vim.fn.expand("$HOME")
--   .. "/.luaver/luarocks/3.11.0_5.1/share/lua/5.1/magick/?.lua"
--
-- -- Here I'm not using luaver, but instead installed lua and luarocks directly through
-- -- homebrew
package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?.lua"

return {
  {
    -- luarocks.nvim is a Neovim plugin designed to streamline the installation
    -- of luarocks packages directly within Neovim. It simplifies the process
    -- of managing Lua dependencies, ensuring a hassle-free experience for
    -- Neovim users.
    -- https://github.com/vhyrro/luarocks.nvim
    "vhyrro/luarocks.nvim",
    -- this plugin needs to run before anything else
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    lazy = false, -- load on start up
    dependencies = { "luarocks.nvim" },
    config = function()
      require("image").setup {
        backend = "kitty",
        kitty_method = "normal",
        integrations = {
          -- Notice these are the settings for markdown files
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            -- Set this to false if you don't want to render images coming from
            -- a URL
            download_remote_images = true,
            -- Change this if you would only like to render the image where the
            -- cursor is at
            -- I set this to true, because if the file has way too many images
            -- it will be laggy and will take time for the initial load
            only_render_image_at_cursor = true,
            -- markdown extensions (ie. quarto) can go here
            filetypes = { "markdown", "vimwiki" },
          },
          neorg = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "norg" },
          },
          -- This is disabled by default
          -- Detect and render images referenced in HTML files
          -- Make sure you have an html treesitter parser installed
          -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
          html = {
            enabled = false,
          },
          -- This is disabled by default
          -- Detect and render images referenced in CSS files
          -- Make sure you have a css treesitter parser installed
          -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
          css = {
            enabled = true,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,

        -- This is what I changed to make my images look smaller, like a
        -- thumbnail, the default value is 50
        -- max_height_window_percentage = 20,
        max_height_window_percentage = 40,

        -- toggles images when windows are overlapped
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

        -- auto show/hide images when the editor gains/looses focus
        editor_only_render_when_focused = true,

        -- auto show/hide images in the correct tmux window
        -- In the tmux.conf add `set -g visual-activity off`
        tmux_show_only_in_active_window = true,

        -- render image files as images when opened
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      }
    end,
  },
}
```

<br>

#### [`rmagatti/autosession`](https://github.com/rmagatti/auto-session)

{{ gif(sources=["demos/autosession.mp4"], width=80)}}

Automatically saves and restores Neovim sessions, allowing you to pick up your
work right where you left off. If you close Neovim and reopen it later,
`autosession` will restore your previous session (open files, split windows,
etc.). This is incredibly useful when you are juggling multiple projects and
want to resume exactly where you left off.

**lazy.nvim**:

```lua

-- automatically creates a Vim session when Neovim opens for saving work
return {
  "rmagatti/auto-session",
  lazy = false,
  config = function()
    local auto_session = require "auto-session"
    auto_session.setup {
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    }
  end,
}
```

Then I define these mappings to save and restore sessions:

```lua

-- nvim/lua/mappings.lua

-- Autosession mappings
map("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
map("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
```

<br>

#### [`christoomey/vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator)

{{ gif(sources=["demos/navigator.mp4"], width=80)}}

Enables smooth navigation between Neovim windows and
[tmux](https://github.com/tmux/tmux/wiki) panes, making it feel like a unified
experience. If you’re using tmux and Neovim together,`vim-tmux-navigator` allows
you to navigate between tmux panes and Neovim splits using the same keybindings
(like `<C-h>`,`<C-j>`, `<C-k>`, and `<C-l>`). This makes my workflow more fluid
as I don't have to think about whether I'm moving inside Neovim or across Tmux.
Not to mention I find this bindings much less awkward than the default `<C-w>`
Vim windown motions.

The true value of this plugins comes when you are working in various tmux panes
running a combination of Neovim, a shell, and other tools. Without thinking I
can navigate between these panes with ease.

**lazy.nvim**:

```lua

  {
    "christoomey/vim-tmux-navigator",
    lazy = false, -- load on start up to immediately enable
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate left" },
      { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate down" },
      { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate up" },
      { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate right" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate previous" },
    },
  },
```

> **Note:** If using NVChad, you will need to override its mapping of these keys
> to use the Tmux navigation commands instead:
>
> ```lua
>
> -- nvim/lua/options.lua
> require "nvchad.mappings"
>
> local map = vim.keymap.set
>
> -- override nvchad mappings for window navigation so I can use them for
> -- vim-tmux-navigator
> map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
> map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down" })
> map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up" })
> map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right" })
> map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Navigate previous" })
>
> ```

If using tmux, add the following to your `~/.tmux.conf`:

```bash

# ~/.tmux.conf
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
bind -n 'C-h' if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n 'C-j' if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n 'C-k' if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n 'C-l' if-shell "$is_vim" "send-keys C-l" "select-pane -R"
bind -n 'C-\' if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l

# Enable passthrough for panes
set -g allow-passthrough on
```

#### [`pocco81/auto-save.nvim`](https://github.com/pocco81/auto-save.nvim)

Automatically saves your files when you leave insert mode. This plugin is a
lifesaver for those who forget to save their work frequently. It ensures that
your changes are always saved, even if you forget to do so manually. It is also
highly customizable, allowing you to configure the save interval and other
settings to suit your workflow.

**lazy.nvim**:

```lua

-- nvim/lua/plugins/init.lua
{
"pocco81/auto-save.nvim",
lazy = false,
config = function()
  require("auto-save").setup {}
end,
},
```

#### [`stevearc/dressing.nvim`](https://github.com/stevearc/dressing.nvim)

{{ responsive(src="dressing.png", alt="Dressing.nvim plugin in action") }}

This plugins provides way better styling to the default `vim.ui` interfaces. The
biggest improvement in my opinion is over the `vim.input` interface that is used
for renaming files in `nvim-tree` and renaming variable definitions using
NvChad's renamer. This is another highly customizable plugin that allows you to
style the UI to your liking.

**lazy.nvim**:

```lua

-- nvim/lua/plugins/init.lua
{ "stevearc/dressing.nvim", event = "VeryLazy" },
```

<br>

## **Key Mappings**

Similarly, I have a ton of mappings that I have defined so I will just be going
over the ones that I can't live without. Additionally, I will not be detailing
the mappings that come with the NVChad base configuration (NVChad users can view
these by doing `<leader>ch` to pull up the mappings cheat sheet).

### Quality of Life Remaps

```lua

-- nvim/lua/mappings.lua
require "nvchad.mappings" -- NVChad-defined mappings

local map = vim.keymap.set

-- Quickly exit Normal mode with `jk`
-- This makes the transition from typing to command mode faster and more comfortable for the fingers.
-- UPDATE: I disabled this and instead just use Karabiner to map capslock to ESC
-- map("i", "jk", "<ESC>")

-- Map <C-s> to save
-- This is a common shortcut in many editors, bringing familiarity from other tools like VSCode.
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
```

### "Reveal in Finder" Dupe

One of the things that I was missing coming from Visual Studio Code was the
option in the file explorer to "Reveal in Finder" so I created a simple Vim user
command that allows me to open a file under in my cursor in a Finder window
either from the open file buffer or from the file explorer sidebar.

{{ gif(sources=["demos/finder.mp4"], width=80)}}

```lua

-- Open file in default viewer
vim.api.nvim_create_user_command("OpenFileInViewer", function()
  local current_file = vim.fn.expand "%:p"
  vim.fn.system('open "' .. current_file .. '"')
end, {})

-- Map <leader>sv to open file in standard viewer
-- NOTE: if cursor is on the file name Nvim Tree, you can simply press `sv` to open the file in the default viewer
-- since the leader key is already used by Nvim Tree.
map("n", "<leader>sv", ":OpenFileInViewer<CR>", { noremap = true, silent = true, desc = "Open file in default viewer" })
```

### Window Management

These mappings manage window splits and layout efficiently in Neovim. The `desc`
key provides a description of the mapping for use in command help or plugins
like `which-key.nvim`.

```lua

map("n", "<leader>v", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sd", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" }) -- equalize split layouts
-- can't use <leader>sh since that is used by LSPs to signature help
map("n", "<leader>s", "<cmd>split<CR>", { desc = "Split window horizontally" }) -- split window horizobtally
```

### Visually Appealing Scrolling and Searching

These mappings keep the cursor and search result centered in the window while
scrolling or jumping to search results.

```lua

-- maintain visual context on page navigation and searching
map("n", "<C-d>", "<C-d>zz") -- Keeps cursor centered when going down the page
map("n", "<C-u>", "<C-u>zz") -- Keeps cursor centered when going up the page
map("n", "n", "nzzzv") -- Keeps the search result in the center after jumping to next result
map("n", "N", "Nzzzv") -- Keeps the search result in the center after jumping to previous result
```

### GitSigns Mappings

These are the mappings I use for GitSigns, which I believe are fairly standard.
`gitsigns` works in "hunks" of code, hence all of these mappings begin with an
`h` after the leader.

{{ gif(sources=["demos/gitsigns.mp4"], width=80)}}

```lua

map("n", "<leader>hn", "<cmd>lua require'gitsigns'.next_hunk()<CR>", { desc = "Next hunk" })
map("n", "<leader>hp", "<cmd>lua require'gitsigns'.prev_hunk()<CR>", { desc = "Previous hunk" })
map("n", "<leader>hs", "<cmd>lua require'gitsigns'.stage_hunk()<CR>", { desc = "Stage hunk" })
map("n", "<leader>hu", "<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>", { desc = "Undo stage hunk" })
map("n", "<leader>hr", "<cmd>lua require'gitsigns'.reset_hunk()<CR>", { desc = "Reset hunk" })
map("n", "<leader>hR", "<cmd>lua require'gitsigns'.reset_buffer()<CR>", { desc = "Reset buffer" })
map("n", "<leader>hp", "<cmd>lua require'gitsigns'.preview_hunk()<CR>", { desc = "Preview hunk" })
map("n", "<leader>hb", "<cmd>lua require'gitsigns'.blame_line()<CR>", { desc = "Blame line" })
map("n", "<leader>hS", "<cmd>lua require'gitsigns'.stage_buffer()<CR>", { desc = "Stage buffer" })
map("n", "<leader>hU", "<cmd>lua require'gitsigns'.reset_buffer_index()<CR>", { desc = "Reset buffer index" })
```

<br>

## **Options**

These options provide a basic, yet highly functional configuration for Neovim
that enhances usability by enabling features like clipboard integration and
better search behavior.

```lua

-- nvim/lua/options.lua

require "nvchad.options"

local o = vim.o
local opt = vim.opt

-- Cursorline
o.cursorlineopt = "both" -- to enable cursorline!

-- Make line numbers defaults
o.number = true

-- Search and replace
opt.ignorecase = true -- ignore case letters when searching
opt.smartcase = true -- match case if capital letter is present
opt.incsearch = true -- show search matches as you type
opt.inccommand = "split" -- show live preview of substitute commands

-- disable swapfile
opt.swapfile = false

-- clipboard
opt.clipboard:append "unnamedplus"

-- text wrapping
o.wrap = false
```

# Conclusion

While transitioning from VSCode to Neovim wasn’t without its challenges—
especially getting used to Vim motions and configuring the plugins to my
liking—it has ultimately made my workflow faster and more enjoyable. I
particularly appreciated how customizable Neovim is; I can tailor it exactly to
my needs, unlike most GUI-based editors.

It took me about a month to feel completely comfortable using Neovim, but once
the muscle memory kicks in, you start to realize the immense productivity boost.
If you’re on the fence, I highly recommend giving Neovim a chance for at least a
few weeks.

If you have any questions about my setup, want to share your own tips and tricks,
or just want to chat about Neovim, feel free to write in the comments below!

## References

- [Understanding the Origins and the Evolution of Vi & Vim](https://pikuma.com/blog/origins-of-vim-text-editor)
- [How I Setup Neovim On My Mac To Make it AMAZING in 2024](https://www.josean.com/posts/how-to-setup-neovim-2024)
- [NVChad Documentation](https://nvchad.com/docs/quickstart/install)
- [An Experienced (Neo)Vimmer's Workflow.](https://seniormars.com/posts/neovim-workflow/)

{{ utterances() }}
