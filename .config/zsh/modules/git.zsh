# -----------------------------------------------------------------------------
# Defines Git aliases {{{
# -----------------------------------------------------------------------------

# Aliases
alias g='git'
alias h='hub'

# }}}
# -----------------------------------------------------------------------------

# TOC {{{

# - Custom
# - (b)ranch
# - (c)ommit
# - (C)onflict
# - (di)ff
# - (f)etch
# - (g)rep
# - (i)ndex
# - (l)og
# - (i)index (l)s-files
# - (m)erge
# - (p)ush
# - (r)ebase
# - (r)emote
# - (S)tash
# - (su)bmodule
# - (w)orking Copy
# - (g)arbage (c)ollection

# }}}
# -----------------------------------------------------------------------------

# Custom {{{

alias gfa='git fetch --all'
alias gpm='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias grt='cd $(git rev-parse --show-toplevel)'
alias gs='git status --ignore-submodules=none'
alias gs.='git status --ignore-submodules=none .'

# }}}
# -----------------------------------------------------------------------------

# (b)ranch {{{

alias gba='git branch'
alias gbc='git checkout -b'
alias gbL='git branch --all --verbose'
alias gbl='git branch --verbose'
alias gbM='git branch --move --force'
alias gbm='git branch --move'
alias gbs='git show-branch'
alias gbsall='git show-branch --all'
alias gbx='git branch --delete'
alias gbX='git branch --delete --force'

# }}}
# -----------------------------------------------------------------------------

# (c)ommit {{{

alias gc='git commit --signoff' # (C)ommit with show all change log
alias gca='git commit --all --signoff' # (C)ommit (a)ll changes
      gce() { git commit --message "$1"; } # (C)ommit with surround in double quotes the m(e)ssage automatically
alias gcf='git commit --amend --reuse-message HEAD'
alias gcF='git commit --amend'
# alias gcl='git-commit-lost'
alias gcO='git checkout --patch'
alias gco='git checkout'
alias gcp='git cherry-pick --ff'
alias gcP='git cherry-pick --no-commit'
alias gcR='git reset "HEAD^"'
alias gcr='git revert'
alias gcs='git show'

# }}}
# -----------------------------------------------------------------------------

# (C)onflict {{{

alias gCl='git status | sed -n "s/^.*both [a-z]*ed: *//p"'
alias gCa='git add $(gCl)'
alias gCe='git mergetool $(gCl)'
alias gCo='git checkout --ours --'
alias gCO='gCo $(gCl)'
alias gCt='git checkout --theirs --'
alias gCT='gCt $(gCl)'

# }}}
# -----------------------------------------------------------------------------

# d(i)ff {{{

alias di='git diff'
alias di.='git diff .'
alias gdi='git diff'
alias gdw='git diff --no-ext-diff'
alias gdW='git diff --no-ext-diff --word-diff'

# }}}
# -----------------------------------------------------------------------------

# (f)etch {{{

alias gf='git fetch'
alias gfa='git fetch --all'

alias gcl='git clone --recursive'
alias gcn='git clone'

alias gfr='git pull --rebase'

# }}}
# -----------------------------------------------------------------------------

# (g)it (f)etch (p)ull request
# http://qiita.com/tarr1124/items/d807887418671adbc46f
gfp() {
  USER_BRANCH=$2
  USER_BRANCH=(${(s/:/)USER_BRANCH})
  git fetch origin pull/"$1"/head:"$USER_BRANCH[2]"
  git branch --move $USER_BRANCH[2] pull/"$1"/"$USER_BRANCH[1]"/"$USER_BRANCH[2]"
  unset USER_BRANCH
}

# }}}
# -----------------------------------------------------------------------------

# (g)rep {{{

# alias gg='git grep'
# alias ggi='git grep --ignore-case'
# alias ggl='git grep --files-with-matches'
# alias ggL='git grep --files-without-matches'
# alias ggv='git grep --invert-match'
# alias ggw='git grep --word-regexp'

