local M = {}

local options = require('git-scripts').options

M.error_msg = function(message, code)
  code = code or 'Error'
  vim.cmd(
    string.format(
      "echohl ErrorMsg | echom '%s: %s' | echohl None",
      code,
      message
    )
  )
end

-- Set the autocmd which commits on save.
M.set_commit_autocmd = function()
  vim.cmd([[
  augroup commit_on_save
      autocmd!
      autocmd BufWritePost * lua require("git-scripts.utils").commit_on_save()
      autocmd BufEnter * lua require("git-scripts.utils").commit_warning()
  augroup END
  ]])
end

-- Asynchronous git commit when commit_on_save is enabled.
M.commit_on_save = function()
  if options.commit_on_save then
    local directory = vim.fn.getcwd()
    -- Check if plenary is installed.
    local plenary_status, job = pcall(require, 'plenary.job')
    if not plenary_status then
      vim.cmd(
        "echohl ErrorMsg | echom 'Error: Plenary is not installed. Commit on save is being disabled' | echohl None"
      )
      -- require('git-scripts.utils').ErrorMsg(
      --   'Plenary is not installed. Commit on save is being disabled.'
      -- )
      options.commit_on_save = false
      return
    end
    -- Check if within a git directory.
    if os.execute('git rev-parse --git-dir 2>/dev/null') ~= 0 then
      return
    end
    -- Perform the asynchronous git commit.
    local scripts_location = require('git-scripts').scripts_location
    job
      :new({
        command = scripts_location .. '/commit.sh',
        args = {},
        cwd = directory,
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            print("The git commit failed. Use ':GitLog' to view the log file")
          end
        end,
      })
      :start()
  end
end

M.commit_warning = function()
  if options.commit_on_save and options.warnings and vim.bo.buftype == '' then
    vim.cmd([[
    echohl WarningMsg
    echo "Warning: Commit on save is enabled. Use ':DisableCommit' to disable"
    echohl None
    ]])
  end
end

return M
