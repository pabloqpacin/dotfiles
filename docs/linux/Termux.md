# Termux

- [Termux](#termux)
  - [Installation](#installation)
  - [Configuration](#configuration)


> - **NOTE 1**: my device isn't rooted so the `root-repo` programs won't work (e.g. `tshark`)

## Installation

```yaml
F-Droid:
    Termux: https://wiki.termux.com/wiki/Installing_from_F-Droid
    Termux:Styling: https://github.com/termux/termux-styling
    Termux:Float: ...
    Termux:API: https://wiki.termux.com/wiki/Termux:API
```

<details>
<summary>Click to see some <code>termux-api</code> commands...</summary>

```bash
termux-battery-status
# Get the status of the device battery.
termux-brightness
# Set the screen brightness between 0 and 255.
termux-call-log
# List call log history.
termux-camera-info
# Get information about device camera(s).
termux-camera-photo
# Take a photo and save it to a file in JPEG format.
termux-clipboard-get
# Get the system clipboard text.
termux-clipboard-set
# Set the system clipboard text.
termux-contact-list
# List all contacts.
termux-dialog
# Show a text entry dialog.
termux-download
# Download a resource using the system download manager.
termux-fingerprint
# Use fingerprint sensor on device to check for authentication.
termux-infrared-frequencies
# Query the infrared transmitter's supported carrier frequencies.
termux-infrared-transmit
# Transmit an infrared pattern.
termux-job-scheduler
# Schedule a Termux script to run later, or periodically.
termux-location
# Get the device location.
termux-media-player
# Play media files.
termux-media-scan
# MediaScanner interface, make file changes visible to Android Gallery
termux-microphone-record
# Recording using microphone on your device.
termux-notification
# Display a system notification.
termux-notification-remove
# Remove a notification previously shown with termux-notification --id.
termux-sensor
# Get information about types of sensors as well as live data.
termux-share
# Share a file specified as argument or the text received on stdin.
termux-sms-list
# List SMS messages.
termux-sms-send
# Send a SMS message to the specified recipient number(s).
termux-storage-get
# Request a file from the system and output it to the specified file.
termux-telephony-call
# Call a telephony number.
termux-telephony-cellinfo
# Get information about all observed cell information from all radios on the device including the primary and neighboring cells.
termux-telephony-deviceinfo
# Get information about the telephony device.
termux-toast
# Show a transient popup notification.
termux-torch
# Toggle LED Torch on device.
termux-tts-engines
# Get information about the available text-to-speech engines.
termux-tts-speak
# Speak text with a system text-to-speech engine.
termux-usb
# List or access USB devices.
termux-vibrate
# Vibrate the device.
termux-volume
# Change volume of audio stream.
termux-wallpaper
# Change wallpaper on your device.
termux-wifi-connectioninfo
# Get information about the current wifi connection.
termux-wifi-enable
# Toggle Wi-Fi On/Off.
termux-wifi-scaninfo
# Get information about the last wifi scan.
```
</details>


## Configuration


- System update

```bash
pkg update
pkg upgrade -y

pkg list-installed | wc -l
echo 'APT::Get::Show-Versions "true";' | tee $PREFIX/etc/apt/apt.conf.d/99show-versions

pkg install termux-api
termux-vibrate && termux-torch on && termux-notification supdawg
# pkg install root-repo && pkg install tshark

bat ~/.termux/termux.properties
    # https://wiki.termux.com/wiki/Terminal_Settings
```

- Basic packages

```bash
pkg install \
    bat cbonsai cmatrix eza fzf git git-delta htop iproute2 lf man
    openssh neofetch neovim nmap ripgrep tealdeer tmux tree
    # gitui python zsh

tldr --update

# bat $PREFIX/etc/bash.bashrc
```
```bash
# TODO: nvim dependencies

git clone https://github.com/pabloqpacin/dotfiles

# ln -s ~/.bashrc ~/
ln -s ~/.gitconfig ~/
ln -s ~/dotfiles/.config/bat ~/.config
ln -s ~/dotfiles/.config/lf ~/.config
```

- Config SSH ([src](https://wiki.termux.com/wiki/Remote_Access))

```bash
# Termux Server
tree $PREFIX/etc/ssh
bat $PREFIX/etc/ssh/sshd_config
passwd
sshd
# pkill sshd
```

```bash
# Client computer
map -sV -Pn 192.168.1.33
ssh u0_a390@192.168.1.33 -p 8022
```

- Web server

```bash
pkg install apache2
tree $PREFIX/etc/apache2
nvim $PREFIX/share/apache2/default-site
httpd

# Client browser: 192.168.1.33:8080

pkill httpd
```


---

<!-- ## TODO

- .bashrc
- htop...
- https://www.geeksforgeeks.org/how-to-use-aircrack-ng-in-termux/
- https://wiki.termux.com/wiki/Graphical_Environment
- https://wiki.termux.com/wiki/Package_Management
- [@DavidBombal: Kali NetHunter (rootless)](https://www.youtube.com/watch?v=KxOGyuGq0Ts)
- Databases
- Docker -->

