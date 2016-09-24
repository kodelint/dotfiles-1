# Copy this to 'local.mk' in the repository root.
# Individual entries must be uncommented to take effect.

# By default, the installation prefix is '/usr/local'.
# CMAKE_EXTRA_FLAGS += -DCMAKE_INSTALL_PREFIX=/usr/local/nvim-latest

# These CFLAGS can be used in addition to those specified in CMakeLists.txt:
# CMAKE_EXTRA_FLAGS="-DCMAKE_C_FLAGS=-ftrapv -Wlogical-op"

# By default, the jemalloc family of memory allocation functions are used.
# Uncomment the following to instead use libc memory allocation functions.
# CMAKE_EXTRA_FLAGS += -DENABLE_JEMALLOC=OFF
# CMAKE_EXTRA_FLAGS += -DENABLE_TCMALLOC=OFF

# Sets the build type; defaults to Debug. Valid values:
#
# - Debug:          Disables optimizations (-O0), enables debug information and logging.
#
# - Dev:            Enables all optimizations that do not interfere with
#                   debugging (-Og if available, -O2 and -g if not).
#                   Enables debug information and logging.
#
# - RelWithDebInfo: Enables optimizations (-O2) and debug information.
#                   Disables logging.
#
# - MinSizeRel:     Enables all -O2 optimization that do not typically
#                   increase code size, and performs further optimizations
#                   designed to reduce code size (-Os).
#                   Disables debug information and logging.
#
# - Release:        Same as RelWithDebInfo, but disables debug information.
#
# CMAKE_BUILD_TYPE := Debug

# By default, nvim's log level is INFO (1) (unless CMAKE_BUILD_TYPE is
# "Release", in which case logging is disabled).
# The log level must be a number DEBUG (0), INFO (1), WARNING (2) or ERROR (3).
# CMAKE_EXTRA_FLAGS += -DMIN_LOG_LEVEL=0

# By default, nvim uses bundled versions of its required third-party
# dependencies.
# Uncomment these entries to instead use system-wide installations of
# them.
#
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_BUSTED=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_DEPS=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_JEMALLOC=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LIBTERMKEY=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LIBUV=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LIBVTERM=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LUAJIT=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LUAROCKS=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_MSGPACK=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_UNIBILIUM=OFF

# By default, bundled libraries are statically linked to nvim.
# This has no effect for non-bundled deps, which are always dynamically linked.
# Uncomment these entries to instead use dynamic linking.
#
# CMAKE_EXTRA_FLAGS += -DLIBTERMKEY_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DLIBUNIBILIUM_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DLIBUV_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DLIBVTERM_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DLUAJIT_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DMSGPACK_USE_STATIC=OFF

# Use clang Address Sanitizer, Undefined Behavior Sanitizer
# CMAKE_EXTRA_FLAGS += -DCLANG_ASAN_UBSAN=ON
# Use clang Memory Sanitizer
# CMAKE_EXTRA_FLAGS += -DCLANG_MSAN=ON
# Use clang Thread Sanitizer
# CMAKE_EXTRA_FLAGS += -DCLANG_TSAN=ON


# Default is icc(Intel C++ compiler)
# CC := icc
# CXX := icpc
CMAKE_C_COMPILER := $(CC)
CMAKE_CXX_COMPILER := $(CXX)

CMAKE_EXTRA_FLAGS += -DCMAKE_SHARED_LINKER_FLAGS='-framework Foundation -framework CoreServices -framework ApplicationServices -framework OpenGL -framework Security -lm'

# Build architectures for OS X
CMAKE_EXTRA_FLAGS += -DCMAKE_OSX_ARCHITECTURES=x86_64
# Minimum OS X version to target
CMAKE_EXTRA_FLAGS += -DCMAKE_OSX_DEPLOYMENT_TARGET=10.12
# The product will be built against the headers and libraries located inside the indicated SDK.
CMAKE_EXTRA_FLAGS += -DCMAKE_OSX_SYSROOT=$(shell xcrun --show-sdk-path)
# Create compile_commands.json
CMAKE_EXTRA_FLAGS += -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
# Disable Dev warning
CMAKE_EXTRA_FLAGS += -Wno-dev

ifeq ($(DEBUG),)
	# Release build
	CMAKE_BUILD_TYPE  := Release
	CMAKE_EXTRA_FLAGS += -DMIN_LOG_LEVEL=1
