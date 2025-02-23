
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #pkgs/pkgs.nix
      #programs/programs.nix
      #modules/nvidia.nix
      #.config/waybar/
      #.config/fastfetch/
      #.config/ghostty/
      #.config/cava/
      #.config/btop/
      #.config/gtk-4.0/
      #.config/dunst/
      #.config/helix/
      #.config/rofi/
      #.config/scripts/
    ];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      auto-optimise-store = true;
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.madmanmo = {
      isNormalUser = true;
      description = "madmanmo";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
  };

  # Enable networking
    networking.networkmanager.enable = true;
    networking.hostName = "madmanmo";

  # Set your time zone.
    time.timeZone = "America/New_York";

  # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
  };

  # ------------------------- // Styling options
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/MadManMo/wallpaper/blob/main/wallpaper/redblack1.jpg";
      sha256 = "";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    polarity = "dark";
    opacity.terminal = 0.8;
    targets.gtk.enable = true;
    autoEnable = true;
    cursor.package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
    cursor.name = "BreezeX-RosePine-Linux";
    cursor.size = 24;
    fonts = {
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode";
    };
    sansSerif = {
      package = pkgs.nerd-fonts.iosevka-term;
      name = "IosevkaTerm";
    };
    serif = {
      package = pkgs.nerd-fonts.iosevka-term-slab;
      name = "IosevkaTermSlab";
    };
    emoji = {
      package = pkgs.nerd-fonts.symbols-only;
      name = "NerdFontsSymbols";
    };

    sizes = {
      applications = 11;
      terminal = 11;
      desktop = 11;
      popups = 11;
      };
    };
  };

  environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
  WLR_NO_HARDWARE_CURSORS = "1";
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  LIBVA_DRIVER_NAME = "nvidia";
  XDG_CURRENT_DESKTOP = "Hyprland";
  XDG_SESSION_DESKTOP = "Hyprland";
  XDG_SESSION_TYPE = "wayland";
  QT_QPA_PLATFORMTHEME = "qt5ct";
  QT_QPA_PLATFORM = "wayland;xcb";
  QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  GDK_BACKEND = "wayland,x11";
  MOZ_ENABLE_WAYLAND = "1";
  };

   xdg.portal = {
     enable = true;
     wlr.enable = true;
     extraPortals = with pkgs; [
       xdg-desktop-portal-gtk
       xdg-desktop-portal-wlr
       xdg-desktop-portal
    ];
    configPackages = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
      xdg-desktop-portal 
     ];
   };

   programs.hyprland = {
     enable = true;
     xwayland.enable = true;
   };

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.neovim = {
      enable = true;
      configure = {
        customRC = ''
          set number
          set cc=80
          set list
          set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
          if &diff
            colorscheme kanagawa
          endif
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            mini-nvim
           ];
         };
       };
    };

    programs.xfconf.enable = true;
    programs.file-roller.enable = true;

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

  programs.firefox.enable = true;

  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[BASH](bright-white) ";
      zsh_indicator = "[ZSH](bright-white) ";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
  };


  users = {
    mutableUsers = true;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      #outputs.overlays.additions
      #outputs.overlays.modifications
      #outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
 # ------------------------- // Essential
      wget
      git
      gh
      ghr
      #kitty
      #vim

 # -------------------------- // Desktop
      waybar
      rofi-power-menu
      hyprlock
      swww
      hellwal
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      dunst
      rofi-wayland-unwrapped
      networkmanagerapplet
      wireplumber
      playerctl

 # ------------------------- // Editing
      ghostty
      foot
      helix
      tmux
      killall
      starship
      bash
      yazi
      nixfmt-rfc-style
      fzf
      comma
      jq
      nh
      inxi
      yad

  # ------------------------- // Theming
      gnome-tweaks
      gnome-settings-daemon
      gnome-themes-extra
      gtk-engine-murrine
      gtk3
      gtk4
      glib # gtk theme management
      gsettings-desktop-schemas # gsettings schemas
      desktop-file-utils # for updating desktop database
      kanagawa-icon-theme
      kanagawa-gtk-theme
      kdePackages.qt6ct
      rose-pine-cursor
      dconf-editor # dconf editor

 # ------------------------- // Utility
      imv
      mpv
      grim
      slurp
      wl-clipboard
      pavucontrol
      libnotify
      fastfetch
      gparted

 # ------------------------- // Fun
      wpgtk
      figlet
      mission-center
      cava
      btop
 # ------------------------- // Applications
      obs-studio
      discord-canary
      spotify spicetify-cli
      spotify
      gimp
      davinci-resolve
      ardour
      obsidian
      unityhub
      google-chrome
      swappy
  ];
 # ------------------------- // Fonts
  fonts.packages = with pkgs; [
  font-awesome
  fira-code-symbols
  fira-code
  pkgs.nerd-fonts.fira-code
  pkgs.nerd-fonts.jetbrains-mono
  pkgs.nerd-fonts.symbols-only
  pkgs.nerd-fonts.iosevka-term
  pkgs.nerd-fonts.iosevka-term-slab
  ];

  environment.pathsToLink = [ "share/foot" ];

  # Enable OpenGL
  hardware.graphics.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  open = false;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # List services that you want to enable:

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # ------------------------- // Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

   services.gvfs.enable = true;
   services.tumbler.enable = true;

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # ------------------------- // Drawing
  hardware = {
    #tablet
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  # ------------------------- // Bluetooth
  bluetooth = {
     enable = true;
     powerOnBoot = true;
   };
 };
  services.blueman.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?
 
}
