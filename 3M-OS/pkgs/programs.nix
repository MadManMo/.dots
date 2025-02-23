pkgs:{

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
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
        plugins = [
          pkgs.vimPlugins.lazy-nvim
          pkgs.vimPlugins.mini-nvim
      ];
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
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-power-menu
      ];
      extraConfig = {
          modes = "window,drun,run,ssh,combi,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power>
      };
    };

  programs.firefox.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      buf = {
      symbol = " ";
      };
      c = {
        symbol = " ";
      };
      directory = {
        read_only = " 󰌾";
      };
      docker_context = {
        symbol = " ";
      };
      fossil_branch = {
        symbol = " ";
      };
      git_branch = {
        symbol = " ";
      };
      golang = {
        symbol = " ";
      };
      hg_branch = {
        symbol = " ";
      };
      hostname = {
        ssh_symbol = " ";
      };
      lua = {
        symbol = " ";
      };
      memory_usage = {
        symbol = "󰍛 ";
      };
      meson = {
        symbol = "󰔷 ";
      };
      nim = {
        symbol = "󰆥 ";
      };
      nix_shell = {
        symbol = " ";
      };
      nodejs = {
        symbol = " ";
      };
      ocaml = {
        symbol = " ";
      };
      package = {
        symbol = "󰏗 ";
      };
      python = {
        symbol = " ";
      };
      rust = {
        symbol = " ";
      };
      swift = {
        symbol = " ";
      };
      zig = {
        symbol = " ";
      };
    };
   };

}
