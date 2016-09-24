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

# Environment caching
#   - unset in bottom of the .zshrc
# TODO: needs 'local'?

if [[ -d "/Applications/Xcode-beta.app/Contents/Developer" ]]; then
  export DEVELOPER_DIR="/Applications/Xcode-beta.app/Contents/Developer"
elif [[ -d "/Applications/Xcode.app/Contents/Developer" ]]; then
  export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
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
# bash like time output
# export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

# }}}
# -----------------------------------------------------------------------------
# Path {{{

# Loading automatically settings XDG Base Directories
: ${XDG_RUNTIME_DIR:=/run/user/501}
: ${XDG_DATA_HOME:=$HOME/.local/share}
: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${XDG_DATA_DIRS:=/usr/local/share:/usr/share}
: ${XDG_CONFIG_DIRS:=/etc/xdg}
: ${XDG_CACHE_HOME:=$HOME/.cache}
: ${XDG_LOG_HOME:=$HOME/.local/var/log}

# }}}
# -----------------------------------------------------------------------------
# Common terminal environment variables {{{

export CACHE=$XDG_CACHE_HOME
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export SHELL="/usr/local/bin/zsh"
export TERM='xterm-256color'
export TERMINFO='/usr/local/share/terminfo'

# Affected in all CUI tools
export BROWSER="/Applications/Chromium.app/Contents/MacOS/Chromium"
export EDITOR="nvim"
export MANPAGER='less -R'
export PAGER='less -R'
export VISUAL="nvim"

export CLICOLOR=1
export BLOCKSIZE=1k

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER=/Applications/Chromium.app/Contents/MacOS/Chromium # for pprof
fi

export PROMPT_EOL_MARK='%'

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

# export CC='clang'
export CC="$(xcrun -f clang)"
export CXX="${CC}++"
export ARCHFLAGS='-arch x86_64'
# export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig"

# export MAKEFLAGS="-j $(($(/opt/coreutils/bin/nproc)+1))" # exec command too slow
export MAKEFLAGS="-j 9"
export MACOSX_DEPLOYMENT_TARGET=10.12

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
export NVIM_DEOPLETE_LOG_FILE="${XDG_LOG_HOME}/nvim/python/deoplete.log"
export NVIM_DEOPLETE_JEDI_LOG_FILE="${XDG_LOG_HOME}/nvim/python/deoplete.log"
export NVIM_DEOGOTO_LOG_FILE="${HOME}/.local/var/log/nvim/python/deogoto.log"


# gdb
export GDBHISTFILE="$HOME/.history/.gdb_history"


# cURL
#  - Ref: https://gist.github.com/1stvamp/2158128#gistcomment-1573222
#  - Ref: https://github.com/smdahlen/vagrant-digitalocean/issues/123
# export CURL_CA_BUNDLE="/usr/local/etc/openssl/certs/cert.pem"
export CURL_CA_BUNDLE="/usr/local/etc/libressl/cert.pem"



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
export HOMEBREW_MAKE_JOBS=8
export HOMEBREW_VERBOSE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/Applications/Caskroom"

# }}}
# -----------------------------------------------------------------------------
# Languages {{{

# Go
export GOPATH="${HOME}/go"
# export GOROOT_BOOTSTRAP="/usr/local/go-darwin-amd64-bootstrap"
export GOROOT_BOOTSTRAP="/usr/local/bootstrap/go/go1.7.1"
export GO15VENDOREXPERIMENT=1
export CGO_ENABLED=1


# Python
# It is strongly recommended that PYTHONHOME and PYTHONPATH be unset,
# as they can interfere with the Intel® Distribution for Python for OS X.
# export PYTHON_CONFIGURE_OPTS="--enable-shared"
# export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/.pythonrc"
# pyenv
# export PYENV_ROOT=/usr/local/var/pyenv
# export VIRTUAL_ENV_DISABLE_PROMPT=1
# Jupyter
export JUPYTER_RUNTIME_DIR="${XDG_RUNTIME_DIR}/jupyter"
export JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}/jupyter"
export JUPYTER_PATH="${XDG_DATA_HOME}/jupyter"
# IPython
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
# pip for Makefile
export PIP_FLAGS='--user'


# OCaml
eval `opam config env`


# Ruby
export RBENV_ROOT="/usr/local/var/rbenv"


