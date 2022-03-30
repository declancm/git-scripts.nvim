local M = {}

M.error_msg = function(message)
  vim.cmd(
    [[echohl ErrorMsg | echom 'Error: ]] .. message .. [[' | echohl None]]
  )
end

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
    local directory = vim.fn.getcwd()
    -- Check if plenary is installed.
    local plenary_status, job = pcall(require, 'plenary.job')
    if not plenary_status then
      vim.cmd [[echohl ErrorMsg | echo "Error: Plenary is not installed. Commit on save is being disabled." | echohl None]]
      vim.g.__gitscripts_commit_on_save = false
      return
    end
    -- Check if within a git directory.
    if os.execute 'git rev-parse --git-dir 2>/dev/null' ~= 0 then
      return
    end
    -- Perform the asynchronous git commit.
    job
      :new({
        command = vim.g.__gitscripts_location .. '/commit.sh',
        args = {},
        cwd = directory,
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            print "Error: The git commit failed. Use ':GitLog' to view the log file."
          end
        end,
      })
      :start()
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
