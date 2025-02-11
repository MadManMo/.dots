{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:{
  home.username = "madmanmo";
  home.homeDirectory = "/home/madmanmo";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  systemd.user.startServices = "sd-switch";

  # Import Program Configurations
  imports = [
    ./pkgs/fastfetch/default.nix
    ./pkgs/rofi/rofi.nix
    ./config/waybar/waybar.nix
    ./config/wlogout/wlogout.nix
  ];

  home.file."Pictures/Wallpapers" = {
    source = ./config/wallpaper;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ./config/wlogout;
    recursive = true;
  };
  home.file.".face.icon".source = ./config/fastfetch/emil-nier.png;
  home.file.".config/face.jpg".source = ./config/fastfetch/emil-nier.png;
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  programs.dconf.enable = true; #{
  #  "org/virt-manager/virt-manager/connections" = {
  #    autoconnect = [ "qemu:///system" ];
  #    uris = [ "qemu:///system" ];
  #  };
  #};

  #home.sessionVariables = {
  #};

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Styling Options
  #stylix.targets.waybar.enable = false;
  #stylix.targets.rofi.enable = false;
  #stylix.targets.hyprland.enable = false;
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Tokyonight-Dark";
    style.package = pkgs.tokyo-night-gtk;
  };

  program.gtk = {
    enable = true;
      # iconTheme.package = pkgs.nordzy-icon-theme;
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus-Dark";

      theme.package = pkgs.tokyo-night-gtk;
      theme.name = "Tokyonight-Dark";
  };

  # Scripts
  home.packages = [
  ];

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
          };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs.home-manager.enable = true;

  programs = {
    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
       };
      };
    };
    ghostty = {
      enable = true;
      package = pkgs.ghostty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
     starship = {
            enable = true;
            package = pkgs.starship;
     };
    programs.bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        fastfetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      shellAliases = {
        sw = "nh os switch --hostname ${host} /home/${username}/.dotfiles";
        up = "nh os switch --hostname ${host} --update /home/${username}/.dotfiles";
        edit = "nano ~/.dotfiles/configuration.nix";
        rebuild = "nixos-rebuild switch --flake .";
        upgrd = "nix-channel --update && nixos-rebuild switch --upgrade";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        ".." = "cd ..";
      };
    };

    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };
        lib.mkPrio.background = [
          {
            path = "config/wallpapers/nighttime.png";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        image = [
          {
            path = "config/fastfetch/emil-nier.png";
            size = 150;
            border_size = 4;
            border_color = "rgb(0C96F9)";
            rounding = -1; # Negative means circle
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
        lib.mkPrio.input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(CFE6F4)";
            inner_color = "rgb(657DC2)";
            outer_color = "rgb(0D0E15)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };

}
