# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
      };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Configure keymap in X11 -- Wayland DM
  services.xserver = {
    layout = "es";
    xkbVariant = "";
    enable = true;
    videoDrivers = [ "intel" "nvidia" ];
    # Finally research :: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/services/x11/display-managers
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    # See chatGPT chat for theming!! -- just HOME-MANAGER it
  };

  # gtk3 = {
  #   gtkTheme = "rose-pine-gtk-theme";
  #   iconTheme = "bar";
  # };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pabloqpacin = {
    isNormalUser = true;
    description = "Pablo Quevedo";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "input" ];   # vboxusers
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Hardware
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    bluetooth.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";	# see CODE / Wayland

  # List packages installed in system profile. To search, run:
  # $ nix search wget --> nix --extra-experimental-features "nix-command flakes" search nixpkgs <pkg>
  environment.systemPackages = with pkgs; [
    home-manager cron
    alacritty bat brave btop cheat delta exa fd file fzf git neofetch ripgrep taskwarrior tldr tmux unzip # vscode
    rofi-power-menu rofi-wayland swaybg swayidle swaylock-effects waybar # mpd
    libnotify mako dunst brightnessctl
    # polkit_gnome libsForQt5.polkit-kde-agent # https://nixos.wiki/wiki/Polkit >> ../autostart ?
    shotman sway-contrib.grimshot gucharmap	# CHOOSE
    efibootmgr nmap nmapsi4 nvme-cli os-prober wireshark-qt		# sqlmap; virtualbox *aside*
    # mysql mysql-workbench 	# https://stackoverflow.com/questions/76006529/how-to-instal-mysql-workbench-on-nixos
    wireplumber pipewire alsa-utils alsa-tools pamixer pavucontrol
    rose-pine-gtk-theme lxappearance
    rustup gnat13 nodejs_20	# ...
    spotify 			# ...
    # mpv 			# https://nixos.wiki/wiki/MPV
    vscodium			# Extensions not applied automatically upon nixos-rebuild
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        vscode-icons-team.vscode-icons
        yzhang.markdown-all-in-one
        naumovs.color-highlight
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      	# For the sha256: $ nix-prefetch-url --type sha256 <marketplace_version_download_link>
        {
	  name = "tokyo-night";
	  publisher = "enkia";
	  version = "0.9.9";
	  sha256 = "1jwy94w0iqy7p5d4hk901hj74pi8wvanz6z2bwwlpb4hfz1zrijm";
	}
	# {
	#   yandeu.five-server
	# }
      ];
    })
    # ciscoPacketTracer8
    # ***
    # Unfortunately, we cannot download file CiscoPacketTracer_821_Ubuntu_64bit.deb automatically.
    # Please go to https://www.netacad.com to download it yourself, and add it to the Nix store
    # using either
    #   nix-store --add-fixed sha256 CiscoPacketTracer_821_Ubuntu_64bit.deb
    # or
    #   nix-prefetch-url --type sha256 file:///path/to/CiscoPacketTracer_821_Ubuntu_64bit.deb
    # 
    # ***


    # Fix Discord in wayland
    (pkgs.writeShellApplication {
      name = "discord";
      text = "${pkgs.discord}/bin/discord --use-gl=desktop";
    })
    (pkgs.makeDesktopItem {	# No icon tho...
      name = "discord";
      exec = "discord";
      desktopName = "Discord";
      # icon = "foo";
    })
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    nvidiaPatches = true;
  };
  security.pam.services.swaylock = {};	# https://github.com/NixOS/nixpkgs/issues/158025#issuecomment-1344766809

  # Audio
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services = {
    blueman.enable = true;
  };

  # Zsh and Neovim ...
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure.packages.myVimPackage = with pkgs.vimPlugins; { start = [ packer-nvim ]; };
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.wireshark.enable = true;

  # Thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
  

  # Nerd fonts
  fonts = {
    # enableDefaultFonts = true;
    fonts = with pkgs; [
      font-awesome
      noto-fonts-emoji
      material-design-icons
      (nerdfonts.override { fonts = [ "FiraMono" "JetBrainsMono" ]; })
    ];
    # fontconfig = {		# It worked too well!
    #   defaultFonts = {
    #     emoji = [ "Noto Color Emoji" ];
    #     serif = [ "FiraMono Nerd Font" ];
    #     sansSerif = [ "FiraMono Nerd Font" ];
    #     monospace = [ "FiraMono Nerd Font Mono" ];
    #   };
    # };
  };

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

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

  # https://github.com/hyprwm/Hyprland/issues/725
  # https://github.com/NixOS/nixpkgs/issues/157101



  # List services that you want to enable:
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  users.extraGroups.vboxusers.members = [ "pabloqpacin" ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
