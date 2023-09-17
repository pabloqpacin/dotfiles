# Multiboot Neovim Setup


- [Multiboot Neovim Setup](#multiboot-neovim-setup)
  - [install \& config](#install--config)
    - [Windows](#windows)
    - [Linux](#linux)
      - [Arch](#arch)
      - [Ubuntu-ish](#ubuntu-ish)
  - [TODO](#todo)
    - [Tweak `peek.nvim`](#tweak-peeknvim)
    - [DAPs](#daps)


<!-- <details>
<summary>Documentation</summary>

- Windows
  - https://www.msys2.org/docs/environments
  - https://code.visualstudio.com/docs/cpp/config-mingw
  - https://blog.nikfp.com/how-to-install-and-set-up-neovim-on-windows
  - https://github.com/neovim/neovim/wiki/Building-Neovim#windows--msys2--mingw
  - https://blogs.embarcadero.com/what-is-the-best-c-compiler-for-windows-in-2022

</details> -->

> - @TJDeVries: [PDE: A different take on editing code](https://www.youtube.com/watch?v=QMVIJhC9Veg)
> - @ThePrimeagen: [0 to LSP : Neovim RC From Scratch](https://youtu.be/w7i4amO_zaE)
> - **NOTE**: config the terminal to use a '**Nerd Font**' on every OS

## install & config

### Windows


```powershell
# Install the binary, add it to $PATH via $PROFILE, install Packer
if (!(winget install neovim.neovim.nightly)) { winget install neovim.neovim }
$env:PATH += "$env:PROGRAMFILES\Neovim\bin"          # $PROFILE
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"


# Install dependencies, completing the main [installation script](https://github.com/pabloqpacin/dotfiles/blob/main/windows/scripts/SW_install-symlink.ps1)...
winget upgrade --all
winget install Microsoft.VCRedist.2015+.x64 `
                  fzf golang.go 'ripgrep gnu' `
               openjs.nodejs python.python.3.11 `
               msys2

Start-Process "$env:SYSTEMDRIVE\msys64\msys2.exe"
    # pacman -Syu --noconfirm

reloadPath
Start-Process "$env:SYSTEMDRIVE\msys64\msys2.exe"
    # pacman -Syu base-devel mingw-w64-x86_64-toolchain --noconfirm


# Clone & apply me config
git clone git@github.com:pabloqpacin/dotfiles.git "$env:HOMEPATH\dotfiles"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\nvim" -Path "$env:LOCALAPPDATA\nvim"

cd $env:LOCALAPPDATA\nvim
nvim lua\pabloqpacin\packer.lua
    # Skip error messages with <Enter>, then
    # :so
    # :PackerSync
    # :qa

# Reopen to install them plugins & LSPs
nvim lua\pabloqpacin\packer.lua
    # just let it cook

# Reopen to ensure TreeSitter and Mason are up-to-date
nvim lua\pabloqpacin\packer.lua
    # :MasonUpdate
    # :TSUpdate
```

### Linux


#### Arch


```bash
# Install neovim
pacman -S neovim

# Install dependencies...
pacman -Syu deno python ripgrep unzip webkit2gtk  # go
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node

# Install plugin manager
yay -S nvim-packer-git --nocleanmenu --nodiffmenu

# Apply config
git clone gi@github.com/pabloqpacin/dotfiles.git $HOME/dotfiles
ln -s ~/dotfiles/.config/nvim ~/.config/
cd ~/.config/nvim && nvim lua/pabloqpacin/packer.lua
  # $ :so && :PackerSync && :PackerCompile && :MasonUpdate
``` 

#### Ubuntu-ish


```bash
# Build Neovim from source
sudo apt-get install build-essential cmake gettext ninja-build unzip
git clone --depth 1 https://github.com/neovim/neovim.git
cd neovim && make CMAKE_BUILD_TYPE=Release
sudo make install

# Install Packer
cd $HOME && git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install dependencies...
sudo apt install libwebkit2gtk-4.0-37 python3-venv ripgrep --no-install-recommends
curl -fsSL https://deno.land/x/install/install.sh | sh
cd /tmp \
 && wget -c https://golang.org/dl/go1.21.0.linux-amd64.tar.gz \
 && sudo rm -rf /usr/local/go \
 && sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz \
 && source ~/dotfiles/zsh/golang.zsh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node

# Apply config
git clone gi@github.com/pabloqpacin/dotfiles.git $HOME/dotfiles
ln -s ~/dotfiles/.config/nvim ~/.config/
cd ~/.config/nvim && nvim lua/pabloqpacin/packer.lua
  # $ :so && :PackerSync && :PackerCompile && :MasonUpdate
```

---

## TODO

### Tweak `peek.nvim`

```bash
# cd ~/.local/share/nvim/site/pack/packer/start/peek.nvim && deno task --quiet build:fast

# PR Hotfix -- https://github.com/toppair/peek.nvim/pull/50/commits/f23200c241b06866b561150fa0389d535a4b903d
cd ~/.local/share/nvim/site/pack/packer/start/peek.nvim

nvim app/src/markdownit.ts
    # import MarkdownIt from 'https://esm.sh/markdown-it@13.0.1?no-dts';
    # import MarkdownIt from 'https://esm.sh/markdown-it@12.3.2';

nvim deno.json
  #   "lib": ["dom", "deno.ns", "deno.unstable"]
  # },
  # "imports": {
  #   "node:punycode": "https://deno.land/x/punycode/punycode.js"
  # },
  # "fmt": {
```

### DAPs

- [ ] C/C++
- [ ] Rust
- [ ] Bash
- [ ] JS/TS
