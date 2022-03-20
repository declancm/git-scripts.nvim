local M = {}

M.init = function()
  -- Check if user is on Windows.
  if vim.fn.has 'win32' == 1 then
    print "A unix system is required for 'git-scripts' :(. Have you tried using WSL?"
    vim.g.__gitscripts_failed = 1
  end
  -- Make the scripts executable.
  -- vim.cmd('!chmod +x ' .. vim.g.gitscripts_location .. '/*.sh')
end

M.setup = function(options)
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

  vim.g.__gitscripts_setup_completed = 1
end

M.git_commit = function(message)
  require('git-scripts.functions').git_commit(message)
end
M.git_pull = function()
  require('git-scripts.functions').git_pull()
end
M.async_commit = function(message, directory)
  require('git-scripts.functions').async_commit(message, directory)
end
M.async_pull = function(directory)
  require('git-scripts.functions').async_pull(directory)
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
