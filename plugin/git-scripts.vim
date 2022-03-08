" Check if the plugin has already been loaded.
if exists("g:loaded_gitscripts")
    finish
endif
let g:loaded_gitscripts = 1

" INITIALIZING:

if has('win32')
    echom "A unix system is required for 'git-scripts.nvim' :(. Have you tried using WSL?"
    finish
endif

let g:gitscripts_location = (fnamemodify(resolve(expand('<sfile>:p')), ':h')) . '/../scripts'
" Make the scripts executable.
silent execute("!chmod +x " . g:gitscripts_location . "/*.sh")

" Commit when the buffer is saved.
if !exists("g:commit_on_save")
    let g:commit_on_save = 0
elseif g:commit_on_save == 1
    augroup auto_git_commit
        autocmd!
        autocmd BufWritePost * lua require("git-scripts").autocmd_commit()
        autocmd BufEnter * if g:commit_on_save == 1 && g:commit_no_warnings == 0
                    \ | echom "WARNING: Commit on save is enabled. Use ':DisableCommit' to disable." | endif
    augroup END
endif

command! DisableCommit lua require("git-scripts").disable_auto_commit()

" Disable warnings.
if !exists("g:commit_no_warnings")
    let g:commit_no_warnings = 0
endif

" KEYMAPS:

" Create the default keymaps unless a variable is set.
if !exists("g:gitscripts_no_defaults")
    let g:gitscripts_no_defaults = 0
endif
if g:gitscripts_no_defaults != 1
    " The default keymaps.
    nnoremap <silent> <unique> <leader>gc <Cmd>lua require("git-scripts").async_commit()<CR>
    nnoremap <silent> <unique> <leader>gp <Cmd>lua require("git-scripts").async_pull()<CR>
    nnoremap <silent> <unique> <leader>tac <Cmd>lua require("git-scripts").toggle_auto_commit()<CR>
endif
