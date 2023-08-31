# WSL Tumbleweed

- Basic setup

```yaml
# YaST2 first boot
Username: ...
Password: ...
```
```bash
# Basic update
zypper search -i | wc -l
sudo zypper refresh && \
 sudo zypper update

# Important packages
sudo zypper install cmake gcc-c++ git
sudo zypper install bat exa fzf git-delta neofetch neovim ripgrep
```

- Now CUSTOM ENVIRONMENT


```yaml
Custom shell environment:
    github ssh + clone dotfiles repo + symlinks
    nvim requisites (packer nvm)
    zsh + ohmyzsh
```


---

- TODO
  - Fix `tmux` -- dotfiles/scripts/WSL_TW-tmux
  - Figure out `tldr`