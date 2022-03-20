local M = {}

-- Set the autocmd which commits on save.
M.set_commit_autocmd = function(usingNightly)
  usingNightly = usingNightly or false

  -- NOTE: lua autocmds are a neovim nightly feature
  if usingNightly == true then
    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup

    autocmd('BufWritePost', {
      command = 'lua require("git-scripts.utils").commit_on_save()',
      group = augroup('auto_git_commit', {}),
    })
    autocmd('BufEnter', {
      callback = function()
        if
          vim.g.__gitscripts_commit_on_save == true
          and vim.g.__gitscripts_warnings == true
        then
          print "WARNING: Commit on save is enabled. Use ':DisableCommit' to disable."
        end
      end,
      group = augroup('auto_git_commit', {}),
    })
  else
    vim.cmd [[
    augroup auto_git_commit
        autocmd!
        autocmd BufWritePost * lua require("git-scripts.utils").commit_on_save()
        autocmd BufEnter * if g:__gitscripts_commit_on_save == v:true && g:__gitscripts_warnings == v:true
        \ | echom "WARNING: Commit on save is enabled. Use ':DisableCommit' to disable." | endif
    augroup END
    ]]
  end
end

-- Asynchronous git commit when commit_on_save is enabled.
M.commit_on_save = function()
  if vim.g.__gitscripts_commit_on_save == true then
    require('git-scripts.functions').async_commit()
  end
end

return M
