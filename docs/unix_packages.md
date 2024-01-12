# Linux Packages

<details>
<summary>NOTES</summary>

- This list was originally curated for a WSL Ubuntu system and it may be `apt`-centric to some extent.
- That being said, `apt` is fairly limited thus `pacman` and `yay` may provide some packages unavailable otherwise.
- Without `pacman`, some packages should be installed via `cargo`, meaning that [Rust](https://www.rust-lang.org/tools/install) must be installed.
- Certain packages have to be installed using other sorts of package managers, such `pip` or `npm`.
- In the future I may add documentation for other distros' package managers like `zypper` or `dnf`.
- **This list will forever be incomplete.**

</details>

```bash
# Important
btop curl fzf git htop ipcalc man ssh tldr termshark tmux vim zsh     # scp sftp

# NO APT - Cargo packages // pacman or zypper OK -- might require: libssl-dev pkg-config
bat bottom eza fd-find git-delta gitui mdcat ripgrep zoxide

# NO APT - other source
cheat deno glow live-server neo neovim nvm>node>npm oh-my-zsh packer tpm

# Programming
ascii binutils (readelf) binutils-dev build-essential clang gcc gdb hexyl manpages-posix-dev make ncurses-term python-is-python3 python3-pip python3-venv unicode   # lldb - okteta termit

# Python
grip picopins

# Networking
bind9-dnsutils cloud-init dig dstat iproute2 monkeysphere net-tools netcat-openbsd nmap openssl speedtest-cli whois

# Coreutils << info coreutils
df du env|printenv gawk printenv sed wc

# System mgmt
stat time type

# Somewhat useful
aha finger glances gnome-tweaks grc html2text logcat lsb-release lscpu mdp mysql-client mysql-server neofetch progress taskwarrior timewarrior tree who wslu xclip zshmisc

# Just for fun
asciiquarium bsdgames cbonsai cmatrix cowsay figlet fortune games-console games-rogue lavat-git lolcat oneko pacvim

# ??
awesome fwupd-signed ghostscript groff p7zip poke readucks tea visualboyadvance watch wget wsl xxd yes youtube-dl

# 1337
hashcat john john-data

# GUI software -- perhaps don't install from Terminal
brave code(...) gns3 ida imhex keepassxc monero packettracer virtualbox wireshark
```

```bash
# Save htop output -- https://stackoverflow.com/questions/17534591/htop-output-to-human-readable-file/30224271#30224271
echo q | htop | aha --black --line-fix > htop.html
echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help\|xml version=" > ~/htop-output01.txt
```

```bash
# eDEX-UI -- on VMs
git clone https://github.com/GitSquared/edex-ui
cd edex-ui &&
    npm run install-linux &&
    npm run start
```

<!-- - ASIR: DNS...

```bash
ping fping; host dig nslookup

```

- Linux Desktop (Pop)

```bash
agi fancontrol          # ...
apt show collectd-core


``` -->


```bash
gh  # https://github.com/cli/cli/blob/trunk/docs/install_linux.md

rsync

```

- DB client

```bash
agi mycli
pip install -U mycli    # linux + windows ??
winget install mycli    # ??
# OJO!!! -- https://www.pgcli.com/install

pip install -U pgcli
```
