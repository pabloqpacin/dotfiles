# https://www.tecmint.com/install-go-in-linux/
# https://go.dev/doc/install

# # ---
# #!/usr/bin/env bash
# 
# set -euo pipefail
# 
# version=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -1)
# url="https://go.dev/dl/${version}.linux-amd64.tar.gz"
# 
# echo "Installing ${version}..."
# curl -fsSL "$url" -o /tmp/go.tar.gz
# sudo rm -rf /usr/local/go
# sudo tar -C /usr/local -xzf /tmp/go.tar.gz
# rm /tmp/go.tar.gz
# 
# /usr/local/go/bin/go version
# # ---


export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

if [[ ":$PATH:" != *":$GOBIN:"* ]]; then
    export PATH=$PATH:$GOBIN
    export PATH=$PATH:/usr/local/go/bin
fi

# $ mkdir -p $GOPATH/{bin,pkg,src}
# $ mkdir -p $GOPATH/src/github.com/pabloqpacin

# $ cd $_ && nvim hw.go
# package main
# import "fmt"
# func main() { fmt.Println("Hello, World!")}

# go run hw.go      # executable binary in memory
# go build wg.go    # executable in same dir as src file

# Install lf
# $ env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
