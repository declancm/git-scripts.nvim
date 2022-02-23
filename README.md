# git-scripts-nvim

Automated git commit and git pull keymaps. Optional asynchronous git commit on save.
A message is generated for the commit which has the date and time (in UTC format).

_Note: Look at the commits for this repo to see the plugin in action._

## Installation

Install with your favorite package manager. Plenary is required.

### Packer

```lua
use {
  "declancm/git-scripts-vim",
  requires = "nvim-lua/plenary.nvim",
}
```

## Usage

To activate automatic asynchronous git commiting on save for every vim session, set:

```lua
vim.g.commit_on_save = 1
```

This will push a git commit with a generated message containing the current date\
and time (in UTC format), every time the buffer is saved while changes exist. This\
occurs asynchronously in the background for maximum convenience.

### Default Keymaps

```lua
local opts = { noremap = true, silent = true }

-- Git commit and push with full error information on failure.
vim.api.nvim_set_keymap('n', '<leader>gc', '<Cmd>lua require("git-scripts").git_commit()<CR>', opts)

-- Git pull with full error information on failure.
vim.api.nvim_set_keymap('n', '<leader>gp', '<Cmd>lua require("git-scripts").git_pull()<CR>', opts)

-- Git commit and push asynchronously. Displays an error message on failure.
vim.api.nvim_set_keymap('n', '<leader>ac', '<Cmd>lua require("git-scripts").async_commit()<CR>', opts)

-- Git pull asynchronously. Displays an error message on failure.
vim.api.nvim_set_keymap('n', '<leader>ap', '<Cmd>lua require("git-scripts").async_pull()<CR>', opts)

-- Activates git commit and push asynchronously when buffer is saved for only the current session.
vim.api.nvim_set_keymap('n', '<leader>aac', '<Cmd>lua require("git-scripts").auto_commit()<CR>', opts)
```

To disable the default keyamps, set:

```lua
vim.g.gitscripts_no_defaults = 1
```
