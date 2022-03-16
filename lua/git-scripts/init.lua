local M = {}

-- Git commit.
M.git_commit = function(message)
  if message == nil then
    vim.cmd('!source ' .. vim.g.gitscripts_location .. '/commit.sh')
  else
    vim.cmd('!source ' .. vim.g.gitscripts_location .. '/commit.sh ' .. message)
  end
end

-- Git pull.
function M.git_pull()
  vim.cmd('!source ' .. vim.g.gitscripts_location .. '/pull.sh')
end

-- Asynchronous git commit.
M.async_commit = function(message, directory)
  local message = message or ''
  local directory = directory or vim.fn.getcwd()
  -- Check if plenary is installed.
  local plenary_status, job = pcall(require, 'plenary.job')
  if not plenary_status then
    print 'Error: Plenary is not installed.'
    return
  end
  job
    :new({
      command = vim.g.gitscripts_location .. '/commit.sh',
      args = { message },
      cwd = directory,
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          print 'Error: The git commit failed.'
        end
      end,
    })
    :start()
end

-- Asynchronous git pull.
M.async_pull = function(directory)
  local directory = directory or vim.fn.getcwd()
  -- Check if plenary is installed.
  local plenary_status, job = pcall(require, 'plenary.job')
  if not plenary_status then
    print 'Error: Plenary is not installed.'
    return
  end
  job
    :new({
      command = vim.g.gitscripts_location .. '/pull.sh',
      cwd = directory,
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          print 'Error: The git pull failed.'
        end
      end,
    })
    :start()
end

-- Toggle automatic asynchronous git commit on save.
M.toggle_auto_commit = function()
  if vim.g.commit_on_save ~= 1 then
    vim.g.commit_on_save = 1
    vim.cmd [[
    if !exists('#auto_git_commit#BufWritePost')
        augroup auto_git_commit
            autocmd!
            autocmd BufWritePost * lua require("git-scripts").autocmd_commit()
            autocmd BufEnter * if g:commit_on_save == 1 && g:commit_no_warnings == 0
                        \ | echom "WARNING: Commit on save is enabled. Use ':DisableCommit' to disable." | endif
        augroup END
    endif
    ]]
    print 'Commit on save is enabled.'
  else
    vim.g.commit_on_save = 0
    print 'Commit on save is disabled.'
  end
end

-- Enable automatic asynchronous git commit on save.
M.enable_auto_commit = function()
  if vim.g.commit_on_save ~= 1 then
    vim.g.commit_on_save = 1
    vim.cmd [[
    if !exists('#auto_git_commit#BufWritePost')
        augroup auto_git_commit
            autocmd!
            autocmd BufWritePost * lua require("git-scripts").autocmd_commit()
            autocmd BufEnter * if g:commit_on_save == 1 && g:commit_no_warnings == 0
                        \ | echom "WARNING: Commit on save is enabled. Use ':DisableCommit' to disable." | endif
        augroup END
    endif
    ]]
    print 'Commit on save is enabled.'
  else
    print 'Commit on save has already been enabled.'
  end
end

-- Disable automatic asynchronous git commit on save.
M.disable_auto_commit = function()
  if vim.g.commit_on_save ~= 0 then
    vim.g.commit_on_save = 0
    print 'Commit on save is disabled.'
  else
    print 'Commit on save was already disabled.'
  end
end

-- Asynchronous git commit when commit_on_save is enabled.
M.autocmd_commit = function()
  if vim.g.commit_on_save == 1 then
    require('git-scripts').async_commit()
  end
end

-- TODO get fugitive commit and pull working.

-- -- Vim fugitive commit.
-- function M.fugitive_commit(commitMessage)
--   -- Set the commit message.
--   -- local defaultMessage = "Auto Commit: " .. os.date("!%c") .. " UTC"
--   local defaultMessage = 'auto commit @ ' .. os.date '!%Y-%m-%d %H:%M:%S' .. ' UTC'
--   local commitMessage = commitMessage or defaultMessage
--   -- Check if actually in a git directory.
--   local gitDirectory = vim.fn.FugitiveGitDir()
--   if gitDirectory == '' then
--     return 1
--   end
--   -- Get the branch name.
--   local gitBranch = vim.fn.FugitiveHead()
--   if gitBranch == '' then
--     return 1
--   end
--   -- Get the remote url.
--   local gitRemote = vim.fn.FugitiveRemoteUrl()
--   if gitRemote == '' then
--     return 1
--   end
--   -- Execute git add.
--   vim.fn.FugitiveExecute('add', gitDirectory)
--   -- Execute git commit.
--   -- vim.fn.FugitiveExecute("commit", "-a", "-m", commitMessage)
--   print(vim.fn.FugitiveExecute('commit', '-a', '-m', commitMessage).stdout)
--   -- Execute git push.
--   -- vim.fn.FugitiveExecute("push", gitRemote, gitBranch)
--   print(vim.fn.FugitiveExecute('push', gitRemote, gitBranch).stdout)
-- end

-- -- Vim fugitive pull.
-- function M.fugitive_pull(commitMessage)
--   -- Check if actually in a git directory.
--   if vim.fn.FugitiveGitDir() == '' then
--     return 1
--   end
--   -- Get the branch name.
--   local gitBranch = vim.fn.FugitiveHead()
--   if gitBranch == '' then
--     return 1
--   end
--   -- Get the remote url.
--   local gitRemote = vim.fn.FugitiveRemoteUrl()
--   if gitRemote == '' then
--     return 1
--   end
--   -- Execute git pull.
--   vim.fn.FugitiveExecute('pull', gitRemote, gitBranch)
-- end

return M
