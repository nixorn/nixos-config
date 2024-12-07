{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixorn-legion"; # Define your hostname.
    networkmanager.enable = true;
  }; 

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
    LC_ALL = "ru_RU.UTF-8";
  };


  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
      
    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    # desktopManager.gnome.enable = true;
    

    # plasma works with rdp
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.plasma5.enable = true;
    
    # libinput.enable = false;

  };


  services.xrdp = { 
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.xwayland.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.containers.enable = true;

  environment.systemPackages = with pkgs; [
    docker
    devenv
  ];

  users.users.nixorn = {
    isNormalUser = true;
    description = "nixorn";
    extraGroups = ["networkmanager" "wheel" "docker" "podman"];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  home-manager.users.nixorn = {pkgs, ...}: {
    home.sessionPath = [
      "/home/nixorn/.npm-packages/bin"
    ];
    home.packages = with pkgs; [
      # games
      dwarf-fortress
      cataclysm-dda
      mindustry-wayland
      ufoai
      openra
      crawlTiles
      wesnoth
      scanmem
      opensoldat
      remmina

      #
      mongodb-compass
      camunda-modeler
      audio-recorder
      helvum
      easyeffects
      gimp
      xq-xml
      aseprite
      steam-run
      inkscape
      libreoffice
      telegram-desktop
      transmission_4-gtk
      nixpkgs-fmt
      ranger
      keepass
      ncdu
      curl
      vesktop
      nom
      comma
      gnome-tweaks
      # gnome.gnome-boxes
      obsidian
      docker
      alejandra
      nil
      iputils
      graphviz
      p7zip
      vivaldi
      jq
      commitizen
      # woeusb-ng
      ntfs3g
      ffmpeg
      filezilla
      vlc
      google-chrome
      sops
      rclone
      # mediainfo
      vim
      # rust shit
      rustup
      gcc
      libgcc
      # python3
      python3
    ];

    # programs.firefox.enable = true;
    programs.pandoc.enable = true;
    programs.obs-studio.enable = true;
    programs.thunderbird = {
      enable = true;
      profiles.nixorn = {
        isDefault = true;
      };
    };
    programs.emacs = {
      extraConfig = ''
        (setq make-backup-files nil)
      '';

      enable = true;
    };

    programs.htop.enable = true;
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        mkhl.direnv
        arrterian.nix-env-selector
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        haskell.haskell
        redhat.vscode-xml
        jebbs.plantuml
        ms-python.python
      ];
    };
    programs.tmux.enable = true;
    programs.git = {
      enable = true;
      userName = "a-kanev@yandex.ru";
      userEmail = "a-kanev@yandex.ru";
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.bash = {
      enable = true;

      sessionVariables = {
        EDITOR = "emacs -nw";
      };
    };

    home.stateVersion = "23.11";
  };
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";

  systemd.oomd = {
    enable = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  zramSwap.enable = true;

  # хелпер для запуска всего
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d --keep 5";
    };
  };
  environment.sessionVariables.FLAKE = "/home/nixorn/system"; # Чтобы работал nh

  nix = {
    package = pkgs.lix;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      accept-flake-config = true;
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
      trusted-users = [
        "root"
        "nixorn"
        "@wheel"
      ];
      builders-use-substitutes = true;
      trusted-substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://numtide.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
    nixPath = ["nixpkgs=flake:nixpkgs"];
  };
}
