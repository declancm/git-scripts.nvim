if vim.g.__gitscripts_loaded then
  return
end
vim.g.__gitscripts_loaded = true

require('git-scripts').init(
  vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('<sfile>')), ':p:h:h')
    .. '/scripts'
)

if not vim.g.__gitscripts_setup_loaded then
  require('git-scripts').setup()
end

vim.cmd([[
command! DisableCommit lua require("git-scripts.functions").disable_auto_commit()
command! GitLog edit ~/.cache/nvim/git-scripts.log
]])
