# git-scripts-nvim

Automated git commit and git pull keymaps. Optional asynchronous git commit on\
save. A message is generated for the commit which has the date and time in UTC\
format.

__Note: Look at the commits for this repo to see the plugin in action.__

## Installation

Install with your favorite package manager. Plenary is needed for the\
asynchronous functions.

### Packer

```lua
use {
  'declancm/git-scripts.nvim',
  requires = 'nvim-lua/plenary.nvim',
}
```

### Vim-Plug

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'declancm/git-scripts.nvim'
```

## Usage

### Functions List

```lua
local scripts = require("git-scripts")

-- Git commit and push with full error information on failure.
scripts.git_commit()

-- Git pull with full error information on failure.
scripts.git_pull()

-- Git commit and push asynchronously. Notify on failure.
scripts.async_commit()

-- Git pull asynchronously. Notify on failure.
scripts.async_pull()

-- Toggle automatic asynchronous commit on save.
scripts.toggle_auto_commit()

-- Enable automatic asynchronous commit on save.
scripts.enable_auto_commit()

-- Disable automatic asynchronous commit on save.
scripts.disable_auto_commit()
```

### Default Keymaps

```lua
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>gc', '<Cmd>lua require("git-scripts").async_commit()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gp', '<Cmd>lua require("git-scripts").async_pull()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tac', '<Cmd>lua require("git-scripts").toggle_auto_commit()<CR>', opts)
```

To disable the default keyamps, add to your vimrc:

```lua
-- init.lua
vim.g.gitscripts_no_defaults = 1
```

```vim
" init.vim
let g:gitscripts_no_defaults = 1
```

### Commit On Save

To enable automatic asynchronous git commiting on save for every vim session,
add to your vimrc:

```lua
-- init.lua
vim.g.commit_on_save = 1
-- To disable the 'commit on save enabled' warning shown on buffer entry:
vim.g.commit_no_warnings = 1
```

```vim
" init.vim
let g:commit_on_save = 1
" To disable the 'commit on save enabled' warning shown on buffer entry:
let g:commit_no_warnings = 1
```

This will push a git commit with a generated message containing the current date\
and time in UTC format, every time the buffer is saved while changes exist.\
This occurs asynchronously in the background for maximum convenience.

To disable for the current session, either use the default keymap `<leader>tac`\
 to toggle, or enter the command `:DisableCommit`.
