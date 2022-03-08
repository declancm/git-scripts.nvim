# Created by Declan Mullen
# Git repository can be found at: https://github.com/declancm/git-scripts.nvim

#!/usr/bin/env bash

if git rev-parse --git-dir > /dev/null 2>&1; then
    gitBranch=$(git rev-parse --abbrev-ref HEAD)
    gitDirectory=$(git rev-parse --show-toplevel)
    cd $gitDirectory
    gitRemote=$(git remote)
    git pull $gitRemote $gitBranch
    cd $OLDPWD
else
    printf "You are not inside a git repository.\n"
    exit 1
fi
