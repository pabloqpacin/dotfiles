# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# https://github.com/iknacx/dotfiles


{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [ ./hardware-configuration.nix ];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    devices = [ "nodev" ];
    efiSupport = true;
    useOSProber = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "Europe/Madrid";
  console.keyMap = "es";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_IDENTIFICATION = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
      LC_MONETARY = "es_ES.UTF-8";
      LC_NUMERIC = "es_ES.UTF-8";
      LC_NAME = "es_ES.UTF-8";
      LC_TIME = "es_ES.UTF-8";
      LC_PAPER = "es_ES.UTF-8";
      LC_ADDRESS = "es_ES.UTF-8";
      LC_TELEPHONE = "es_ES.UTF-8";
    };
  };

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11" "nvidia-settings" "nvidia-persistenced"
      ];
    enableWiresharkQt = true;           # TODO: conflict with program wireshark 
  };

  hardware = {
    nvidia = {
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
  };

  # Configure keymap in X11 -- Wayland DM
  services.xserver = {
    enable = true;
    layout = "es";
    xkbVariant = "";
    videoDrivers = [ "intel" "nvidia" ];
    autorun = false;
    # displayManager.enable = false;
    # displayManager.gdm = { enable = true; wayland = true; };
    # https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/services/x11/display-managers
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # services.printing.enable = true;

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    blueman.enable = true;
  };
  
  virtualisation.virtualbox = {
    host.enable = true;
    guest.enable = true;
  };

programs = {
    hyprland = {
      enable = true;
      nvidiaPatches = true;
      xwayland.enable = true;
    };
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      # configure.packages.myVimPackage = with pkgs.vimPlugins; { start = [ packer-nvim ]; };
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    wireshark = {
      enable = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ];})
    # noto-fonts-emoji font-awesome
  ];

  # fonts.fontconfig.defaultFonts = {
  #   emoji = [ "Noto Color Emoji" ];
  #   serif = [ "FiraMono Nerd Font" ];
  #   sansSerif = [ "FiraMono Nerd Font" ];
  #   monospace = [ "FiraMono Nerd Font Mono" ];
  # };

  # nixpkgs.overlays = [
  #   (self: super: {
  #     waybar = super.waybar.overrideAttrs (oldAttrs: {
  #       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  #     });
  #   })
  # ];

  # programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
  #   mesonFlags = (oa.mesonFlags or  []) ++ [ "-Dexperimental=true" ];
  #   patches = (oa.patches or []) ++ [
  #     (pkgs.fetchpatch {
  #       name = "fix waybar hyprctl";
  #       url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
  #       sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
  #     })
  #   ];
  # });

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # $ nix search wget --> nix --extra-experimental-features "nix-command flakes" search nixpkgs <pkg>
  environment.systemPackages = with pkgs; [
    alacritty brave btop git neofetch ripgrep tldr tmux
    alsa-utils alsa-tools pamixer pavucontrol
    swaybg swayidle swaylock-effects waybar
    rofi-power-menu rofi-wayland
    brightnessctl libnotify mako
    efibootmgr nvme-cli os-prober
    # mpd mpv
    # home-manager cron
    # rustup gnat13 nodejs_20
    # polkit_gnome libsForQt5.polkit-kde-agent
    # mysql mysql-workbench 	# https://stackoverflow.com/questions/76006529/how-to-instal-mysql-workbench-on-nixos
    # ciscoPacketTracer8
    # ***
    #   Unfortunately, we cannot download file CiscoPacketTracer_821_Ubuntu_64bit.deb automatically.
    #   Please go to https://www.netacad.com to download it yourself, and add it to the Nix store
    #   using either
    #     nix-store --add-fixed sha256 CiscoPacketTracer_821_Ubuntu_64bit.deb
    #   or
    #     nix-prefetch-url --type sha256 file:///path/to/CiscoPacketTracer_821_Ubuntu_64bit.deb
    # ***
  ];

  users.users.pabloqpacin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      bat cheat delta exa fd file fzf taskwarrior unzip
      shotman sway-contrib.grimshot gucharmap   # lxappearance
      nmap nmapsi4 wireshark        # sqlmap
      spotify
      (pkgs.writeShellApplication {
          name = "discord";
          text = "${pkgs.discord}/bin/discord --use-gl=desktop"; })
      (pkgs.makeDesktopItem {
          name ="discord";
          exec = "discord";
          desktopName = "Discord";
          icon = "${pkgs.discord}/share/applications/discord.desktop";
          # icon = "${pkgs.discord}/share/icons/hicolor/256x256/apps/discord.png";
      })
      vscodium
      # (vscode-with-extensions.override {
      #   vscode = vscodium;
      #   vscodeExtensions = with vscode-extensions; [
      #     bbenoist.nix
      #     vscode-icons-team.vscode-icons
      #     yzhang.markdown-all-in-one
      #     naumovs.color-highlight
      #   ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #     For the sha256: $ nix-prefetch-url --type sha256 <marketplace_version_download_link>
      #     {
	    #       name = "tokyo-night";
	    #       publisher = "enkia";
	    #       version = "0.9.9";
	    #       sha256 = "1jwy94w0iqy7p5d4hk901hj74pi8wvanz6z2bwwlpb4hfz1zrijm";
	    #     }
	    #     # { yandeu.five-server }
      #   ];
      # })
    ];
    # description = "Pablo Quevedo";
  };

  users.extraGroups = {
      vboxusers.members = [ "pabloqpacin "];
      wireshark.members = [ "pabloqpacin "];
  };

  # gtk3 = { gtkTheme = "rose-pine-gtk-theme"; iconTheme = "bar"; };

  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # services.openssh.enable = true;

  # security.pam.services.swaylock = {};	# https://github.com/NixOS/nixpkgs/issues/158025#issuecomment-1344766809
  # security.rtkit.enable = true;
  # security.polkit.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "23.11"; # Did you read the comment?

}
