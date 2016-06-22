# zshenv {{{
# Defines environment variables
# export ZSH_DEBUG=1
[[ -n $ZSH_DEBUG ]] && echo 'Loading zshenv'
# -----------------------------------------------------------------------------
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
# -----------------------------------------------------------------------------
# compinit
autoload -Uz compinit zrecompile; compinit

# Environment caching
#   - unset in bottom of the .zshrc
# TODO: needs 'local'?

if [[ -d "/Applications/Xcode-beta.app/Contents/Developer" ]]; then
export DEVELOPER_DIR="/Applications/Xcode-beta.app/Contents/Developer"
elif [[ -d "/Applications/Xcode.app/Contents/Developer" ]]; then
  export DEVELOPER_DIR="/Applications/Xcode-beta.app/Contents/Developer"
fi
# export DEVELOPER_DIR="$(xcode-select -p)"
ZSH_PLUGIN=$HOME/.zsh/plugins
ZSH_MODULE=$HOME/.zsh/modules
DOTFILES=$HOME/src/github.com/zchee/dotfiles

# }}}
# -----------------------------------------------------------------------------
# System {{{

command ulimit -n 10000
export ZSH_COLORS=1

# }}}
# -----------------------------------------------------------------------------
# Path {{{

# Loading automatically settings XDG Base Directories
export XDG_RUNTIME_DIR="/run/user/501"
. $HOME/.zsh/plugins/o-pikozh/xdg-basedirs/xdg-basedirs
. $HOME/.zsh/plugins/o-pikozh/xdg-basedirs/xdg-runtime-dir
# Unofficial XDG environment variable
export XDG_LOG_HOME="${XDG_DATA_HOME}/var/log"


# }}}
# -----------------------------------------------------------------------------
# Common terminal environment variables {{{

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
export BROWSER="/Applications/Chromium.app/Contents/MacOS/Chromium"

# export CLICOLOR=1
export BLOCKSIZE=1k

if [[ "$OSTYPE" == darwin* ]]; then
  # export BROWSER=open
  export BROWSER=/Applications/Chromium.app/Contents/MacOS/Chromium # for pprof
fi
export CACHE=$XDG_CACHE_HOME

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# }}}
# -----------------------------------------------------------------------------
# Build {{{

# ARFLAGS  - for ar achiver
# ASFLAGS  - for as assembler
# COFLAGS  - for co utility
# CPPFLAGS - for C preprocessor
# CXXFLAGS - for c++ compiler
# FFLAGS   - for Fortran compiler
# LFLAGS   - for lex
# PFLAGS   - for Pascal compiler
# YFLAGS   - for yacc

# export CC="${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CC='clang'
export CXX="${CC}++"
# export MAKEFLAGS="-j $(($(/opt/coreutils/bin/nproc)+1))" # exec command too slow
export MAKEFLAGS="-j"

# }}}
# -----------------------------------------------------------------------------
# Tools {{{

# Neovim
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export NVIM_LISTEN_ADDRESS='/tmp/nvim'
# export NVIM_CHILD_ARGV='["nvim", "-u", "NONE", "--embed"]'
# Logging for development plugins
export NVIM_VERBOSE_LOG_FILE="${XDG_LOG_HOME}/nvim/verbose.log"
export NVIM_GO_DEBUG=1
if [[ -d "${XDG_LOG_HOME}/nvim/go" ]]; then
  mkdir -p "${XDG_LOG_HOME}/nvim/go"
fi
if [[ -d "${XDG_LOG_HOME}/nvim/python" ]]; then
  mkdir -p "${XDG_LOG_HOME}/nvim/python"
fi
export NEOVIM_GO_LOG_FILE="${XDG_LOG_HOME}/nvim/go/neovim-go.log"
# If always export NVIM_PYTHON_LOG_FILE, nvim will be parse log file path
# export NVIM_PYTHON_LOG_FILE="${XDG_LOG_HOME}/nvim/python/python-client.log"
# export NVIM_PYTHON_LOG_LEVEL="DEBUG"
export NVIM_IPY_DEBUG_FILE="${XDG_LOG_HOME}/nvim/python/nvim-ipy.log"
export NVIM_DEOPLETE_JEDI_LOG_FILE="${XDG_LOG_HOME}/nvim/python/deoplete.log"


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
export MACHINE_DOCKER_INSTALL_URL="https://experimental.docker.com" # Always use experimental install
export MACHINE_NATIVE_SSH=1

