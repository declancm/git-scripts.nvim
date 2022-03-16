if exists("g:loaded_gitscripts")
    finish
endif
let g:loaded_gitscripts = 1

let g:gitscripts_location = (fnamemodify(resolve(expand('<sfile>:p')), ':h')) . '/../scripts'

command! DisableCommit lua require("git-scripts.functions").disable_auto_commit()

lua require('git-scripts').init()

if !exists("g:gitscripts_setup_completed")
    lua require('git-scripts').setup()
endif
