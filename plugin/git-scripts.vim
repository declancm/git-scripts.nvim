if exists("g:__gitscripts_loaded")
    finish
endif
let g:__gitscripts_loaded = 1

" Setup:
let g:__gitscripts_location = (fnamemodify(resolve(expand('<sfile>:p')), ':h')) . '/../scripts'
if !exists("g:__gitscripts_setup_completed")
    lua require('git-scripts').setup()
endif
command! DisableCommit lua require("git-scripts.functions").disable_auto_commit()
command! GitLog edit ~/.cache/nvim/git-scripts.log
