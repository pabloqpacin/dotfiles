# https://www.tecmint.com/install-go-in-linux/
# https://go.dev/doc/install


# cd /tmp \
#  && wget -c https://golang.org/dl/go1.21.0.linux-amd64.tar.gz \
#  && sudo rm -rf /usr/local/go \
#  && sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz \
#  && source ~/dotfiles/zsh/golang.zsh

export PATH=$PATH:/usr/local/go/bin

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin

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
