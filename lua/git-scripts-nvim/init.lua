-- Asynchronous git commit.
function AsyncGitCommit(directory)
  directory = directory or vim.fn.getcwd()
  scriptsLocation = os.getenv("GITSCRIPTS_LOCATION")
  local job = require("plenary.job")
  job
    :new({
      command = scriptsLocation .. "/commit-silent.sh",
      cwd = directory,
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          print("Error: The git commit failed.")
        end
      end,
    })
    :start()
end

-- Automatic asynchronous git commit on save.
function AutoAsyncCommit(directory)
  if (vim.g.auto_commit_enabled == 0) then
    if (vim.g.commit_on_save != 1) then
      vim.cmd([[
      augroup! auto_git_commit
        autocmd!
        autocmd BufWritePost * lua AsyncGitCommit()
      augroup END
      ]])
      print("Automatic git commit on save was activated for this session.")
      vim.g.auto_commit_enabled = 1
    else
      print("Automatic git commit on save has already been activated.")
    end
  else
    print("Automatic git commit on save has already been activated.")
  end
end

-- Asynchronous git pull.
function AsyncGitPull(directory)
  directory = directory or vim.fn.getcwd()
  scriptsLocation = os.getenv("GITSCRIPTS_LOCATION")
  local job = require("plenary.job")
  job
    :new({
      command = scriptsLocation .. "/pull-silent.sh",
      cwd = directory,
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          print("Error: The git pull failed.")
        end
      end,
    })
    :start()
end
