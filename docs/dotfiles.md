# Dotfiles (@pabloqpacin)

## Documentation —


<details>
<summary>Click to expand</summary>

### dotfiles
- @AndrewBurguess: [Dotfiles! Here's how I organize them](https://youtu.be/5oXy6ktYs7I)
- @sudopluto: [Using Chezmoi to Automate dotfiles / Config Files (+ my bashrc)](https://youtu.be/id5UKYuX4-A) <!--CONTAINERZ-->


#### @Fireship: [~/.dotfiles in 100 Seconds]((https://youtu.be/r_MpUP6aKiQ&ab_channel=Fireship))
<!-- - Theme? -->
- notice easy ZSH **prompt** tweaks
- keep files like `.zsh_history` in `~/`
- relevant **symlinks** as in our [mvlns.sh script](/scripts/mvlns.sh)
<!-- - ~~brew~~ but **curl** (!) -->


#### for reference <!--Models/Samples/Examples/References-->
- [@AndrewBurguess](https://github.com/andrew8088/dotfiles)
- [@bashbunni](https://github.com/bashbunni/dotfiles)
- [@ChristianLempa](https://github.com/ChristianLempa/dotfiles)
- [@LukeSmithxyz](https://github.com/LukeSmithxyz/voidrice) <!--LARBS-->
- [@reedrw](https://github.com/reedrw/dotfiles)
- [@sudopluto](https://github.com/sudopluto/dotfiles)
- [@ThePrimeagen](https://github.com/ThePrimeagen/.dotfiles)


### vim stuff

- @Leeren: [Vim: Tutorial on Editing, Navigation, and File Management (2018) [1h]](https://youtu.be/E-ZbrtoSuzw&ab_channel=Leeren)

> mind documentation outside of repo


</details>

## Dotfiles' Tweaks

### .bashrc
<!-- Default 🥱 -->

### .gitconfig

#### [user] email = ...@users.noreply.github.com
- Use Github's designated email address for **web-based Git operations**, to be found at [github.com/settings/emails](https://github.com/settings/emails).

#### [alias] pretty
- [How to configure 'git log' to show 'commit date'](https://stackoverflow.com/questions/14243380/how-to-configure-git-log-to-show-commit-date)
  - `git log --graph --pretty=format:'%C(auto)%h%d (%cr) %cn <%ce> %s' ()`
- [git-log(1) Manual Page: PRETTY FORMATS](https://mirrors.edge.kernel.org/pub/software/scm/git/docs/git-log.html#_pretty_formats)
- [Pretty Formats](https://git-scm.com/docs/pretty-formats/2.39.0)

```bash
[alias]
    pretty = log --graph --pretty=format:'%C(auto)%h%d (%cs) %s' --decorate
```

> Mind: `(%ct)` = committer date, **[UNIX timestamp](https://www.unixtimestamp.com/#:~:text=What%20is%20the%20unix%20time,date%20and%20the%20Unix%20Epoch.)**

<!--
(### ssh)
-->

### .taskrc
<!-- Default 🥱 -->

### .vimrc


#### " statusline stuff
- @LearnVimscriptTheHardWay: [Status Lines](https://learnvimscriptthehardway.stevelosh.com/chapters/17.html)
- @Shapeshed: [Build your own Vim statusline](https://shapeshed.com/vim-statuslines/)

```vim
" Statusline
  set laststatus=2
  set statusline=
  set statusline=%F         " Path to the file
  set statusline+=%=        " Switch to the right side
  set statusline+=%l        " Current line
  set statusline+=/         " Separator
  set statusline+=%L        " Total lines

" Git for statusline
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

  set statusline+=%{StatuslineGit()}
```


### .zshrc

> curated `$RANDOM_THEME` list ([OhMyZsh](https://github.com/ohmyzsh/ohmyzsh))


### neofetch.conf

<!--
- Couldn't quite manage to **symlink** the actual neofetch config file
- Therefore I keep my custom dotfile, which I may `mv` to the given box
-->