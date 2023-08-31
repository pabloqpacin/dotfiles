# WSL Debian

- Basic setup

```yaml
Username: ...
Password: ...
```

```bash
# Verify VSCode integration
code $HOME

# WSL basics
sudo apt update && \
 sudo apt upgrade -y

sudo apt install wslu xclip xsel
sudo apt install curl g++ git man
sudo apt install neofetch --no-install-recommends
# sudo apt install fontconfig xdg-utils
```
- Now replicate tha [Pop!_OS](/docs/linux/Pop!_OS.md) environment

```yaml
Custom shell environment:
  github ssh + clone dotfiles repo + symlinks
  apt, Rust & Go packages
  zsh + ohmyzsh
  full nvim
  tmux
  tldr cheat ...
```

<!--
- More stuff

```bash
sudo apt-get install tshark
```

---

- TODO
  - ssh
  - networking...

 -->