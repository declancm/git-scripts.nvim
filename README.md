# git-scripts-nvim

Automated git commit and git pull keymaps. Optional asynchronous git commit on save.

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

-- Activates git commit and push asynchronously when buffer is saved for current session.
vim.api.nvim_set_keymap('n', '<leader>aac', '<Cmd>lua require("git-scripts").auto_commit()<CR>', opts)
```

To disable the default keyamps, set:

```lua
vim.g.gitscripts_no_defaults = 1
```
