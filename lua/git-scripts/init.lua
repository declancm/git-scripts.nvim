local M = {}

M.init = function()
  -- Check if user is on Windows.
  if vim.fn.has 'win32' == 1 then
    print "A unix system is required for 'git_scripts' :(. Have you tried using WSL?"
  end
  -- Make the scripts executable.
  -- vim.cmd('!chmod +x ' .. vim.g.gitscripts_location .. '/*.sh')
end

M.setup = function(options)
  if options == nil then
    options = {}
  end

  local defaults = {
    commit_on_save = false,
    default_keymaps = true,
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

  -- print(vim.inspect(options))

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

  if options.commit_on_save == true then
    vim.g.commit_on_save = 1

    -- NOTE: lua autocmds are a neovim nightly feature
    -- local autocmd = vim.api.nvim_create_autocmd
    -- local augroup = vim.api.nvim_create_augroup
    -- autocmd('BufWritePost', {
    --   command = 'lua require("git-scripts").autocmd_commit()',
    --   group = augroup('auto_git_commit', {}),
    -- })
    -- autocmd('BufEnter', {
    --   callback = function()
    --     if vim.g.commit_on_save == 1 and vim.g.commit_no_warnings == 0 then
    --       print "WARNING: Commit on save is enabled. Use ':DisableCommit' to disable."
    --     end
    --   end,
    --   group = augroup('auto_git_commit', {}),
    -- })

    vim.cmd [[
    augroup auto_git_commit
        autocmd!
        autocmd BufWritePost * lua require("git-scripts").autocmd_commit()
        autocmd BufEnter * if g:commit_on_save == 1 && g:commit_no_warnings != 1
                    \ | echom "WARNING: Commit on save is enabled. Use ':DisableCommit' to disable." | endif
    augroup END
    ]]
  end

  if options.warnings == false then
    vim.g.commit_no_warnings = 1
  end

  vim.g.gitscripts_setup_completed = 1
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
