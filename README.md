# git-scripts-nvim

Asynchronously automatically git commit/push and git pull.

This plugin is a neovim integration of my git-scripts repo. The scripts will be\
installed at `~/git-scripts`, unless a custom location is chosen.

## Installation

Install with your favorite package manager.

### Packer

```lua
use {
  "declancm/git-scripts-vim",
  requires = "nvim-lua/plenary.nvim",
}
```

## Usage

### Commands

- `:Commit` - automated git commit and push which generates a commit message with\
  the current date and time in UTC format.
- `:Pull` - automated git pull.
- `:CommitS` - a silent version of `:Commit` which doesn't generate an output except\
  when errors occur.
- `:PullS` - a silent version of `:Pull` which doesn't generate an output except\
  when errors occur.
- `:AutoCommit` - activate git commiting on save within the current active vim session.

To activate automatic git commiting on save for every vim session:

```lua
-- Automatic commit on save:
vim.g.commit_on_save = 1
```

### Default Mappings

- `<leader>gc`\
  Equivalent to using the `:Commit` command.
- `<leader>gp`\
  Equivalent to using the `:Pull` command.
- `<leader>gac`\
  Equivalent to using the `:AutoCommit` command.

### Custom Mappings

First disable the default mappings:

```lua
-- No git-scripts-nvim default keymaps
vim.g.gitscripts_no_defaults = 1
```

Then add your keymaps:

```lua
local opts = { nnoremap = true, silent = true }

-- Asynchronously git commit.
vim.api.nvim_set_keymap("n", "<leader>gc", ":AsyncCommit<CR>", opts)

-- Asynchronously git pull.
vim.api.nvim_set_keymap("n", "<leader>gp", ":AsyncPull<CR>", opts)

-- Automatic asynchronous commit on save.
vim.api.nvim_set_keymap("n", "<leader>gac", ":AutoAsyncCommit<CR>", opts)
```

Source your config file and restart vim for the changes to take effect.

### Custom Git-Scripts Location

By default, `https://github.com/git-scripts.git` is cloned at `~/git-scripts`.\
This can be customized by setting the variable `g:gitscripts_location`:

```lua
vim.g.gitscripts_location = "~/.config/nvim/git-scripts"
```
