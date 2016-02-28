#
# zshenv {{{
# Defines environment variables
#
# export ZSH_DEBUG=1

if [[ -n $ZSH_DEBUG ]]; then; echo 'Loading zshenv'; fi

# Initial load libzpython
# zmodload zsh/libzpython; zpython 'import zsh'

# Load .zprofile {{{
# Ensure that a non-login, non-interactive shell has a defined environment
# if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-${HOME}}/.zprofile" ]]; then
#   source "${ZDOTDIR:-${HOME}}/.zprofile"
# fi


# }}}
################################################################################
#
# Set local environ
#

# Xcode command line tool
# /Applications/Xcode(-beta).app/Contents/Developer
local DEVELOPER_DIR="$(xcode-select -p)"

local ZSH_PLUGIN=$HOME/.zsh/plugins
local ZSH_MODULE=$HOME/.zsh/modules

# }}}
################################################################################

#
# System configuration {{{
#

ulimit -n 10000

# }}}
################################################################################

#
# Environment variables {{{
#

export SHELL=/usr/local/bin/zsh
export TERM=xterm-256color
export LC_ALL=en_US.UTF-8

# XDG Based Directory environment variables
# cf: http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
# cf: https://wiki.debian.org/XDGBaseDirectorySpecification
# cf: https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
# Unofficial XDG environment variable
export XDG_LOG_HOME="${HOME}/.log"

# Affected in all tools
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export MANPAGER=less
export GIT=/usr/local/bin/git

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER=open
fi

if [[ -z "$LANG" ]]; then
  export LANG=en_US.UTF-8
fi

# }}}
################################################################################

#
# Build {{{
#

export CC="${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CXX="${CC}++"

export MAKEFLAGS='-j$(($(nproc)+1))'

export LD_LIBRARY_PATH='/opt/llvm/lib:/usr/local/lib:/usr/lib'

# Python frameworks
# export PYTHON_EXECUTABLE="/usr/local/Frameworks/Python.framework/Versions/3.6/bin/python3.6m"
# export PYTHON_INCLUDE_DIR="/usr/local/Frameworks/Python.framework/Versions/3.6/include"
# export PYTHON_LIBRARY="/usr/local/Frameworks/Python.framework/Versions/3.6/lib/libpython3.6m.dylib"
# export PYTHON2_EXECUTABLE="/usr/local/Frameworks/Python.framework/Versions/2.7/bin/python2.7"
# export PYTHON2_INCLUDE_DIR="/usr/local/Frameworks/Python.framework/Versions/2.7/include/python2.7"
# export PYTHON2_LIBRARY="/usr/local/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib"

# }}}
################################################################################

#
# Tools {{{
#

# Neovim
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export NVIM_VERBOSE_LOG_FILE="${XDG_LOG_HOME}/nvim/verbose.log"
export NVIM_STARTUP_LOG_FILE="${XDG_LOG_HOME}/nvim/startup.log"
export NVIM_LISTEN_ADDRESS=/tmp/nvim
if ! [ -e "/tmp/nvim" ]; then
    export NVIM_LISTEN_ADDRESS=/tmp/nvim
fi
if [[ -d "${XDG_LOG_HOME}/nvim/go" ]]; then
    mkdir -p "${XDG_LOG_HOME}/nvim/go"
fi
if [[ -d "${XDG_LOG_HOME}/nvim/python" ]]; then
    mkdir -p "${XDG_LOG_HOME}/nvim/python"
fi
export NEOVIM_GO_LOG_FILE="${XDG_LOG_HOME}/nvim/go/client.log"
export NVIM_GO_LOG_FILE="${XDG_LOG_HOME}/nvim/go/nvim-go.log"
# If always export NVIM_PYTHON_LOG_FILE, nvim will be exists logfile.
# that is low performance
# export NVIM_PYTHON_LOG_FILE="${XDG_LOG_HOME}/nvim/python/python-client.log"
# export NVIM_PYTHON_LOG_LEVEL="DEBUG"

# curl
export CURL_CA_BUNDLE="/usr/local/etc/openssl/certs/curl-ca-bundle.crt"
# export SSL_CERT_FILE=/usr/local/etc/openssl/certs/ca-bundle.crt

# Docker Machine
# Always use experimental install
export MACHINE_DEBUG=1
export MACHINE_DRIVER_DEBUG=1
export MACHINE_DOCKER_INSTALL_URL=https://experimental.docker.com
export MACHINE_NATIVE_SSH=1
# export MACHINE_BUGSNAG_API_TOKEN=

# ls colors
eval "$(/opt/coreutils/bin/dircolors --sh)"

# Less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-g -i -M -R -S -w -z-4 -X -F'
export LESSOPEN='| src-hilite-lesspipe.sh %s'
# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
    export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi
# less coloring
export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;44;33m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")
# export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
# export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
# export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
# export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
# export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
# export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
# export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan


# google cloud sdk
# gcloud support only python2 when install gcloud
export CLOUDSDK_PYTHON=/usr/local/bin/python2

# z.sh
export _Z_DATA="${XDG_CACHE_HOME}/z/.z"
if ! [ -f "$_Z_DATA" ]; then
    mkdir -p "${XDG_CACHE_HOME}/z"
    touch "$_Z_DATA"
fi


# nq
export NQDIR=/tmp/nq
if [[ ! -d "$NQDIR" ]]; then
    mkdir "$NQDIR"
