local M = {}

-- Set the autocmd which commits on save.
M.set_commit_autocmd = function()
  vim.cmd [[
  augroup commit_on_save
      autocmd!
      autocmd BufWritePost * lua require("git-scripts.utils").commit_on_save()
      autocmd BufEnter * lua require("git-scripts.utils").commit_warning()
  augroup END
  ]]
end

-- Asynchronous git commit when commit_on_save is enabled.
M.commit_on_save = function()
  if vim.g.__gitscripts_commit_on_save == true then
    require('git-scripts.functions').async_commit()
  end
end

M.commit_warning = function()
  if
    vim.g.__gitscripts_commit_on_save == true
    and vim.g.__gitscripts_warnings == true
    and vim.bo.buftype == ''
  then
    vim.cmd [[
    echohl WarningMsg
    echo "Warning: Commit on save is enabled. Use ':DisableCommit' to disable."
    echohl None
    ]]
  end
end

return M
