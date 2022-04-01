# git-scripts.nvim 📜

## Features

### Automated Async Commit

✨ __Look at the commits for this repo to see the automated commit in action.__ ✨

The async commit is extremely effortless and can be very useful for quick
commits to your repositories (such as a '.dotfiles' repo), because time is money
💵.

### Automated Async Pull

The async pull is very versatile and can be setup in your config for any
directory to ensure you are always up-to-date.

```vim
" Pull on entry to a specific repository:
autocmd BufEnter <example_repo_path>/** lua require('git-scripts').async_pull('<example_repo_path>')

" Pull on entry to every repository:
autocmd BufEnter * lua require('git-scripts').async_pull(expand('%:p:h'))

" Pull on nvim entry:
autocmd VimEnter * lua require('git-scripts').async_pull()
```

### Commit-On-Save

Take the auto commits a step further and use the 'commit-on-save' feature to get
the completely automated experience 🤖.

## Installation

Install with your favorite package manager. Plenary is needed for the
asynchronous functions and the Bash unix shell is needed for running the shell
scripts.

### Packer

```lua
use {
  'declancm/git-scripts.nvim',
  requires = 'nvim-lua/plenary.nvim',
}
```

## Usage

### Functions List

```lua
-- Function Arguments

-- message:     The commit message that will be used. The default value is:
--              "Auto Commit: " .. os.date('!%b %d %H:%M:%S %Y') .. " UTC".
--              An empty string ('') input will use the default value.

-- directory:   The path for the directory in which the git commands will be
--              executed. The default value is the current working directory.

-- Git commit and push with full error information on failure.
require("git-scripts").git_commit(message)

-- Git pull with full error information on failure.
require("git-scripts").git_pull()

-- Git commit and push asynchronously. Notify on failure. Error details are written to a log file.
require("git-scripts").async_commit(message, directory)

-- Git pull asynchronously. Notify on failure. Error details are written to a log file.
require("git-scripts").async_pull(directory)

-- Toggle automatic asynchronous commit on save.
require("git-scripts").toggle_auto_commit()

-- Enable automatic asynchronous commit on save.
require("git-scripts").enable_auto_commit()

-- Disable automatic asynchronous commit on save.
require("git-scripts").disable_auto_commit()
```

### Options

```lua
-- Default options:
require('git-scripts').setup() {
  default_keymaps = true, -- Use default keymaps.
  commit_on_save = false, -- Automatically commit when saving the current buffer.
  warnings = true,   -- Display a warning on buffer entry when commit-on-save is active.
  remove_log = true, -- Delete the log file from cache when entering or exiting nvim.
}
```

### Default Keymaps

```lua
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>gc', '<Cmd>lua require("git-scripts").async_commit()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gp', '<Cmd>lua require("git-scripts").async_pull()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tac', '<Cmd>lua require("git-scripts").toggle_auto_commit()<CR>', opts)
```

### Commit On Save

This will push a git commit with a generated message containing the current date
and time in UTC format, every time the buffer is saved while changes exist.
This occurs asynchronously in the background for maximum convenience.

To disable commit on save for the current session, either use the
default keymap `<leader>tac` to toggle, or enter the command `:DisableCommit`.
