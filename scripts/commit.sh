#!/usr/bin/env bash

# Created by Declan Mullen
# Git repository can be found at: https://github.com/declancm/git-scripts.nvim

(
    echo "Commit Log [`date -u +'%b %d %H:%M:%S %Y'`] :\n"
    gitBranch=$(git rev-parse --abbrev-ref HEAD)
    gitDirectory=$(git rev-parse --show-toplevel)
    cd $gitDirectory
    gitRemote=$(git remote)
    git add .
    wait
    if [ $# -eq 0 ] || [ -z "$1" ]
    then
        git commit -a -m "Auto Commit: `date -u +'%b %d %H:%M:%S %Y'` UTC"
    else
        git commit -a -m "$1"
    fi
    wait
    git push $gitRemote $gitBranch
    cd $OLDPWD
) 2>&1 > ~/.cache/nvim/git-scripts.log
