# Fedora

> Fedora Workstation 39

- **NOTA_1**: VBox drivers by default yay!

## live-installation

- VM

```yaml
EFI: yes
Disk: 40GB
```

- Installer

```yaml
Language: English
Keyboard: Spanish
Timezone: Europe/Madrid
Installation Destination: Automatic partitioning
```

## post-install config

- First boot Setup

```yaml
Location Services: no
Automatic Problem Reporting: yes
Enable 3rd-party repos: yes
Online accounts: no

Enterprise Login: no
Username: pabloqpacin
Password: ...
```

> Fresh Install

- Do base

```bash
dnf list --installed | wc -l            # 1940
sudo dnf update && sudo dnf upgrade     # sudo dnf up

sudo dnf install neofetch --setopt=install_weak_deps=False
sudo dnf install alacritty tldr tmux zsh
tldr --update

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip &&
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip &&
    sudo unzip CascadiaCode.zip -d /usr/share/fonts/CascadiaCodeNerd && rm CascadiaCode.zip &&
    sudo unzip FiraCode.zip -d /usr/share/fonts/FiraCodeNerd && rm FiraCode.zip &&
    fc-cache -fv

git clone --depth 1 https://github.com/pabloqpacin/dotfiles

ln -s ~/dotfiles/.config/alacritty ~/.config
ln -s ~/dotfiles/.config/tmux ~/.config
```

```bash
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
bash $HOME/dotfiles/scripts/setup/omz-msg_random_theme.sh
rm ~/.zshrc && ln -s ~/dotfiles/.zshrc ~/

mkdir $HOME/dotfiles/zsh/plugins &&
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/dotfiles/zsh/plugins/zsh-autosuggestions &&
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting
    sudo chsh -s $(which zsh) $USER
    zoxide add dotfiles
```

```bash
sudo dnf install bat btop eza fzf git-delta zoxide
ln -s ~/dotfiles/.config/bat ~/.config
ln -s ~/dotfiles/.config/btop ~/.config

sudo dnf install golang
go install github.com/gokcehan/lf@latest
go install github.com/cheat/cheat/cmd/cheat@latest
ln -s ~/dotfiles/.config/lf ~/.config
yes | cheat
bash -x $HOME/dotfiles/scripts/setup/cheat-symlink.sh

sudo dnf install neovim &&
    sudo dnf install nodejs &&     # python3-pip
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    
    ln -s ~/dotfiles/.config/nvim ~/.config
    nvim .config/nvim/lua/pabloqpacin/packer.lua
        # :so :PackerSync ;; :Mason
```


---

- https://docs.docker.com/engine/install/fedora/

```bash
sudo dnf remove docker docker-client docker-client-latest docker-common \
                docker-latest docker-latest-logrotate docker-logrotate \
                docker-selinux docker-engine-selinux docker-engine

# Images, containers, volumes, and networks stored in /var/lib/docker/ aren't automatically removed when you uninstall Docker.

# Install the dnf-plugins-core package (which provides the commands to manage your DNF repositories) and set up the repository.
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install Docker Engine, containerd, and Docker Compose:
sudo dnf install docker-ce docker-ce-cli containerd.io \
                 docker-buildx-plugin docker-compose-plugin

# If prompted to accept the GPG key, verify that the fingerprint matches 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35, and if so, accept it.
# This command installs Docker, but it doesn't start Docker. It also creates a docker group, however, it doesn't add any users to the group by default.

    # - https://docs.docker.com/engine/install/linux-postinstall/
    #   - https://docs.docker.com/engine/security/#docker-daemon-attack-surface
    # The Docker daemon binds to a Unix socket, not a TCP port. By default it's the root user that owns the Unix socket, and other users can only access it using sudo. The Docker daemon always runs as the root user.
    # If you don't want to preface the docker command with sudo, create a Unix group called docker and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group. On some Linux distributions, the system automatically creates this group when installing Docker Engine using a package manager. In that case, there is no need for you to manually create the group.
    sudo usermod -aG docker $USER
    reboot

# Start docker
sudo systemctl start docker

# # Verify that the Docker Engine installation is successful by running the hello-world image.
# sudo docker run hello-world
```

- Docker Homelab

```bash
# containers
# - portainer
# - mysql
# compose
# - ...
```

- bottom

