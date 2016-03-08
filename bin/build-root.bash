#!/bin/bash
set -e


# Building CERN ROOT6 CMake flags script
#   ROOT6 build option list:
#     - https://root.cern.ch/building-root
#
# Tested version:
#   Apple LLVM version 7.3.0 (clang-703.0.28)
#   Target: x86_64-apple-darwin15.4.0
#
#
# References:
#   OS X building broken?:
#     https://root.cern.ch/phpBB3/viewtopic.php?t=19816


# if [[ ! -n $1 ]]; then
#   echo "\$1: Need build tool as arguments. ['Ninja', 'Unix Makefile']"
#   exit 1
# elif [[ ! -n $2 ]]; then
#   echo "\$2: Need build base directory."
#   exit 1
# fi
#
# if [[ ! -d "$2" ]]; then
#   mkdir -p $2
# fi
#
# cd $2

PYTHON="\
    -DPYTHON_EXECUTABLE=/usr/local/Frameworks/Python.framework/Versions/3.6/bin/python3 \
    -DPYTHON_INCLUDE_DIR=/usr/local/Frameworks/Python.framework/Versions/3.6/include/python3.6m \
    -DPYTHON_LIBRARY=/usr/local/Frameworks/Python.framework/Versions/3.6/lib/libpython3.6.dylib"
LIBXML2="\
    -DLIBXML2_INCLUDE_DIR=/usr/local/opt/libxml2/include/libxml2 \
    -DLIBXML2_LIBRARIES=/usr/local/opt/libxml2/lib/libxml2.dylib \
    -DLIBXML2_XMLLINT_EXECUTABLE=/usr/local/opt/libxml2/bin/xmllint"
LIBFFI="\
    -DFFI_INCLUDE_DIR=/usr/local/opt/libffi/lib/libffi-3.0.13/include \
    -DFFI_LIBRARY_DIR=/usr/local/opt/libffi/lib/libffi.dylib"

command cmake $1 -G "$2" \
    -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_FIND_FRAMEWORK=LAST \
    -DCMAKE_INSTALL_PREFIX=/opt/root \
    -DCMAKE_OSX_ARCHITECTURES=x86_64 \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=10.11 \
    -DCMAKE_OSX_SYSROOT="$(xcrun --show-sdk-path)" \
    -DCMAKE_SYSROOT="$(xcrun --show-sdk-path)" \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DDEFAULT_SYSROOT="$(xcrun --show-sdk-path)" \
    -DLLVM_ENABLE_ASSERTIONS=OFF \
    -DLLVM_ENABLE_CXX1Y=ON \
    -DLLVM_OPTIMIZED_TABLEGEN=ON \
    -DLLVM_PARALLEL_COMPILE_JOBS=9 \
    -DLLVM_PARALLEL_LINK_JOBS=9 \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    \
		-Dbuiltin_afterimage=ON \
		-Dbuiltin_cfitsio=OFF \
		-Dbuiltin_davix=OFF \
		-Dbuiltin_fftw3=OFF \
		-Dbuiltin_freetype=ON \
		-Dbuiltin_ftgl=ON \
		-Dbuiltin_glew=ON \
		-Dbuiltin_gsl=OFF \
		-Dbuiltin_llvm=ON \
		-Dbuiltin_lzma=OFF \
		-Dbuiltin_openssl=OFF \
		-Dbuiltin_pcre=OFF \
		-Dbuiltin_tbb=ON \
		-Dbuiltin_vc=OFF \
		-Dbuiltin_xrootd=OFF \
		-Dbuiltin_zlib=OFF \
		\
		-Dcocoa=ON \
		-Dcxx14=ON \
		-Ddavix=ON \
		-Dhttp=ON \
		-Dimt=ON \
		-Dlibcxx=ON \
		-Dmt=ON \
		-Dmysql=ON \
		-Dpython3=ON \
		-Dtbb=OFF \
		-Dtcmalloc=ON \
		\
		-DOPENSSL_CRYPTO_LIBRARY=/usr/local/opt/openssl/lib/libcrypto.dylib \
		-DOPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include \
		-DOPENSSL_SSL_LIBRARY=/usr/local/opt/openssl/lib/libssl.dylib \
		-DSQLITE_INCLUDE_DIR:PATH=/usr/local/include \
		-DSQLITE_LIBRARIES:FILEPATH=/usr/local/opt/sqlite/lib/libsqlite3.dylib \
		\
    -Wno-dev \
    \
    $(echo $PYTHON) \
    $(echo $LIBFFI) \
    $(echo $LIBXML2)
