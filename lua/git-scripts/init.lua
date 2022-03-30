local M = {}

local utils = require 'git-scripts.utils'

M.setup = function(options)
  vim.g.__gitscripts_setup_completed = 1

  -- Check if user is on Windows.
  if vim.fn.has 'win32' == 1 then
    utils.error_msg "A unix system is required for 'git-scripts' :(. Have you tried using WSL?"
    return
  end

  -- Set the options:
  if options == nil then
    options = {}
  end

  local defaults = {
    default_keymaps = true,
    commit_on_save = false,
    warnings = true,
  }

  for key, value in pairs(defaults) do
    if options[key] == nil then
      options[key] = value
    end
  end

  -- If vim variables were set manually, assign them to the options table.
  if vim.g.gitscripts_no_defaults == 1 then
    options['default_keymaps'] = false
  end
  if vim.g.commit_on_save == 1 then
    options['commit_on_save'] = true
  end
  if vim.g.gitscripts_no_warnings == 1 then
    options['warnings'] = false
  end

  -- Setting variables:
  vim.g.__gitscripts_warnings = options.warnings
  vim.g.__gitscripts_commit_on_save = options.commit_on_save

  -- Default keymaps:
  if options.default_keymaps == true then
    local keymap = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    keymap(
      'n',
      '<Leader>gc',
      "<Cmd>lua require('git-scripts').async_commit()<CR>",
      opts
    )
    keymap(
      'n',
      '<Leader>gp',
      "<Cmd>lua require('git-scripts').async_pull()<CR>",
      opts
    )
    keymap(
      'n',
      '<Leader>tac',
      "<Cmd>lua require('git-scripts').toggle_auto_commit()<CR>",
      opts
    )
  end

  -- Activating commit on save:
  if options.commit_on_save == true then
    require('git-scripts.utils').set_commit_autocmd()
  end
end

M.git_commit = function(...)
  require('git-scripts.functions').git_commit(...)
end
M.git_pull = function()
  require('git-scripts.functions').git_pull()
end
M.async_commit = function(...)
  require('git-scripts.functions').async_commit(...)
end
M.async_pull = function(...)
  require('git-scripts.functions').async_pull(...)
end
M.toggle_auto_commit = function()
  require('git-scripts.functions').toggle_auto_commit()
end
M.enable_auto_commit = function()
  require('git-scripts.functions').enable_auto_commit()
end
M.disable_auto_commit = function()
  require('git-scripts.functions').disable_auto_commit()
end

return M
