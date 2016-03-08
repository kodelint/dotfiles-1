#!/bin/bash
set -e


# Building CERN ROOT6 CMake flags script
#   ROOT6 build option list:
#     - https://root.cern.ch/building-root
#
# Latest tested clang version:
#   Apple LLVM version 7.3.0 (clang-703.0.26)
#   Target: x86_64-apple-darwin15.4.0
#   Thread model: posix


if ! [[ -n $3 ]]; then
  SRC_DIR=../llvm
fi
if ! [[ -n $3 ]]; then
  DST_DIR=./build
fi

PYTHON_SELECT_VERSION=$(python$2-config --prefix | awk -F / '{print $NF}')

if ! [[ -n $PYTHON_PREFIX ]]; then
  PYTHON_PREFIX=$(python$2-config --prefix)
fi

if ! [[ -n $PYTHON_EXECUTABLE ]]; then
  PYTHON_EXECUTABLE=$(which python$PYTHON_SELECT_VERSION)
fi
if ! [[ -n $PYTHON_INCLUDE_DIR ]]; then
  PYTHON_INCLUDE_DIR=$PYTHON_PREFIX/include/python$PYTHON_SELECT_VERSION
fi
if ! [[ -n $PYTHON_LIBRARY ]]; then
  PYTHON_LIBRARY=$PYTHON_PREFIX/lib/libpython$PYTHON_SELECT_VERSION.dylib
fi



USAGE_CMAKE_GENERATORS="\
  Unix Makefiles
  Ninja
  Xcode
  CodeBlocks - Ninja
  CodeBlocks - Unix Makefiles
  CodeLite - Ninja
  CodeLite - Unix Makefiles
  Eclipse CDT4 - Ninja
  Eclipse CDT4 - Unix Makefiles
  KDevelop3
  KDevelop3 - Unix Makefiles
  Kate - Ninja
  Kate - Unix Makefiles
  Sublime Text 2 - Ninja
  Sublime Text 2 - Unix Makefiles"
USAGE_PYTHON_VERSION="\
  2
  3"
USAGE_ENVIRONMENT_VARIABLE="\
  \$SRC_DIR		$SRC_DIR
  \$DST_DIR		$DST_DIR
  \$PYTHON_EXECUTABLE	$PYTHON_EXECUTABLE
  \$PYTHON_INCLUDE_DIR	$PYTHON_INCLUDE_DIR
  \$PYTHON_LIBRARY	$PYTHON_LIBRARY"
usage() {
  echo "error: No build tool as arguments"
  echo ""
  echo "$0 <CMAKE GENERATORS> <PYTHON VERSION> [\$SOURCE_DIR \$DIST_DIR]"
  echo ""
  echo "CMake Generators"
  echo "$USAGE_CMAKE_GENERATORS"
  echo ""
  echo "Python Version"
  echo "$USAGE_PYTHON_VERSION"
  echo ""
  echo "Environment variable:"
  echo "$USAGE_ENVIRONMENT_VARIABLE"
  exit 1
}
if [[ ! -n $2 ]]; then
  PYTHON_VERSION=3
  usage
fi



PYTHON="\
  -DPYTHON_EXECUTABLE=$PYTHON_EXECUTABLE \
  -DPYTHON_INCLUDE_DIR=$PYTHON_INCLUDE_DIR \
  -DPYTHON_LIBRARY=$PYTHON_LIBRARY"
LIBXML2="\
  -DLIBXML2_INCLUDE_DIR=/usr/local/opt/libxml2/include/libxml2 \
  -DLIBXML2_LIBRARIES=/usr/local/opt/libxml2/lib/libxml2.dylib \
  -DLIBXML2_XMLLINT_EXECUTABLE=/usr/local/opt/libxml2/bin/xmllint"
LIBFFI="\
  -DFFI_INCLUDE_DIR=/usr/local/opt/libffi/lib/libffi-3.0.13/include \
  -DFFI_LIBRARY_DIR=/usr/local/opt/libffi/lib/libffi.dylib"


if [[ ! -d "$DST_DIR" ]]; then
  mkdir -p $DST_DIR
fi
cd $DST_DIR