# Node
export NODEBREW_ROOT="/usr/local/var/nodebrew"
export NODE_REPL_HISTORY="${HOME}/.history/node/.node_repl_history"


# Java
# export JENV_ROOT=/usr/local/var/jenv
# if which jenv > /dev/null; then eval "$(jenv init -)"; fi
# export JAVA_HOME=$(/usr/libexec/java_home)
# export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home'


# API token
. "$XDG_DATA_HOME/token/token"


# asciidoc (brew)
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"


# Adobe AFDKO
export FDK_EXE="/usr/local/opt/afdko/Tools/osx"


# borg
export BORG_REPO="/Volumes/WD20EZRX/borg"


# postgresql
export PGDATA="/usr/local/var/postgres"


# gnulib issue (brew)
export gl_cv_func_getcwd_abort_bug="no"

# }}}
# -----------------------------------------------------------------------------
# Global Environment variables
#

# typeset to (lower|upper)case environment variable
local -a _typeset
_typeset=(
  INCLUDE \
  LD_LIBRARY_PATH \
  \
  CLASSPATH \
  CPATH \
  DAALROOT \
  DYLD_LIBRARY_PATH \
  INTEL_LICENSE_FILE \
  INTEL_PYTHONHOME \
  IPPROOT \
  LIBRARY_PATH \
  MKLROOT \
  NLSPATH \
  PERL5LIB \
  TBBROOT \
)
for type in $_typeset[@]; do
  typeset -xT ${type} ${type:l}
done
# Specific directory path (PATH, CDPATH, FPATH, MANPATH) is set by default.
typeset -U path cdpath fpath manpath
typeset -U "$_typeset[@]:l"

