#!/bin/bash
# set -ux

CURRENT=$PWD

# github.com/alecthomas/gometalinter
#  - Concurrently run Go lint tools and normalise their output
# github.com/asciinema/asciinema
#  - Terminal session recorder
# github.com/constabulary/gb/...
#  - gb, the project based build tool for Go
# github.com/cweill/gotests/...
#  - Generate Go tests from your source code.
# github.com/divan/expvarmon
#  - TermUI based monitor for Go apps using expvars (/debug/vars)
# github.com/golang/lint/golint
#  - This is a linter for Go source code.
# github.com/golang/protobuf/{proto,protoc-gen-go}
#  - Go support for Google's protocol buffers
# github.com/google/pprof
#  - pprof is a tool for visualization and analysis of profiling data
# github.com/jstemmer/gotags
#  - ctags-compatible tag generator for Go
# github.com/jteeuwen/go-bindata/...
#  - A small utility which generates Go code from any file.
# github.com/kahing/goofys
#  - a Filey System for Amazon S3 written in Go
# github.com/kisielk/errcheck
#  - errcheck checks that you checked errors.
# github.com/klauspost/asmfmt/cmd/asmfmt
#  - Go Assembler Formatter
# github.com/mattn/goveralls
#  - Go integration for Coveralls.io continuous code coverage tracking system.
# github.com/modocache/gover
#  - Gather all your *.coverprofile files to send to coveralls.io!
# github.com/monochromegane/the_platinum_searcher/...
#  - A code search tool similar to ack and the_silver_searcher(ag).
# github.com/motemen/gompatible/cmd/gompat
#  - github.com/motemen/gompatible/cmd/gompat
# github.com/nsf/gocode
#  - An autocompletion daemon for the Go programming language
# github.com/peco/peco/cmd/peco
#  - Simplistic interactive filtering tool
# github.com/sqs/goreturns
#  - A gofmt/goimports-like tool for Go programmers that fills in Go return statements with zero values to match the func return types
# github.com/tools/godep
#  - dependency tool for go

# golang.org/x/mobile/...
# golang.org/x/tools/...
# github.com/google/go-github
#  - Go library for accessing the GitHub API
# github.com/google/uuid
#  - The uuid package generates and inspects UUIDs based on RFC 412 and DCE 1.1: Authentication and Security Services.
# github.com/sromku/go-gitter
#  - Gitter API in Go
# github.com/stretchr/testify/...
#  - A sacred extension to the standard go testing package
# github.com/termie/go-shutil
#  - golang port of python's shutil - copy a directory in go

# github.com/github/hub

COMMAND_PACKAGE="
  github.com/alecthomas/gometalinter \
  github.com/asciinema/asciinema \
  github.com/constabulary/gb/... \
  github.com/cweill/gotests/... \
  github.com/divan/expvarmon \
  github.com/golang/lint/golint \
  github.com/golang/protobuf/{proto,protoc-gen-go} \
  github.com/google/pprof \
  github.com/jstemmer/gotags \
  github.com/jteeuwen/go-bindata/... \
  github.com/kahing/goofys \
  github.com/kisielk/errcheck \
  github.com/klauspost/asmfmt/cmd/asmfmt \
  github.com/mattn/goveralls \
  github.com/modocache/gover \
  github.com/monochromegane/the_platinum_searcher/... \
  github.com/motemen/gompatible/cmd/gompat \
  github.com/nsf/gocode \
  github.com/peco/peco/cmd/peco \
  github.com/sqs/goreturns \
  github.com/tools/godep \
"

LIBRARY_PACKAGE="
  golang.org/x/arch/... \
  golang.org/x/benchmarks/... \
  golang.org/x/crypto/... \
  golang.org/x/debug/... \
  golang.org/x/example/... \
  golang.org/x/exp/... \
  golang.org/x/image/... \
  golang.org/x/mobile/... \
  golang.org/x/net/... \
  golang.org/x/oauth2/... \
  golang.org/x/sync/... \
  golang.org/x/sys/... \
  golang.org/x/text/... \
  golang.org/x/time/... \
  golang.org/x/tools/... \
  github.com/google/go-github \
  github.com/google/syzkaller \
  github.com/google/uuid \
  github.com/src-d/go-git \
  github.com/sromku/go-gitter \
  github.com/stretchr/testify/... \
  github.com/termie/go-shutil \
  github.com/tinylib/msgp \
  github.com/tinylib/synapse \
"

EXCEPTION_PACKAGE="
  github.com/derekparker/delve \
  github.com/github/hub \
"

# Install command line tools
for p in $COMMAND_PACKAGE
do
  printf "\x1b[34;40mInstalling \x1b[0m$p\n"
  go get -ldflags "-w -s" -u -v $p
done

# Fetch library package and exception case
for p in $LIBRARY_PACKAGE $EXCEPTION_PACKAGE
do
  printf "\x1b[34;40mFetching \x1b[0m$p\n"
  go get -d -t -p=8 -u -v $p
done


printf "\x1b[34;40mgometalinter:\x1b[0m Installing each lint tools ...\n"
echo 'Installing each lint tools ...'
gometalinter --install --update

printf "\x1b[34;40mgithub/hub:\x1b[0m Installing ...\n"
cd $GOPATH/src/github.com/github/hub
./script/build -o $GOPATH/bin/hub

printf "\x1b[34;40mdelve:\x1b[0m Installing ...\n"
cd $GOPATH/src/github.com/derekparker/delve
CERT=dlv_codesign command make install

cd $CURRENT