# grep
export GREP_COLOR='30;43'           # BSD
export GREP_COLORS="mt=$GREP_COLOR" # GNU

# dircolors
# eval "$(/opt/coreutils/bin/dircolors --sh)"
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=01;37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:';


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
export CLOUDSDK_PYTHON="python2"


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
# -----------------------------------------------------------------------------
# Languages {{{

# Go
export GOPATH="${HOME}/go"
export GOROOT_BOOTSTRAP="/usr/local/bootstrap/go/go1.4.3"
export GO15VENDOREXPERIMENT=1
export CGO_ENABLED=1


# Jupyter
export JUPYTER_RUNTIME_DIR="$XDG_RUNTIME_DIR/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_PATH="$XDG_DATA_HOME/jupyter"


# Python
export PYTHON_CONFIGURE_OPTS="--enable-shared"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/.pythonrc"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"

# Ruby
export RBENV_ROOT="/usr/local/var/rbenv"
# if (( $+commands[rbenv] )); then
#     eval "$(rbenv init -)"
# fi


# Node
export NODEBREW_ROOT="/usr/local/var/nodebrew"
export NODE_REPL_HISTORY="$HOME/.history/node/.node_repl_history"


# Java
export JAVA_HOME=$(/usr/libexec/java_home)


# Ocaml
# export PERL5LIB="$HOME/.opam/system/lib/perl5"
# . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

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

# }}}
# -----------------------------------------------------------------------------
# Global Environment variables

# typeset to (lower|upper)case environment variable
local -a _typeset

_typeset=(
  CLASSPATH \
  CPATH \
  DAALROOT \
  DYLD_LIBRARY_PATH \
  FPATH \
  INCLUDE \
  INTEL_LICENSE_FILE \
  INTEL_PYTHONHOME \
  IPPROOT \
  LD_LIBRARY_PATH \
  LIBRARY_PATH \
  MANPATH \
  MKLROOT \
  NLSPATH \
  PATH \
  PERL5LIB \
  TBBROOT \
)

for type in $_typeset[@]; do
  [ -z $"${type:l}" ] && typeset -xT ${type} ${type:l}
done
typeset -U "$_typeset[@]:l"

