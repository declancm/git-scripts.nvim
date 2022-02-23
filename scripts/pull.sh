# Created by Declan Mullen
# Git repository can be found at: https://github.com/declancm/git-commit-script

#!/bin/bash

if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git rev-parse --abbrev-ref HEAD)
    gitDirectory=$(git rev-parse --show-toplevel)
    cd $gitDirectory
    remote=$(git remote)
    git pull -q $remote $branch
    cd $OLDPWD
else
    printf "You are not inside a git repository."
fi
