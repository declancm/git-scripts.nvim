if exists("g:__loaded_gitscripts")
    finish
endif
let g:__gitscripts_loaded = 1
lua require('git-scripts').init()
if exists("g.__gitscrips_failed")
    finish
endif

" Setup:
let g:__gitscripts_location = (fnamemodify(resolve(expand('<sfile>:p')), ':h')) . '/../scripts'
if !exists("g:__gitscripts_setup_completed")
    lua require('git-scripts').setup()
endif
command! DisableCommit lua require("git-scripts.functions").disable_auto_commit()