path=(
  ${HOME}/bin(N-/)
  /Applications/Docker.app/Contents/Resources/bin(N-/)
  /usr/local/go/bin(N-/)
  ${GOPATH}/bin(N-/)
  /opt/intel/bin(N-/)
  /opt/intel/intelpython35/bin(N-/)
  /opt/intel/intelpython27/bin(N-/)
  ${HOME}/.local/bin(N-/)
  ${HOME}/.pyenv/bin(N-/)
  ${RBENV_ROOT}/shims(N-/)
  ${NODEBREW_ROOT}/current/bin(N-/)
  ${HOME}/.nimble/bin(N-/)
  ${HOME}/google-cloud-sdk/bin(N-/)
  /usr/local/cuda/bin(N-/)
  /opt/newosxbook/bin(N-/)
  /opt/coreutils/bin(N-/)
  /opt/binutils/bin(N-/)
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}(N-/)
  ${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin(N-/)
  /opt/llvm/bin(N-/)
  /opt/cern/root/bin(N-/)
  /opt/cern/cling/bin(N-/)
  ${DEVELOPER_DIR}/usr/bin(N-/)
  /{bin,sbin}(N-/)
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
  /usr/local/opt/git/share/zsh/site-functions(N-/)
  ${HOME}/src/github.com/zchee/go-zsh-completions(N-/)
  ${ZSH_PLUGIN}/zsh-users/zsh-completions/src(N-/)
  ${ZSH_PLUGIN}/zsh-users/zsh-syntax-highlighting(N-/)
  $fpath
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

ld_library_path=(
  /opt/intel/lib(N-/)
  /opt/llvm/lib(N-/)
  /opt/cern/root/lib(N-/)
  /usr/local/cuda/lib(N-/)
  /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/lib(N-/)
  /usr/local/lib(N-/)
  $(xcrun --show-sdk-path)/usr/lib(N-/)
  /usr/lib(N-/)
  $ld_library_path
)

manpath=(
  /opt/intel/man/common(N-/)
  /opt/intel/man/gdb-ia(N-/)
  /opt/llvm/share/man(N-/)
  /usr/local/share/man(N-/)
  ${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/share/man(N-/)
  ${DEVELOPER_DIR}/usr/share/man(N-/)
  /usr/share/man(N-/)
  /opt/coreutils/share/man(N-/)
  /opt/binutils/share/man(N-/)
  /usr/local/share/linux(N-/)
  /opt/cern/root/man(N-/)
  $manpath
)

# Intel compiler toolchain
export CLASSPATH=/opt/intel/compilers_and_libraries/mac/daal/lib/daal.jar
export DAALROOT=/opt/intel/compilers_and_libraries/mac/daal
export INTEL_LICENSE_FILE=/opt/intel/licenses
export INTEL_PYTHONHOME=/opt/intel/debugger_2017/python/intel64
export IPPROOT=/opt/intel/compilers_and_libraries/mac/ipp
export MKLROOT=/opt/intel/compilers_and_libraries/mac/mkl
export TBBROOT=/opt/intel/compilers_and_libraries/mac/tbb

export CPATH=/opt/intel/compilers_and_libraries/mac/daal/include:/opt/intel/compilers_and_libraries/mac/ipp/include:/opt/intel/compilers_and_libraries/mac/mkl/include:/opt/intel/compilers_and_libraries/mac/tbb/include
export DYLD_LIBRARY_PATH=/opt/intel/compilers_and_libraries/mac/lib:/opt/intel/compilers_and_libraries/mac/lib/intel64:/opt/intel/compilers_and_libraries/mac/daal/lib:/opt/intel/compilers_and_libraries/mac/ipp/lib:/opt/intel/compilers_and_libraries/mac/mkl/lib:/opt/intel/compilers_and_libraries/mac/tbb/lib
export LIBRARY_PATH=/opt/intel/compilers_and_libraries/mac/lib:/opt/intel/compilers_and_libraries/mac/tbb/lib:/opt/intel/compilers_and_libraries/mac/daal/lib:/opt/intel/compilers_and_libraries/mac/ipp/lib:/opt/intel/compilers_and_libraries/mac/mkl/lib
export NLSPATH=/opt/intel/compilers_and_libraries/mac/lib/locale/en_US:/opt/intel/compilers_and_libraries/mac/mkl/lib/locale/en_US
# Why can't use it?
# cpath=(
#   /opt/intel/include(N-/)
#   /opt/intel/compilers_and_libraries/mac/daal/include(N-/)
#   /opt/intel/compilers_and_libraries/mac/ipp/include(N-/)
#   /opt/intel/compilers_and_libraries/mac/mkl/include(N-/)
#   /opt/intel/compilers_and_libraries/mac/tbb/include(N-/)
#   $cpath
# )
# dyld_library_path=(
#   /opt/intel/compilers_and_libraries/mac/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/lib/intel64(N-/)
#   /opt/intel/compilers_and_libraries/mac/daal/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/ipp/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/mkl/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/tbb/lib(N-/)
#   $dyld_library_path
# )
# library_path=(
#   /opt/intel/compilers_and_libraries/mac/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/tbb/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/daal/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/ipp/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/mkl/lib(N-/)
#   /opt/intel/compilers_and_libraries/mac/tbb/lib(N-/)
#   $library_path
# )
# nlspath=(
#   /opt/intel/compilers_and_libraries/mac/lib/locale/en_US(N-/)
#   /opt/intel/compilers_and_libraries/mac/mkl/lib/locale/en_US(N-/)
#   $nlspath
# )

# }}}
# -----------------------------------------------------------------------------

if [[ -n ${ZSH_DEBUG} ]]; then; echo 'Finished zshenv'; fi