ifeq ($(CC),icc)
	# -march=native: Allow use CPU full feature set(auto-detection and optimizations)
	# -fast: enable -xHOST -O3 -ipo -no-prec-div -mdynamic-no-pic -fp-model fast=2
	CMAKE_EXTRA_FLAGS += -DCMAKE_C_FLAGS_RELEASE='-march=native -fast -Wno-expansion-to-defined -I/opt/intel/tbb/include -DHAVE_TBBMALLOC'
	CMAKE_EXTRA_FLAGS += -DENABLE_JEMALLOC=OFF
	# -static-intel: Link Intel provided libraries statically
	# -static-libstdc++: Link libstdc++ statically
	CMAKE_EXTRA_FLAGS += -DCMAKE_SHARED_LINKER_FLAGS='-static-intel -L/opt/intel/tbb/lib -ltbbmalloc'
	CMAKE_EXTRA_FLAGS += -DCMAKE_EXE_LINKER_FLAGS='-static-intel -L/opt/intel/tbb/lib -ltbbmalloc'
	CMAKE_EXTRA_FLAGS += -DCMAKE_MODULE_LINKER_FLAGS='-static-intel -L/opt/intel/tbb/lib -ltbbmalloc'
else
	# -march=native: Allow use CPU full feature set(auto-detection and optimizations)
	# -flto: Clang Link Time Optimization Build
	CMAKE_EXTRA_FLAGS += -DCMAKE_C_FLAGS_RELEASE='-march=native -Ofast -flto'
	CMAKE_EXTRA_FLAGS += -DCMAKE_SHARED_LINKER_FLAGS='-flto'
	CMAKE_EXTRA_FLAGS += -DCMAKE_EXE_LINKER_FLAGS='-flto'
	CMAKE_EXTRA_FLAGS += -DCMAKE_MODULE_LINKER_FLAGS='-flto'
endif
else
	# Debug build
	CMAKE_BUILD_TYPE  := Debug
	CMAKE_EXTRA_FLAGS += -DMIN_LOG_LEVEL=0
endif


# Override make jobs

GIT_BRANCH := $(shell git branch | sed 's/*/ /')
ORGANIZATION_NAME ?= neovim
REPOSITORY_NAME ?= neovim

all:

rebuild:
	export MACOSX_DEPLOYMENT_TARGET=10.12
	rm -rf build
	make

force-rebuild:
	export MACOSX_DEPLOYMENT_TARGET=10.12
	make distclean
	make deps || true
	make

install/strip:
	cd build; ninja $@

install/libnvim: libnvim
	install -m0755 ./build/lib/libnvim.a /usr/local/lib

fetch:
	git fetch origin
	git rebase origin/master --autostash

branch/rebase:
	set -e; for branch in $(GIT_BRANCH); do git checkout $$branch; git rebase origin/master --autostash; done || exit 1
	git checkout devel

branch/push:
	set -e; for branch in $(GIT_BRANCH); do git push zchee $$branch --force; done || exit 1

msgpack-c:
	git checkout third-party/$@
	@curl -s https://api.github.com/repos/msgpack/$@/commits/master | jq '.sha' | sed 's/"//g'
	@curl -L --silent https://github.com/msgpack/$@/archive/$$(curl -s https://api.github.com/repos/msgpack/$@/commits/master | jq '.sha' | sed 's/"//g').tar.gz | shasum -a 256 | awk '{print $$1}'

jemalloc:
	git checkout third-party/$@
	@curl -s https://api.github.com/repos/$@/$@/commits/dev | jq '.sha' | sed 's/"//g'
	@curl -L --silent https://github.com/$@/$@/archive/$$(curl -s https://api.github.com/repos/$@/$@/commits/dev | jq '.sha' | sed 's/"//g').tar.gz | shasum -a 256 | awk '{print $$1}'

libuv:
	git checkout third-party/$@
	@curl -s https://api.github.com/repos/$@/$@/commits/v1.x | jq '.sha' | sed 's/"//g'
	@curl -L --silent https://github.com/$@/$@/archive/$$(curl -s https://api.github.com/repos/$@/$@/commits/v1.x | jq '.sha' | sed 's/"//g').tar.gz | shasum -a 256 | awk '{print $$1}'

sha:
	curl -s https://api.github.com/repos/$(ORGANIZATION_NAME)/$(REPOSITORY_NAME)/commits/master | jq '.sha' | sed 's/"//g'
