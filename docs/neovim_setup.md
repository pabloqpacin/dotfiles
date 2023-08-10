# neovim setup


## installation

```bash
# Clone my dotfiles and symlink the neovim config
cd $HOME && git clone https://github.com/pabloqpacin/dotfiles
ln -s ~/dotfiles/.config/nvim ~/.config/nvim/
```

- Arch

```bash
# Install neovim
pacman -S neovim

# Install our plugin manager
yay -S nvim-packer-git --nocleanmenu --nodiffmenu
``` 

- Ubuntu

```bash
# Build Neovim from source
sudo apt-get install ninja-build gettext cmake unzip curl
cd $HOME && git clone --depth 1 https://github.com/neovim/neovim
cd $HOME/neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
nvim --version
# rm -rf $HOME/neovim

# Install our plugin manager
cd $HOME && git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

## dependencies

```bash
# Treesitter requires build-essential
apt install build-essential

# Telescope requires ripgrep
pacman -S ripgrep || cargo install ripgrep

# Some LSPs require unzip
apt install unzip || pacman -S unzip

# Go LSP requires Go -- PopOS how-to
cd /tmp \
 && wget -c https://golang.org/dl/go1.15.2.linux-amd64.tar.gz \
 && sudo rm -rf /usr/local/go \
 && sudo tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz \
 && source ~/dotfiles/zsh/golang.zsh

# Python LSP requires venv
sudo apt-get install python3-venv || yay -S python3-venv

# Some LSPs require NPM -- VERIFY LATEST VERSION!
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node

# Just install live-server
npm install --global live-server
```

```bash
# Peek plugin needs Deno and may complain without this lib
pacman -S deno || curl -fsSL https://deno.land/x/install/install.sh | sh
pacman -S webkit2gtk || apt install libwebkit2gtk-4.0-37

# In Ubuntu (WSL) had to include ~/.deno to $PATH in my .zshrc - not sure if build:debug was necessary but it worked
export PATH=$PATH:~/.deno/bin
cd ~/.local/share/nvim/site/pack/packer/start/peek.nvim && deno task build:debug

# In Arch I had some font rendering issues and changing this default did the trick
# NOTE: pacman -S ttf-fira-mono && fc-cache -fv && fc-list | rg Fira
fc-match monospace  # 'FreeMono.otf: "FreeMono" "Regular"'
# Search for 'FreeMono' with rg or fzf in /etc/fonts 
sudo sed -i 's/<family>FreeMono/<family>FiraMono/' /usr/share/fontconfig/conf.avail/69-unifont.conf  # VERIFY
fc-cache -fv
fc-match monospace  # 'FiraMono' ie. success
```

```bash
# Some plugins expect a 'Nerd Font' to render icons, so ensure your terminal is using one -- https://nerdfonts.com -- find more info on my Arch Setup guide
```


## setup

```bash
# With all requirements addressed, install the stuff
cd $HOME/.config/nvim/
nvim lua/pabloqpacin/packer.lua
# skip error messages
:so
:PackerUpdate
:q
:MasonUpdate
```


<hr>

# DEBUGGIN' n COMPILING

- C/C++
- Rust
- Bash
- JS/TS