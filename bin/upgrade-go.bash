#!/bin/bash

go get -ldflags "-w -s" -p 9 -u -v \
github.com/asciinema/asciinema \
github.com/constabulary/gb/... \
github.com/divan/expvarmon \
github.com/github/hub \
github.com/golang/lint/golint \
github.com/jingweno/ccat \
github.com/jstemmer/gotags \
github.com/jteeuwen/go-bindata/... \
github.com/kahing/goofys \
github.com/kisielk/errcheck \
github.com/klauspost/asmfmt/cmd/asmfmt \
github.com/mattn/goveralls \
github.com/mitchellh/gox \
github.com/modocache/gover \
github.com/motemen/gompatible/cmd/gompat \
github.com/nsf/gocode \
github.com/onsi/ginkgo/ginkgo \
github.com/peco/peco/cmd/peco \
github.com/stretchr/testify \
github.com/termie/go-shutil \
github.com/tools/godep \
github.com/yusukebe/revealgo/cmd/revealgo \
golang.org/x/tools/... \
golang.org/x/tools/cmd/benchcmp \
golang.org/x/tools/cmd/bundle \
golang.org/x/tools/cmd/callgraph \
golang.org/x/tools/cmd/cover \
golang.org/x/tools/cmd/digraph \
golang.org/x/tools/cmd/eg \
golang.org/x/tools/cmd/fiximports \
golang.org/x/tools/cmd/godex \
golang.org/x/tools/cmd/godoc \
golang.org/x/tools/cmd/goimports \
golang.org/x/tools/cmd/gomvpkg \
golang.org/x/tools/cmd/gorename \
golang.org/x/tools/cmd/gotype \
golang.org/x/tools/cmd/guru \
golang.org/x/tools/cmd/html2article \
golang.org/x/tools/cmd/oracle \
golang.org/x/tools/cmd/present \
golang.org/x/tools/cmd/ssadump \
golang.org/x/tools/cmd/stress \
golang.org/x/tools/cmd/stringer \
golang.org/x/tools/cmd/tip \
golang.org/x/tools/cmd/vet \
github.com/tcnksm/gotests \
github.com/sromku/go-gitter \
github.com/google/pprof \
github.com/google/uuid \
github.com/google/go-github \
github.com/alecthomas/gometalinter

go get -d -t -ldflags "-w -s" -p 9 -u -v \
github.com/tinylib/msgp \
github.com/derekparker/delve
github.com/google/syzkaller \
github.com/google/logger \
github.com/google/subcommands \

# github.com/src-d/go-git/... \

gometalinter --install --update
