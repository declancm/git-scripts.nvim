" Check if plugin is loaded.
if exists("g:loaded_gitscripts")
    finish
endif
let g:gitscripts_loaded = 1

" INITIALIZING:

" check if ~/git-scripts exists and if not, clone to that folder
if !exists("g:gitscripts_location") || g:gitscripts_location == ""
    let g:gitscripts_location = expand("~/git-scripts")
    if !isdirectory(g:gitscripts_location)
        silent execute("!git clone https://github.com/declancm/git-scripts.git ~/git-scripts")
    endif
    silent execute("!chmod +x ~/git-scripts/*.sh")
elseif g:gitscripts_location != expand("~/git-scripts")
	let g:gitscripts_location = expand(g:gitscripts_location)
    if !isdirectory(g:gitscripts_location)
        silent execute("!git clone https://github.com/declancm/git-scripts.git " . g:gitscripts_location)
    endif
    silent execute("!chmod +x " . g:gitscripts_location . "/*.sh")
endif

let $GITSCRIPTS_LOCATION = g:gitscripts_location

let g:auto_commit_enabled = 0

" FUNCTION:

function! s:SourceGitScript(script)
    if g:gitscripts_location == ""
        silent execute("!source ~/git-scripts/" . a:script)
    else
        silent execute("!source " . g:gitscripts_location . "/" . a:script)
    endif
endfunction

" KEYMAPS:

nnoremap <silent> <Plug>GitCommit <Cmd>call <SID>SourceGitScript('commit-silent.sh')<CR>
nnoremap <silent> <Plug>GitPull <Cmd>call <SID>SourceGitScript('push-silent.sh')<CR>
nnoremap <silent> <Plug>AsyncGitCommit <Cmd>lua AsyncGitPull()<CR>
nnoremap <silent> <Plug>AsyncGitPull <Cmd>lua AsyncGitPull()
nnoremap <silent> <Plug>AutoAsyncPull <Cmd>lua AutoAsyncPull()

" create keymaps unless a variable is set
if !exists("g:gitscripts_no_defaults")
    let g:gitscripts_no_defaults = 0
elseif g:gitscripts_no_defaults != 1
    nmap <silent> <leader>gc <Plug>GitCommit
    nmap <silent> <leader>gp <Plug>GitPull
    nmap <silent> <leader>ac <Plug>AsyncGitCommit
    nmap <silent> <leader>ap <Plug>AsyncGitPull
    nmap <silent> <leader>aac <Plug>AsyncGitCommit
endif

" commit when buffer is saved
if !exists("g:commit_on_save")
    let g:commit_on_save = 0
elseif g:commit_on_save == 1
    augroup auto_git_commit
        autocmd!
        autocmd BufWritePost * lua AsyncGitCommit()
        echom "Automatic git commit on save is active."
    augroup END
endif
