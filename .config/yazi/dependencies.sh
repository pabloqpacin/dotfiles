
# WIP!!

# https://yazi-rs.github.io/docs/installation/

setup_popos(){

    # nerd-fonts (recommended)
    # ffmpegthumbnailer (for video thumbnails)
    # unar (for archive preview)
    sudo apt install unar
    # jq (for JSON preview)
    apt install jq
    # poppler (for PDF preview)
    # fd (for file searching)
    cargo install fd-find || apt install fd-find
    # rg (for file content searching)
    apt install ripgrep
    # fzf (for quick file subtree navigation)
    go install github.com/junegunn/fzf@latest || apt install fzf
    # zoxide (for historical directories navigation)
    cargo install zoxide || apt install fzf
    # xclip / wl-clipboard / xsel (for system clipboard support)
    apt install xclip wl-clipboard xsel

}


setup_arch(){
    sudo pacman -Su yazi ffmpegthumbnailer unarchiver jq poppler fd ripgrep fzf zoxide
}
