local M = {}

M.init = function(scripts_location)
  M.scripts_location = scripts_location
end

M.setup = function(options)
  vim.g.__gitscripts_setup_loaded = 1

  -- Check if user is on Windows.
  if vim.fn.has('win32') == 1 then
    require('git-scripts.utils').error_msg(
      "A unix system is required for 'git-scripts'. Have you tried using WSL?"
    )
    return
  end

  -- Set the options:
  local defaults = {
    default_keymaps = true,
    commit_on_save = false,
    warnings = true,
    remove_log = true,
  }
  if options == nil then
    options = defaults
  else
    for key, value in pairs(defaults) do
      if options[key] == nil then
        options[key] = value
      end
    end
  end

  M.options = options

  -- If vim variables were set manually, assign them to the options table.
  if vim.g.gitscripts_no_defaults == 1 then
    options.default_keymaps = false
  end
  if vim.g.commit_on_save == 1 then
    options.commit_on_save = true
  end
  if vim.g.gitscripts_no_warnings == 1 then
    options.warnings = false
  end

  -- Delete log file from cache.
  if defaults.remove_log then
    vim.cmd([[
    aug gitscripts_log
    au!
    au VimEnter * call delete(getenv('HOME') . '/.cache/nvim/git-scripts.log')
    au VimLeave * call delete(getenv('HOME') . '/.cache/nvim/git-scripts.log')
    aug END
    ]])
  end

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
