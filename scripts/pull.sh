# Created by Declan Mullen
# Git repository can be found at: https://github.com/declancm/git-scripts.nvim

#!/usr/bin/env bash

(
    echo "Pull Log [`date -u +'%b %d %H:%M:%S %Y'`] :\n"
    gitBranch=$(git rev-parse --abbrev-ref HEAD)
    gitDirectory=$(git rev-parse --show-toplevel)
    cd $gitDirectory
    gitRemote=$(git remote)
    git pull $gitRemote $gitBranch
    cd $OLDPWD
) 2>&1 > ~/.cache/nvim/git-scripts.log
