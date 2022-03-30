if exists("g:__gitscripts_loaded")
    finish
endif
let g:__gitscripts_loaded = 1

lua require('git-scripts').init(vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('<sfile>')), ':p:h:h') .. '/scripts')

if !exists("g:__gitscripts_setup_loaded")
    lua require('git-scripts').setup()
endif

command! DisableCommit lua require("git-scripts.functions").disable_auto_commit()
command! GitLog edit ~/.cache/nvim/git-scripts.log
