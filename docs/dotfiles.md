# Dotfiles (@pabloqpacin)



## documentation
- @AndrewBurguess: [Dotfiles! Here's how I organize them](https://youtu.be/5oXy6ktYs7I)
- @sudopluto: [Using Chezmoi to Automate dotfiles / Config Files (+ my bashrc)](https://youtu.be/id5UKYuX4-A) <!--CONTAINERZ-->


### engineerz/dotfiles <!--Models/Samples/Examples/References-->
- [@AndrewBurguess](https://github.com/andrew8088/dotfiles)
- [@bashbunni](https://github.com/bashbunni/dotfiles)
- [@ChristianLempa](https://github.com/ChristianLempa/dotfiles)
- [@LukeSmithxyz](https://github.com/LukeSmithxyz/voidrice) <!--LARBS-->
- [@reedrw](https://github.com/reedrw/dotfiles)
- [@sudopluto](https://github.com/sudopluto/dotfiles)
- [@ThePrimeagen](https://github.com/ThePrimeagen/.dotfiles)


#### @Fireship: [~/.dotfiles in 100 Seconds]((https://youtu.be/r_MpUP6aKiQ&ab_channel=Fireship))
<!-- - Theme? -->
- notice easy ZSH **prompt** tweaks
- keep files like `.zsh_history` in `~/`
- relevant **symlinks** as in our [mvlns.sh script](/scripts/mvlns.sh)
<!-- - ~~brew~~ but **curl** (!) -->


## index

```markdown
# dotfiles
.
├── .bashrc
├── .gitconfig
├── .taskrc
├── .vimrc
├── .zshrc
├── neofetch-bk.conf
└── scripts/
    └── mvlns.sh
```


<!--
### .bashrc
Default 🥱
-->

### .gitconfig

- Github's designated web-based Git operations **user email address**, found in [github.com/settings/emails](https://github.com/settings/emails)

<!--
(### ssh)

(### task)
Default 🥱

### vim 
-->

### .zshrc
- Slightly tweaked [OhMyZsh](https://github.com/ohmyzsh/ohmyzsh) config
- Cherry-picked `ZSH_THEME_RANDOM_CANDIDATES`


### neofetch-bk.conf
- Couldn't quite manage to **symlink** the actual neofetch config file
- Therefore I keep my custom dotfile, which I may `mv` to the given box
