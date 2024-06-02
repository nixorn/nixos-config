{flake, ...}: let
  inherit (flake) inputs;
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixorn-legion"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  programs.xwayland.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  users.users.nixorn = {
    isNormalUser = true;
    description = "nixorn";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  home-manager.users.nixorn = {pkgs, ...}: {
    home.packages = with pkgs; [
      gimp
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
      gnome.gnome-tweaks
      crawlTiles
      cataclysm-dda
      obsidian
      docker
      texliveSmall
      alejandra
      nil
      iputils
      redis
      graphviz
      vivaldi
      p7zip
      mindustry-wayland
      shattered-pixel-dungeon
      jq
      testdisk-qt
      wireguard-tools
      commitizen
      woeusb-ng
      ntfs3g
      ffmpeg
      filezilla
      # rust shit
      rustup
      gcc
      libgcc
    ];

    programs.firefox.enable = true;
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
        ms-toolsai.jupyter
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

  environment.systemPackages = [];

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
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
    nixPath = ["nixpkgs=flake:nixpkgs"];
  };
}
