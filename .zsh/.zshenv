: ! "${PROMPT?exit 0}"
# https://neovim.io/doc/user/tips.html#speed-up
# http://stackoverflow.com/a/307735/5228839
#
# zshenv {{{
# Defines environment variables
#
# }}}
################################################################################
#
# DEBUG {{{
#

# export ZSH_DEBUG=1
if [[ -n $ZSH_DEBUG ]]; then; echo 'Loading zshenv'; fi

# }}}
################################################################################
#
# References {{{
#
# XDG Based Directory environment variables
#   - cf: http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
#   - cf: https://wiki.debian.org/XDGBaseDirectorySpecification
#   - cf: https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
#
# LD_LIBRARY_PATH, typeset
#   - http://d.hatena.ne.jp/yascentur/touch/20111111/1321015289
#
# Ansi color wiki
#   - https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
#
# $PROMPT_EOL_MARK: Removing trailing new line mark
#   - http://stackoverflow.com/questions/18213751/removing-trailing-new-line-after-printing-on-mac-os-x-zsh
#
# $CLICOLOR, $BLOCKSIZE: Set default blocksize for ls, df, du
#   - Ref: http://hints.macworld.com/comment.php?mode=view&cid=24491
#
# $LESS_TEMPCAP:
#   - http://stealthefish.com/development/2014/04/26/Better-bash-man-pages.html
#   - http://unix.stackexchange.com/questions/119/colors-in-man-pages/147#147
#   - http://unix.stackexchange.com/questions/108699/documentation-on-less-termcap-variables/108840#108840
#
# }}}
################################################################################
#
# Set enviroment caching
#   - unset in bottom of the .zshrc

# TODO: needs 'local'?
export DEVELOPER_DIR="$(xcode-select -p)"
export ZSH_PLUGIN=$HOME/.zsh/plugins
export ZSH_MODULE=$HOME/.zsh/modules

# }}}
################################################################################
#
# Low-level system configurations {{{
#

command ulimit -n 10000
export ZSH_COLORS=1

# }}}
################################################################################
#
# Path {{{
#

# Loading automatically settings XDG Base Directories
export XDG_RUNTIME_DIR="/run/user/zchee"
. $HOME/.zsh/plugins/o-pikozh/xdg-basedirs/xdg-basedirs
. $HOME/.zsh/plugins/o-pikozh/xdg-basedirs/xdg-runtime-dir
# Unofficial XDG environment variable
export XDG_LOG_HOME="${HOME}/.log"


# typeset to (lower|upper)case environment variable
[ -z "$ld_library_path" ] && typeset -xT LD_LIBRARY_PATH ld_library_path
[ -z "$include" ] && typeset -xT INCLUDE include
typeset -U path cdpath fpath manpath ld_library_path include

