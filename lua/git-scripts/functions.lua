local M = {}

local options = require('git-scripts').options
local utils = require('git-scripts.utils')

-- Git commit.
M.git_commit = function(message)
  -- Check if within a git directory.
  if os.execute('git rev-parse --git-dir 2>/dev/null') ~= 0 then
    utils.error_msg('You are not within a git repository')
    return
  end
  if message == nil then
    vim.cmd(
      '!source ' .. require('git-scripts').scripts_location .. '/commit.sh'
    )
  else
    vim.cmd(
      '!source '
        .. require('git-scripts').scripts_location
        .. '/commit.sh '
        .. message
    )
  end
end

-- Git pull.
M.git_pull = function()
  -- Check if within a git directory.
  if os.execute('git rev-parse --git-dir 2>/dev/null') ~= 0 then
    utils.error_msg('You are not within a git repository')
    return
  end
  vim.cmd('!source ' .. require('git-scripts').scripts_location .. '/pull.sh')
end

-- Asynchronous git commit.
M.async_commit = function(message, directory)
  if message == nil then
    message = ''
  end
  if directory == nil then
    directory = vim.fn.getcwd()
  end
  -- Check if plenary is installed.
  local plenary_status, job = pcall(require, 'plenary.job')
  if not plenary_status then
    utils.error_msg('Plenary is not installed')
    return
  end
  -- Check if within a git directory.
  if os.execute('git rev-parse --git-dir 2>/dev/null') ~= 0 then
    utils.error_msg('You are not within a git repository')
    return
  end
  -- Perform the asynchronous git commit.
  local scripts_location = require('git-scripts').scripts_location
  job
    :new({
      command = scripts_location .. '/commit.sh',
      args = { message },
      cwd = directory,
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          print("The git commit failed. Use ':GitLog' to view the log file")
        end
      end,
    })
    :start()
end

-- Asynchronous git pull.
M.async_pull = function(directory)
  if directory == nil then
    directory = vim.fn.getcwd()
  end
  -- Check if plenary is installed.
  local plenary_status, job = pcall(require, 'plenary.job')
  if not plenary_status then
    utils.error_msg('Plenary is not installed')
    return
  end
  -- Check if within a git directory.
  if os.execute('git rev-parse --git-dir 2>/dev/null') ~= 0 then
    return
  end
  -- Perform the asynchronous git pull.
  local scripts_location = require('git-scripts').scripts_location
  job
    :new({
      command = scripts_location .. '/pull.sh',
      cwd = directory,
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          print("The git pull failed. Use ':GitLog' to view the log file")
        end
      end,
    })
    :start()
end

-- Toggle automatic asynchronous git commit on save.
M.toggle_auto_commit = function()
  if options.commit_on_save then
    options.commit_on_save = false
    print('Commit on save is disabled')
  else
    options.commit_on_save = true
    require('git-scripts.utils').set_commit_autocmd()
    print('Commit on save is enabled')
  end
end

-- Enable automatic asynchronous git commit on save.
M.enable_auto_commit = function()
  if not options.commit_on_save then
    options.commit_on_save = true
    require('git-scripts.utils').set_commit_autocmd()
    print('Commit on save is enabled')
  else
    print('Commit on save is already enabled')
  end
end

-- Disable automatic asynchronous git commit on save.
M.disable_auto_commit = function()
  if options.commit_on_save then
    options.commit_on_save = false
    print('Commit on save is disabled')
  else
    print('Commit on save is already disabled')
  end
end

return M
