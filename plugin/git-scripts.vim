" Check if plugin is loaded.
if exists("g:loaded_gitscripts")
    finish
endif
let g:loaded_gitscripts = 1

" INITIALIZING:

" TODO check that bash is installed and not using windows.

let g:gitscripts_location = (fnamemodify(resolve(expand('<sfile>:p')), ':h')) . '/../scripts'
silent execute("!chmod +x " . g:gitscripts_location . "/*.sh")

" Create a global variable to be used by the lua scripts.
let $GITSCRIPTS_LOCATION = g:gitscripts_location

" Commit when the buffer is saved.
if !exists("g:commit_on_save")
    let g:commit_on_save = 0
elseif g:commit_on_save == 1
    augroup auto_git_commit
        autocmd!
        autocmd BufWritePost * lua require("git-scripts").auto_commit()
        autocmd FileType * if g:commit_on_save == 1 | echom "WARNING: Automatic git commit on save is active. Enter 'let g:commit_on_save = 0' to disable." | endif
    augroup END
endif

" KEYMAPS:

" Create keymaps unless a variable is set.
if !exists("g:gitscripts_no_defaults")
    let g:gitscripts_no_defaults = 0
endif
if g:gitscripts_no_defaults != 1
    nnoremap <silent> <unique> <leader>gc <Cmd>lua require("git-scripts").async_commit()<CR>
    nnoremap <silent> <unique> <leader>gp <Cmd>lua require("git-scripts").async_pull()<CR>
    nnoremap <silent> <unique> <leader>tac <Cmd>lua require("git-scripts").toggle_auto_commit()<CR>
endif