command cmake $SRC_DIR -G $1 \
  \
  -DBUILD_SHARED_LIBS:BOOL=OFF \
  \
  -DCLANG_BUILD_EXAMPLES:BOOL=ON \
  -DCLANG_DEFAULT_CXX_STDLIB:STRING=libc++ \
  -DCLANG_INCLUDE_DOCS:BOOL=ON \
  -DCLANG_INCLUDE_TESTS:BOOL=ON \
  \
  -DCMAKE_ASM_FLAGS:STRING='-march=native' \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_CXX_FLAGS:STRING='-march=native' \
  -DCMAKE_C_FLAGS:STRING='-march=native' \
  \
  -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON \
  -DCMAKE_FIND_FRAMEWORK=LAST \
  -DCMAKE_INSTALL_PREFIX:PATH=$DST_DIR \
  \
  -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64 \
  -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=10.11 \
  -DCMAKE_OSX_SYSROOT:STRING="$(xcrun --show-sdk-path)" \
  \
  -DCMAKE_SKIP_INSTALL_RPATH:BOOL=NO \
  -DCMAKE_SKIP_RPATH:BOOL=NO \
  \
  -DCOMPILER_RT_DEBUG:BOOL=OFF \
  -DCOMPILER_RT_ENABLE_IOS:BOOL=OFF \
  -DCOMPILER_RT_ENABLE_TVOS:BOOL=OFF \
  -DCOMPILER_RT_ENABLE_WATCHOS:BOOL=OFF \
  -DCOMPILER_RT_ENABLE_WERROR:BOOL=OFF \
  -DCOMPILER_RT_EXTERNALIZE_DEBUGINFO:BOOL=OFF \
  \
  -DCURSES_CURSES_LIBRARY:FILEPATH=/usr/local/lib/libcurses.dylib \
  -DCURSES_FORM_LIBRARY:FILEPATH=/usr/local/lib/libform.dylib \
  -DCURSES_INCLUDE_PATH:PATH=/usr/local/include \
  -DCURSES_NCURSES_LIBRARY:FILEPATH=/usr/local/lib/libncurses.dylib \
  -DCURSES_PANEL_LIBRARY:FILEPATH=/usr/local/lib/libpanel.dylib \
  \
  -DDARWIN_10.4_ARCHS:STRING=x86_64 \
  -DDARWIN_osx_ARCHS:STRING=x86_64 \
  \
  -DDEFAULT_SYSROOT:PATH="$(xcrun --show-sdk-path)" \
  \
  -DLIBCLANG_BUILD_STATIC:BOOL=OFF \
  -DLIBCXXABI_ENABLE_ASSERTIONS:BOOL=OFF \
  -DLIBCXXABI_SYSROOT:STRING="$(xcrun --show-sdk-path)" \
  -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=OFF \
  \
  -DLIBCXX_CONFIGURE_IDE:BOOL=OFF \
  -DLIBCXX_ENABLE_ASSERTIONS:BOOL=OFF \
  -DLIBCXX_OVERRIDE_DARWIN_INSTALL:BOOL=ON \
  -DLIBCXX_SYSROOT:STRING="$(xcrun --show-sdk-path)" \
  \
  -DLIBOMP_OSX_ARCHITECTURES:STRING=x86_64 \
  -DLIBOMP_USE_HWLOC:BOOL=ON \
  \
  -DLLDB_EXPORT_ALL_SYMBOLS:BOOL=ON \
  \
  -DLLD_USE_VTUNE:BOOL=OFF \
  \
  -DLLVM_BUILD_EXAMPLES:BOOL=ON \
  -DLLVM_BUILD_EXTERNAL_COMPILER_RT:BOOL=OFF \
  -DLLVM_BUILD_LLVM_C_DYLIB:BOOL=ON \
  -DLLVM_BUILD_LLVM_DYLIB:BOOL=ON \
  -DLLVM_CREATE_XCODE_TOOLCHAIN:BOOL=OFF \
  -DLLVM_ENABLE_ASSERTIONS:BOOL=OFF \
  -DLLVM_ENABLE_CXX1Y:BOOL=ON \
  -DLLVM_ENABLE_FFI:BOOL=ON \
  -DLLVM_ENABLE_LIBCXX:BOOL=ON \
  -DLLVM_ENABLE_LIBCXXABI:BOOL=ON \
  -DLLVM_ENABLE_LTO:STRING=ON \
  -DLLVM_ENABLE_SPHINX:BOOL=OFF \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD:STRING= \
  -DLLVM_EXTERNALIZE_DEBUGINFO:BOOL=ON \
  -DLLVM_INCLUDE_DOCS:BOOL=ON \
  -DLLVM_INCLUDE_EXAMPLES:BOOL=ON \
  -DLLVM_LINK_LLVM_DYLIB:BOOL=OFF \
  -DLLVM_OPTIMIZED_TABLEGEN:BOOL=ON \
  -DLLVM_PARALLEL_COMPILE_JOBS:STRING=9 \
  -DLLVM_PARALLEL_LINK_JOBS:STRING=9 \
  -DLLVM_TARGET_ARCH:STRING=host \
  -DLLVM_TARGETS_TO_BUILD=X86 \
  -DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD:BOOL=OFF \
  -DLLVM_USE_SPLIT_DWARF:BOOL=OFF \
  \
  -DPOLLY_ENABLE_GPGPU_CODEGEN:BOOL=ON \
  \
  \
  -Wno-dev \
  \
  $(echo $PYTHON) \
  $(echo $LIBFFI) \
  $(echo $LIBXML2)