# }}}
# -----------------------------------------------------------------------------

# (i)ndex {{{

alias gia='git add'
alias giap='git add --patch'
alias giu='git add --update'
alias giD='git diff --no-ext-diff --cached --word-diff'
alias gir='git reset'
alias giR='git reset --patch'
alias gix='git rm -r --cached'
alias giX='git rm -rf --cached'

# }}}
# -----------------------------------------------------------------------------

# (l)og {{{

# Format settings
_git_log_oneline_format='%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
_git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'

alias gl='git log --topo-order --stat --full-diff --graph --color --decorate=full'
alias gla='gl --all'                                                                        # Display all refs in refs/
alias glb='git log --topo-order --pretty=format:"${_git_log_brief_format}"'                 # Brief format(need?)
alias glc='git shortlog --summary --numbered'                                               # git commit summary
alias gld='gl --patch'                                                                      # Display file patch level
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}"' # refs movement graph
alias glo='git log --topo-order --pretty=format:"${_git_log_oneline_format}"'               # Oneline
alias glsig='gl --show-signature'                                                           # Show sign signature
alias glsm='git log --topo-order --pretty=format:"${_git_log_medium_format}"'               # Simple

# }}}
# -----------------------------------------------------------------------------

# (i)index (l)s-files {{{

# alias gildi='git status --porcelain --short --ignored | sed -n "s/^!! //p"'
# alias gilk='git ls-files --killed'
# alias gilm='git ls-files --modified'
# alias gils='git ls-files'
# alias gilsc='git ls-files --cached'
# alias gilu='git ls-files --other --exclude-standard'
# alias gilx='git ls-files --deleted'

# }}}
# -----------------------------------------------------------------------------

# (m)erge {{{

alias gm='git merge'
alias gma='git merge --abort'
alias gmC='git merge --no-commit'
alias gmF='git merge --no-ff'
alias gmt='git mergetool'

# }}}
# -----------------------------------------------------------------------------

# (p)ush {{{

alias gp='git push'
alias gpA='git push --all && git push --tags'
alias gpa='git push --all'
alias gpc='git push --set-upstream origin "$(git-branch-current 2> /dev/null)"'
alias gpF='git push --force'
alias gpp='git pull origin "$(git-branch-current 2> /dev/null)" && git push origin "$(git-branch-current 2> /dev/null)"'
alias gpt='git push --tags'

# }}}
# -----------------------------------------------------------------------------

# (r)ebase {{{

alias gr='git rebase --autostash'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias grs='git rebase --skip'

# }}}
# -----------------------------------------------------------------------------

# (r)emote {{{

alias gre='git remote --verbose'
alias grea='git remote add'
alias greb='git-hub-browse'
alias grer='git remote rename'
alias gres='git remote set-url'
alias greu='git remote update'
alias grex='git remote remove'

# }}}
# -----------------------------------------------------------------------------

# (S)tash {{{

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

# }}}
# -----------------------------------------------------------------------------

# (su)bmodule {{{

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

# }}}
# -----------------------------------------------------------------------------

# (w)orking Copy

alias gwC='git clean -f'
alias gwc='git clean -n'
alias gwR='git reset --hard'
alias gwr='git reset --soft'
alias gws='git status --ignore-submodules=${_git_status_ignore_submodules} --short'
alias gwS='git status --ignore-submodules=${_git_status_ignore_submodules}'
alias gwx='git rm -r'
alias gwX='git rm -rf'

# }}}
# -----------------------------------------------------------------------------

# (g)arbage (c)ollection
alias ggc='git gc'
alias gccf='git gc --prune=all'

# }}}
# -----------------------------------------------------------------------------
[[ $ZSH_DEBUG = '1' ]] && echo 'Finished $HOME/.zsh/modules/git.zsh'
# vim:ft=zsh:sts=2:sw=2:ts=2:et