path=(
  # dotfiles scripts
  ${HOME}/bin(N-/)
  # The Go language toolchain
  /usr/local/go/bin(N-/)
  ${GOPATH}/bin(N-/)
  # Intel® C++ compilers runtime
  /opt/intel/bin(N-/)
  # Intel® Distribution for Python2 and 3
  /opt/intel/intelpython{3,2}/bin(N-/)
  # Apple File System(apfs) command line tools
  /System/Library/Filesystems/apfs.fs/Contents/Resources(N-/)
  # NVIDIA CUDA Toolkit
  /Developer/NVIDIA/CUDA/bin(N-/)
  /usr/local/cuda/bin(N-/)
  # Docker for Mac pre-compile binary
  ${HOME}/Library/Group\ Containers/group.com.docker/bin(N-/)
  # google cloud sdk
  ${HOME}/google-cloud-sdk/bin(N-/)
  # installed with pip, etc
  ${HOME}/.local/bin(N-/)
  # rust
  ${HOME}/.cargo/bin(N-/)
  # pyenv, rbenv, nodebrew, jenv
  # ${PYENV_ROOT}/{bin,shims}(N-/)
  ${RBENV_ROOT}/{bin,shims}(N-/)
  ${NODEBREW_ROOT}/current/bin(N-/)
  # ${JENV_ROOT}/bin(N-/)

  # brewed GNU {sed, coreutils} with default names
  /usr/local/opt/{gnu-sed,coreutils}/libexec/gnubin(N-/)
  # brewed GNU tar
  /usr/local/opt/gnu-tar/bin(N-/)
  # brewed git contrib diff-highlight script
  /usr/local/opt/git/share/git-core/contrib/diff-highlight(N-/)
  # Adobe Font Development Kit (afdko)
  /opt/adobe/afdko/Tools/osx(N-/)
  # nexosxbook(Author of Mac OS X and iOS Internals book) darwin utility
  ${HOME}/src/newosxbook.com/bin(N-/)
  # Xcode compiler toolchain
  ${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/bin(N-/)
  ${DEVELOPER_DIR}/usr/bin(N-/)
  # Linux filesystem default binary path
  /usr/local/{bin,sbin}(N-/)
  # Oracle Java
  ${JAVA_HOME}/bin(N-/)
  # Linux filesystem default binary path
  /usr/{bin,sbin}(N-/)
  /{bin,sbin}(N-/)
  ${path}
)

fpath=(
  ${HOME}/.zsh/functions(N-/)
  ${HOME}/.zsh/completions(N-/)
  ${HOME}/.zsh/completions/{zsh-completions,go,macOS}/src(N-/)
  /usr/local/opt/git/share/zsh/site-functions(N-/)
  ${ZSH_PLUGIN}/zsh-users/zsh-completions/src(N-/)
  ${ZSH_PLUGIN}/zsh-users/zsh-syntax-highlighting(N-/)
  ${fpath}
)

cdpath=(
  ${GOPATH}/src/github.com(N-/)
  ${GOPATH}/src/golang.org/x(N-/)
  ${GOPATH}/src(N-/)
  ${HOME}/src/github.com(N-/)
  ${cdpath}
)

manpath=(
  /opt/intel/man/common(N-/)
  /opt/intel/man/gdb-ia(N-/)
  /opt/llvm/share/man(N-/)
  /usr/local/opt/gnu-sed/libexec/gnuman(N-/)
  /usr/local/opt/gnu-tar/libexec/gnuman(N-/)
  /usr/local/opt/coreutils/libexec/gnuman(N-/)
  /usr/local/share/man(N-/)
  ${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/share/man(N-/)
  ${DEVELOPER_DIR}/usr/share/man(N-/)
  /usr/share/man(N-/)
  /opt/coreutils/share/man(N-/)
  /opt/binutils/share/man(N-/)
  /usr/local/share/linux(N-/)
  /opt/cern/root/man(N-/)
  ${manpath}
)

include=(
  ${HOME}/.local/include(N-/)
  /opt/llvm/include(N-/)
  /opt/cern/root/include(N-/)
  /usr/local/cuda/include(N-/)
  /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/include(N-/)
  /usr/local/include(N-/)
  $(xcrun --show-sdk-path)/usr/include(N-/)
  ${HOME}/src/newosxbook.com/include(N-/)
  /usr/include(N-/)
  ${include}
)

ld_library_path=(
  /opt/intel/lib(N-/)
  /opt/intel/intelpython{3,2}/lib(N-/)
  /opt/llvm/lib(N-/)
  /opt/cern/root/lib(N-/)
  /usr/local/cuda/lib(N-/)
  /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/lib(N-/)
  /usr/local/lib(N-/)
  $(xcrun --show-sdk-path)/usr/lib(N-/)
  /usr/lib(N-/)
  ${ld_library_path}
)

dyld_library_path=(
  /opt/intel/compilers_and_libraries/mac/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/lib/intel64(N-/)
  /opt/intel/compilers_and_libraries/mac/daal/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/ipp/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/mkl/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/tbb/lib(N-/)
  /Developer/NVIDIA/CUDA/lib(N-/)
  ${dyld_library_path}
)
library_path=(
  /opt/intel/compilers_and_libraries/mac/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/tbb/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/daal/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/ipp/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/mkl/lib(N-/)
  /opt/intel/compilers_and_libraries/mac/tbb/lib(N-/)
  ${library_path}
)

# Intel® C++ compilers runtime
classpath=(
  /opt/intel/compilers_and_libraries/mac/daal/lib/daal.jar
  ${classpath}
)
daalroot=(
  /opt/intel/compilers_and_libraries/mac/daal
  ${daalroot}
)
intel_license_file=(
  /opt/intel/licenses
  ${intel_license_file}
)
intel_pythonhome=(
  /opt/intel/debugger_2017/python/intel64
  ${intel_pythonhome}
)
ipproot=(
  /opt/intel/compilers_and_libraries/mac/ipp
  ${ipproot}
)
mklroot=(
  /opt/intel/compilers_and_libraries/mac/mkl
  ${mklroot}
)
tbbroot=(
  /opt/intel/compilers_and_libraries/mac/tbb
  ${tbbroot}
)
nlspath=(
  /opt/intel/compilers_and_libraries/mac/lib/locale/en_US(N-/)
  /opt/intel/compilers_and_libraries/mac/mkl/lib/locale/en_US(N-/)
  ${nlspath}
)
cpath=(
  /opt/intel/compilers_and_libraries_2017.0.065/mac/ipp/include(N-/)
  /opt/intel/compilers_and_libraries_2017.0.065/mac/mkl/include(N-/)
  /opt/intel/compilers_and_libraries_2017.0.065/mac/tbb/include(N-/)
  /opt/intel/compilers_and_libraries_2017.0.065/mac/daal/include(N-/)
  /usr/local/include(N-/)
  /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include(N-/)
  ${cpath}
)

# }}}
# -----------------------------------------------------------------------------

if [[ -n ${ZSH_DEBUG} ]]; then; echo 'Finished zshenv'; fi