path=(
  ${HOME}/bin(N-/)
  /usr/local/go/bin(N-/)
  ${GOPATH}/bin(N-/)
  /usr/local/cuda/bin(N-/)
  /opt/newosxbook/bin(N-/)
  /opt/coreutils/bin(N-/)
  /opt/binutils/bin(N-/)
  /Applications/CMake.app/Contents/bin(N-/)
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  ${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin(N-/)
  /opt/llvm/bin(N-/)
  /opt/cern/root/bin(N-/)
  /opt/cern/cling/bin(N-/)
  ${DEVELOPER_DIR}/usr/bin(N-/)
  /{bin,sbin}
  ${RBENV_ROOT}/shims(N-/)
  ${NODEBREW_ROOT}/current/bin(N-/)
  ${HOME}/.nimble/bin(N-/)
  ${HOME}/google-cloud-sdk/bin(N-/)
  /usr/local/opt/afdko/Tools/osx(N-/)
  /opt/apple/llbuild/bin(N-/)
  /opt/apple/lldb/bin(N-/)
  /opt/apple/llvm/bin(N-/)
  /opt/apple/swift/bin(N-/)
  $path
)

fpath=(
  ${HOME}/.zsh/functions(N-/)
  ${HOME}/.zsh/completions(N-/)
  ${ZSH_PLUGIN}/zsh-users/zsh-completions/src(N-/)
  ${ZSH_PLUGIN}/zsh-users/zsh-syntax-highlighting(N-/)
  $fpath
)

manpath=(
  /opt/cern/root/man(N-/)
  /opt/llvm/share/man(N-/)
  /usr/local/share/man(N-/)
  ${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/man(N-/)
  ${DEVELOPER_DIR}/usr/share/man(N-/)
  /usr/share/man(N-/)
  /opt/coreutils/share/man(N-/)
  /opt/binutils/share/man(N-/)
  /usr/local/share/linux(N-/)
  /Applications/CMake.app/Contents/man(N-/)
  $manpath
)

ld_library_path=(
  /opt/llvm/lib(N-/)
  /opt/cern/root/lib(N-/)
  /usr/local/cuda/lib(N-/)
  /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/lib(N-/)
  /usr/local/lib(N-/)
  $(xcrun --show-sdk-path)/usr/lib(N-/)
  /usr/lib(N-/)
)

include=(
  /opt/llvm/include(N-/)
  /opt/cern/root/include(N-/)
  /usr/local/cuda/include(N-/)
  /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/include(N-/)
  /usr/local/include(N-/)
  $(xcrun --show-sdk-path)/usr/include(N-/)
  /usr/include(N-/)
  $include
)

# Use self build llvm compiler tool set
# /opt/llvm/lib(N-/)
# /opt/llvm/include(N-/)


# }}}
################################################################################
#
# Common terminal environment variables {{{
#

export SHELL="/usr/local/bin/zsh"
export TERM='xterm-256color'
export LC_CTYPE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
# export PROMPT_EOL_MARK=''

# Affected in all CUI tools
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER='less -R'
export MANPAGER='less -R'
export GIT="/usr/local/bin/git"

# export CLICOLOR=1
export BLOCKSIZE=1k

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

# ARFLAGS  - for ar achiver
# ASFLAGS  - for as assembler
# COFLAGS  - for co utility
# CPPFLAGS - for C preprocessor
# CXXFLAGS - for c++ compiler
# FFLAGS   - for Fortran compiler
# LFLAGS   - for lex
# PFLAGS   - for Pascal compiler
# YFLAGS   - for yacc

export CC="${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CXX="${CC}++"

export MAKEFLAGS="-j $(($(nproc)+1))"

export PYTHON_PREFIX="/usr/local/Frameworks/Python.framework/Versions/3.6"

# }}}
################################################################################
#
# Tools {{{
#

# Neovim
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export NVIM_LISTEN_ADDRESS='/tmp/nvim'

export DEIN_DIR=$HOME/.cache/nvim/dein/repos/github.com

# Use child sessions. faster?
# export NVIM_CHILD_ARGV='["nvim", "-u", "NONE", "--embed"]'
# Logging for development plugins
export NVIM_VERBOSE_LOG_FILE="${XDG_LOG_HOME}/nvim/verbose.log"
if [[ -d "${XDG_LOG_HOME}/nvim/go" ]]; then
  mkdir -p "${XDG_LOG_HOME}/nvim/go"
fi
if [[ -d "${XDG_LOG_HOME}/nvim/python" ]]; then
  mkdir -p "${XDG_LOG_HOME}/nvim/python"
fi
export NVIM_GO_LOG_FILE="${XDG_LOG_HOME}/nvim/go/client.log"
export NEOVIM_GO_LOG_FILE="${XDG_LOG_HOME}/nvim/go/client.log"
# If always export NVIM_PYTHON_LOG_FILE, nvim will be parse log file path
# export NVIM_PYTHON_LOG_FILE="${XDG_LOG_HOME}/nvim/python/python-client.log"
# export NVIM_PYTHON_LOG_LEVEL="DEBUG"


# gdb
export GDBHISTFILE="$HOME/.history/.gdb_history"


# cURL
#  - Ref: https://gist.github.com/1stvamp/2158128#gistcomment-1573222
#  - Ref: https://github.com/smdahlen/vagrant-digitalocean/issues/123
export CURL_CA_BUNDLE="/usr/local/etc/ssl/certs/curl-ca-bundle.crt"
export SSL_CERT_FILE="/usr/local/etc/ssl/certs/curl-ca-bundle.crt"



# Docker
# Machine
export MACHINE_DEBUG=1
export MACHINE_DRIVER_DEBUG=1
# Always use experimental install
export MACHINE_DOCKER_INSTALL_URL="https://experimental.docker.com"
export MACHINE_NATIVE_SSH=1
# export MACHINE_BUGSNAG_API_TOKEN=


# dircolors
eval "$(/opt/coreutils/bin/dircolors --sh)"


# Less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-g -i -M -R -S -w -z -4 -X -F'
# export LESS=-asrRix8
export LESSOPEN='| src-hilite-lesspipe.sh %s'
# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
    export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi


# google cloud sdk
# gcloud support only python2 when install gcloud
export CLOUDSDK_PYTHON="/usr/local/bin/python2"


# z.sh
export _Z_DATA="${XDG_CACHE_HOME}/z/.z"
if ! [ -f "$_Z_DATA" ]; then
    mkdir -p "${XDG_CACHE_HOME}/z"
    touch "$_Z_DATA"
fi


# nq
# TODO: Need more useful managing job tool written Go
export NQDIR=/tmp/nq
if [[ ! -d "$NQDIR" ]]; then
    mkdir "$NQDIR"
fi


# jtool, procexp
export JCOLOR=1


# Homebrew
export HOMEBREW_CACHE="${XDG_CACHE_HOME}/Homebrew"
export HOMEBREW_DEBUG=1
export HOMEBREW_DEVELOPER=1
export HOMEBREW_MAKE_JOBS=8
export HOMEBREW_VERBOSE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/Applications/Caskroom"


# }}}
################################################################################

#
# Languages {{{
#

# Go
export GOROOT="/usr/local/go"
export GOPATH="${HOME}/go"
export GOMAXPROCS=8
export GOOS="darwin"
export GOARCH="amd64"
export GO15VENDOREXPERIMENT=1
export CGO_ENABLED=1
export GOROOT_BOOTSTRAP="/usr/local/bootstrap/go1.6"


# Jupyter
export JUPYTER_RUNTIME_DIR="$XDG_RUNTIME_DIR/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_PATH="$XDG_DATA_HOME/jupyter"


# Python
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/.pythonrc"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"

# Ruby
export RBENV_ROOT="/usr/local/var/rbenv"
if (( $+commands[rbenv] )); then
    eval "$(rbenv init -)"
fi


# Node
export NODEBREW_ROOT="/usr/local/var/nodebrew"
export NODE_REPL_HISTORY="$HOME/.history/node/.node_repl_history"


# Java
export JAVA_HOME=$(/usr/libexec/java_home)


# Vagrant
# export VAGRANT_DEFAULT_PROVIDER=virtualbox
# export VAGRANT_VMWARE_FUSION_APP=/Applications/VMware\ Fusion\ 7.app
# export VAGRANT_HOME=/Volumes/WD20EZRX/.vagrant.d/


# API token
. "$XDG_DATA_HOME/token/token"


# asciidoc
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"


# Adobe AFDKO
export FDK_EXE="/usr/local/opt/afdko/Tools/osx"


# borg
export BORG_REPO="/Volumes/WD20EZRX/borg"


# postgresql
export PGDATA="/usr/local/var/postgres"


# gnulib issue
export gl_cv_func_getcwd_abort_bug="no"

# OCaml
. $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# }}}
################################################################################
if [[ -n ${ZSH_DEBUG} ]]; then; echo 'Finished zshenv'; fi
