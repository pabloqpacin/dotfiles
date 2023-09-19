{ config, pkgs, ... }:

{
  home.username = "pabloqpacin";
  home.homeDirectory = "/home/pabloqpacin";

  home.stateVersion = "23.05";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in the Nix store.
    # # Activating the configuration will then make '~/.screenrc' a symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually source
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/pabloqpacin/etc/profile.d/hm-session-vars.sh
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = [
    # CLI tools
    pkgs.bat
    pkgs.btop
    pkgs.bottom
    pkgs.eza
    pkgs.tldr
    # Development
      # pkgs.neovim
    pkgs.tmux
    pkgs.lf
    # Misc
    pkgs.neofetch
      # pkgs.go
      # pkgs.npm
      # pkgs.pwsh
      # pkgs.build-essential

    # # https://ryantm.github.io/nixpkgs/languages-frameworks/vim/#vim
    # (pkgs.neovim.override {
    #   configure = {
    #     packages.myPlugins = with pkgs.vimPlugins; {
    #       start = [
    #         (nvim-treesitter.withPlugins (
    #           plugins: with plugins; [
    #             nix
    #             python
    #           ]
    #         ))
    #       ];
    #     };
    #   };
    # })

    # It is sometimes useful to fine-tune packages, for example, by applying overrides. You can do that directly here,
    # just don't forget the parentheses. Maybe you want to install Nerd Fonts with a limited number of fonts?
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })    # "FiraCode"

    # # You can also create simple shell scripts directly inside your configuration. For example, this adds a command 'my-hello' to your environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # https://discourse.nixos.org/t/using-home-manager-to-control-default-user-shell/8489
  programs.zsh = {
    enable = true;
    shellAliases = {
      supdawg = "echo 'not much wbu'";
      ip = "ip -c";
      eza="eza --icons";
      ezad="eza --icons -la -ShiI .git --no-user --octal-permissions --git";
      ezatl="eza --icons -TL";
      ezatal="eza --icons -laI .git --no-user --no-permissions --no-filesize --git -TL";
    };
    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/.zsh_history
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "nmap" ];
      theme = "random";
      # zsh_theme_random_candidates=( "foo" "bar" );
      # zsh_custom="$HOME/dotfiles/zsh";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env = { "TERM" = "xterm-256color"; };
      window.opacity = 0.80;
      font = {
        size = 10;
        bold.family = "FiraCode Nerd Font";
        normal.family = "FiraCode Nerd Font";
      };
      # shell.program = /foo/zsh;
    };
  };

  # $HOME/.config/nvim/init.lua --> /nix/store/1234-home-manager-files/.config/nvim/init.lua
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set relativenumber
    '';
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      zhuangtongfa.material-theme
      vscode-icons-team.vscode-icons
      s-nlf-fh.glassit
    ];
  };

  programs.home-manager.enable = true;

}

  # https://stackoverflow.com/questions/38576616/how-to-install-gtk-themes-under-nixos-without-hacky-scripts
  # { gtk = {
  #    enable = true;
  #    theme = {
  #      name = "Materia-dark";
  #      package = pkgs.materia-theme;
  #     };
  # };}

# - # https://nixos.wiki/wiki/Home_Manager
# - # https://nix-community.github.io/home-manager/index.html#ch-installation
# - # alacritty -- https://hugoreeves.com/posts/2019/nix-home/