fi


# Homebrew
export HOMEBREW_CACHE="${XDG_CACHE_HOME}/Homebrew"
export HOMEBREW_DEBUG=1
export HOMEBREW_DEVELOPER=1
export HOMEBREW_MAKE_JOBS=9
export HOMEBREW_VERBOSE=1
export HOMEBREW_CASK_OPTS=--appdir=/Applications\ --caskroom=/Applications/Caskroom

# gnulib


# }}}
################################################################################

#
# Languages {{{
#

# Go
export GOROOT=/usr/local/go
export GOPATH="${HOME}/go"
export GOMAXPROCS=8
export GOOS=darwin
export GOARCH=amd64
export GO15VENDOREXPERIMENT=1
export CGO_ENABLED=1
export GOROOT_BOOTSTRAP="/usr/local/bootstrap/go1.6"

# export HUB_VERBOSE=1

# python
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/.pythonrc"
export IPYTHONDIR="${XDG_CONFIG_HOME}/python/ipython"

# ruby ; rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if (( $+commands[rbenv] )); then
    eval "$(rbenv init -)"
fi


# Dockerfiles
# . ~/.zsh/plugins/dockerfunc


# Node
export NODEBREW_ROOT=/usr/local/var/nodebrew
export NODE_REPL_HISTORY=$HOME/.history/node/.node_repl_history


# Java
export JAVA_HOME=$(/usr/libexec/java_home)


# Vagrant
# export VAGRANT_DEFAULT_PROVIDER=virtualbox
# export VAGRANT_VMWARE_FUSION_APP=/Applications/VMware\ Fusion\ 7.app
# export VAGRANT_HOME=/Volumes/WD20EZRX/.vagrant.d/


# API token
source ~/.token


# asciidoc
export XML_CATALOG_FILES=/usr/local/etc/xml/catalog


# Adobe AFDKO
export FDK_EXE=/usr/local/bin/FDK/Tools/osx


# borg
export BORG_REPO=/Volumes/WD20EZRX/borg


# postgresql
export PGDATA=/usr/local/var/postgres


# for gnulib
export gl_cv_func_getcwd_abort_bug="no"

# opam configuration
. $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# }}}
################################################################################

#
# Path {{{
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path manpath pythonpath
typeset -gU PATH FPATH PYTHONPATH

path=(
  ${HOME}/bin(N-/)
  /usr/local/go/bin(N-/)
  ${GOPATH}/bin(N-/)
  /opt/newosxbook/bin(N-/)
  ${RBENV_ROOT}/shims(N-/)
  ${NODEBREW_ROOT}/current/bin(N-/)
  ${HOME}/.nimble/bin(N-/)
  ${HOME}/google-cloud-sdk/bin(N-/)
  /opt/coreutils/bin(N-/)
  /opt/binutils/bin(N-/)
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  /opt/llvm/bin(N-/)
  ${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin(N-/)
  ${DEVELOPER_DIR}/usr/bin(N-/)
  /{bin,sbin}
  /opt/apple/cmark/bin(N-/)
  /opt/apple/llbuild/bin(N-/)
  /opt/apple/lldb/bin(N-/)
  /opt/apple/llvm/bin(N-/)
  /opt/apple/swift/bin(N-/)
  $path
)


fpath=(
  ${HOME}/.zsh/functions(N-/)
  ${HOME}/.zsh/completions(N-/)
  ${ZSH_PLUGIN}/oh-my-zsh/plugins/brew(N-/)
  ${ZSH_PLUGIN}/zsh-completions/src(N-/)
  ${ZSH_PLUGIN}/zsh-syntax-highlighting(N-/)
  $fpath
)


manpath=(
  /usr/local/share/man(N-/)
  /opt/coreutils/share/man(N-/)
  /opt/binutils/share/man(N-/)
  /usr/share/man(N-/)
  $DEVELOPER_DIR/usr/share/man(N-/)
  /opt/newosxbook/share/man(N-/)
  /usr/local/share/man/ja(N-/)
  /usr/local/share/man/freebsd/man/ja(N-/)
  $manpath
)

# }}}
################################################################################

#
# Load each modules
#

. "$HOME/.zsh/alias.zsh"
. "$HOME/.zsh/completion.zsh"
. "$HOME/.zsh/dirhash.zsh"
. "$HOME/.zsh/function.zsh"
. "$HOME/.zsh/history.zsh"
. "$HOME/.zsh/key-bindings.zsh"
. "$HOME/.zsh/prompt.zsh"
. "$HOME/.zsh/utility.zsh"
. "$HOME/.zsh/zcompile.zsh"

. "$ZSH_MODULE/brew.zsh"
. "$ZSH_MODULE/docker.zsh"
. "$ZSH_MODULE/git.zsh"
. "$ZSH_MODULE/iab.zsh"
. "$ZSH_MODULE/ls_abbrev.zsh"
. "$ZSH_MODULE/peco.zsh"

. "$ZSH_PLUGIN/zsh-users/zsh-completions/zsh-completions.plugin.zsh"
. "$ZSH_PLUGIN/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# }}}
####################################################################################################

# Cleanup local environ
# unset ZSH_PLUGIN
# unset ZSH_MODULE
# unset DEVELOPER_DIR

# }}}
################################################################################
if [[ -n ${ZSH_DEBUG} ]]; then; echo 'Finished zshenv'; fi
