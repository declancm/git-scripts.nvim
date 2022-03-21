# Created by Declan Mullen
# Git repository can be found at: https://github.com/declancm/git-scripts.nvim

#!/usr/bin/env bash

gitBranch=$(git rev-parse --abbrev-ref HEAD)
gitDirectory=$(git rev-parse --show-toplevel)
cd $gitDirectory
gitRemote=$(git remote)
git pull $gitRemote $gitBranch
cd $OLDPWD
