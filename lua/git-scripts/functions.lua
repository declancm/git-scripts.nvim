local M = {}

-- Git commit.
M.git_commit = function(message)
  if message == nil then
    vim.cmd('!source ' .. vim.g.__gitscripts_location .. '/commit.sh')
  else
    vim.cmd(
      '!source ' .. vim.g.__gitscripts_location .. '/commit.sh ' .. message
    )
  end
end

-- Git pull.
M.git_pull = function()
  vim.cmd('!source ' .. vim.g.__gitscripts_location .. '/pull.sh')
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
    vim.cmd [[echohl ErrorMsg | echo "Error: Plenary is not installed." | echohl None]]
    return
  end
  job
    :new({
      command = vim.g.__gitscripts_location .. '/commit.sh',
      args = { message },
      cwd = directory,
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          vim.cmd [[echohl ErrorMsg | echo "Error: The git commit failed." | echohl None]]
        else
          print 'The git commit was successful!'
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
    vim.cmd [[echohl ErrorMsg | echo "Error: Plenary is not installed." | echohl None]]
    return
  end
  job
    :new({
      command = vim.g.__gitscripts_location .. '/pull.sh',
      cwd = directory,
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          vim.cmd [[echohl ErrorMsg | echo "Error: The git pull failed." | echohl None]]
        end
      end,
    })
    :start()
end

-- Toggle automatic asynchronous git commit on save.
M.toggle_auto_commit = function()
  if vim.g.__gitscripts_commit_on_save == true then
    vim.g.__gitscripts_commit_on_save = false
    print 'Commit on save is disabled.'
  else
    vim.g.__gitscripts_commit_on_save = true
    require('git-scripts.utils').set_commit_autocmd()
    print 'Commit on save is enabled.'
  end
end

-- Enable automatic asynchronous git commit on save.
M.enable_auto_commit = function()
  if vim.g.__gitscripts_commit_on_save == false then
    vim.g.__gitscripts_commit_on_save = true
    require('git-scripts.utils').set_commit_autocmd()
    print 'Commit on save is enabled.'
  else
    print 'Commit on save is already enabled.'
  end
end

-- Disable automatic asynchronous git commit on save.
M.disable_auto_commit = function()
  if vim.g.__gitscripts_commit_on_save == true then
    vim.g.__gitscripts_commit_on_save = false
    print 'Commit on save is disabled.'
  else
    print 'Commit on save is already disabled.'
  end
end

return M
