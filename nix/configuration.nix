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
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pabloqpacin = {
    isNormalUser = true;
    description = "Pablo Quevedo";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
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

  environment.sessionVariables.NIXOS_OZONE_WL = 1;	# see CODE / Wayland

  # List packages installed in system profile. To search, run:
  # $ nix search wget --> nix --extra-experimental-features "nix-command flakes" search nixpkgs <pkg>
  environment.systemPackages = with pkgs; [
    alacritty bat brave btop cheat exa fzf git neofetch ripgrep tldr tmux unzip # vscode
    dunst brightnessctl rofi-power-menu rofi-wayland swaybg swayidle swaylock-effects waybar
    efibootmgr nmap nmapsi4 nvme-cli os-prober virtualbox
    wireplumber pipewire alsa-utils alsa-tools pamixer
    rustup gnat13 nodejs_20a	# ...
    spotify 			# ...
    vscodium
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        enkia.tokyo-night
        vscode-icons-team.vscode-icons
        yzhang.markdown-all-in-one
        naumovs.color-highlight
        yandeu.five-server
      ];
    })


    # Fix Discord in wayland
    (pkgs.writeShellApplication {
      name = "discord";
      text = "${pkgs.discord}/bin/discord --use-gl=desktop";
    })
    (pkgs.makeDesktopItem {
      name = "discord";
      exec = "discord";
      desktopName = "Discord";
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
  

  # Nerd fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraMono" "JetBrainsMono" ]; })
  ];



  # List services that you want to enable:

  # {
  #   virtualisation.virtualbox.host.enable = true;
  #   users.extraGroups.vboxusers.members = [ "pabloqpacin" ];
  # }

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
