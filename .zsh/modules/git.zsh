#
# Defines Git aliases.
#


# Format settings
# _git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
_git_log_oneline_format='%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
_git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'


#
# Aliases
#

# Git & hub
alias g='hub'
# if type hub >/dev/null 2>&1; then
#   function git(){hub "$@"}
# fi


# Lists
#  - Branch
#  - Commit
#  - Conflict
#  - Diff
#  - Fetch
#  - Grep
#  - Index
#  - Log
#  - ls-files
#  - Merge
#  - Push
#  - Rebase
#  - Remote
#  - Stash
#  - Status
#  - Submodule
#  - Working copy


# (b)ranch
alias  gba='git branch'
alias gbc='git checkout -b'
alias gbL='git branch --all --verbose'
alias gbl='git branch --verbose'
alias gbM='git branch --move --force'
alias gbm='git branch --move'
alias gbs='git show-branch'
alias gbsall='git show-branch --all'
alias gbx='git branch --delete'
alias gbX='git branch --delete --force'

# (c)ommit
alias gc='git commit --verbose --signoff' # (C)ommit with show all change log
alias gca='git commit --all --verbose --signoff' # (C)ommit (a)ll changes
      gce() { git commit --message "$1"; } # (C)ommit with surround in double quotes the m(e)ssage automatically
alias gcf='git commit --amend --reuse-message HEAD'
alias gcF='git commit --verbose --amend'
# alias gcl='git-commit-lost'
alias gcO='git checkout --patch'
alias gco='git checkout'
alias gcp='git cherry-pick --ff'
alias gcP='git cherry-pick --no-commit'
alias gcR='git reset "HEAD^"'
alias gcr='git revert'
alias gcs='git show'

# (C)onflict
alias gCl='git status | sed -n "s/^.*both [a-z]*ed: *//p"'
alias gCa='git add $(gCl)'
alias gCe='git mergetool $(gCl)'
alias gCo='git checkout --ours --'
alias gCO='gCo $(gCl)'
alias gCt='git checkout --theirs --'
alias gCT='gCt $(gCl)'

# Diff (di)ff
alias gd='git diff'
alias gdi='git diff'
alias gdiw='git diff --no-ext-diff'
alias gdiW='git diff --no-ext-diff --word-diff'

# Fetch (f)
alias gf='git fetch'
alias gfa='git fetch --all'
alias gcl='git clone'
alias gfc='git clone'
alias gfr='git pull --rebase'

# http://qiita.com/tarr1124/items/d807887418671adbc46f
gfp() {
  USER_BRANCH=$2
  USER_BRANCH=(${(s/:/)USER_BRANCH})
  git fetch origin pull/"$1"/head:"$USER_BRANCH[2]"
  git branch --move $USER_BRANCH[2] pull/"$1"/"$USER_BRANCH[1]"/"$USER_BRANCH[2]"
  unset USER_BRANCH
}
      # gfp() { git fetch origin pull/"$1"/head:"$2"; git branch --move "$2" "pull/$1/$2" }

# Grep (g)
# alias gg='git grep'
# alias ggi='git grep --ignore-case'
# alias ggl='git grep --files-with-matches'
# alias ggL='git grep --files-without-matches'
# alias ggv='git grep --invert-match'
# alias ggw='git grep --word-regexp'

# Index (i)
alias gia='git add'
alias giA='git add --patch'
alias giu='git add --update'
alias gid='git diff --no-ext-diff --cached'
alias giD='git diff --no-ext-diff --cached --word-diff'
alias gir='git reset'
alias giR='git reset --patch'
alias gix='git rm -r --cached'
alias giX='git rm -rf --cached'

# Log (l)
# Default git log style
# alias gl='git log --topo-order --stat --full-diff --graph --color --decorate=full --pretty=format:"${_git_log_medium_format}"'
alias gl='git log --topo-order --stat --full-diff --graph --color --decorate=full'

alias gla='gl --all'                                                                        # Display all refs in refs/
alias glb='git log --topo-order --pretty=format:"${_git_log_brief_format}"'                 # Brief format(need?)
alias glc='git shortlog --summary --numbered'                                               # git commit summary
alias gld='gl --patch'                                                                      # Display file patch level
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}"' # refs movement graph
alias glo='git log --topo-order --pretty=format:"${_git_log_oneline_format}"'               # Oneline
alias glsig='gl --show-signature'                                                           # Show sign signature
alias glsm='git log --topo-order --pretty=format:"${_git_log_medium_format}"'               # Simple

# ls-files (g(i)t (ls))
# alias gildi='git status --porcelain --short --ignored | sed -n "s/^!! //p"'
# alias gilk='git ls-files --killed'
# alias gilm='git ls-files --modified'
# alias gils='git ls-files'
# alias gilsc='git ls-files --cached'
# alias gilu='git ls-files --other --exclude-standard'
# alias gilx='git ls-files --deleted'

# Merge (m)
alias gm='git merge'
alias gma='git merge --abort'
alias gmC='git merge --no-commit'
alias gmF='git merge --no-ff'
alias gmt='git mergetool'

# Push (p)
alias gp='git push'
alias gpA='git push --all && git push --tags'
alias gpa='git push --all'
alias gpc='git push --set-upstream origin "$(git-branch-current 2> /dev/null)"'
alias gpF='git push --force'
alias gpp='git pull origin "$(git-branch-current 2> /dev/null)" && git push origin "$(git-branch-current 2> /dev/null)"'
alias gpt='git push --tags'

# Rebase (r)
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias grs='git rebase --skip'

# Remote (R)
alias gre='git remote --verbose'
alias grea='git remote add'
alias greb='git-hub-browse'
alias grer='git remote rename'
alias gres='git remote set-url'
alias greu='git remote update'
alias grex='git remote remove'

# Stash (s)
alias gS='git stash'
alias gSa='git stash apply'
alias gSd='git stash show --patch --stat'
alias gSl='git stash list'
alias gSL='git-stash-dropped'
alias gSp='git stash pop'
alias gSr='git-stash-recover'
alias gSs='git stash save --include-untracked'
alias gSS='git stash save --patch --no-keep-index'
alias gSw='git stash save --include-untracked --keep-index'
alias gSx='git stash drop'
alias gSX='git-stash-clear-interactive'

# Status
alias gfa='git fetch --all'
alias gpm='git pull origin master'
alias grt='cd $(git rev-parse --show-toplevel)'
alias gs='git status --ignore-submodules=none'

# (su)bmodule
alias gsu='git submodule'
alias gsua='git submodule add'
alias gsuf='git submodule foreach'
alias gsui='git submodule init'
alias gsuI='git submodule update --init --recursive'
alias gsul='git submodule status'
alias gsum='git-submodule-move'
alias gsus='git submodule sync'
alias gsuu='git submodule foreach git pull origin master'
alias gsux='git-submodule-remove'

# Working Copy (w)
alias gwC='git clean -f'
alias gwc='git clean -n'
alias gwR='git reset --hard'
alias gwr='git reset --soft'
alias gws='git status --ignore-submodules=${_git_status_ignore_submodules} --short'
alias gwS='git status --ignore-submodules=${_git_status_ignore_submodules}'
alias gwx='git rm -r'
alias gwX='git rm -rf'

# }}}
####################################################################################################
if [[ -n $ZSH_DEBUG ]]; then; echo 'Finished $HOME/.zsh/modules/git.zsh'; fi
