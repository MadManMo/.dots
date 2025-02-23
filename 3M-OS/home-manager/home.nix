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
    #./pkgs/fastfetch/default.nix
    #./pkgs/rofi/rofi.nix
    #./config/waybar/waybar.nix
    #./config/wlogout/wlogout.nix
    inputs.nix-doom-emacs.hmModule
  ];

  programs.doom-emacs = {
    enable = true;
    # Directory containing config.el, init.el, and packages.el
    doomPrivateDir = ./PATH_TO_YOUR_DOOM_CONFIG_DIR;
  };

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

  programs.dconf.enable = true;
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Tokyonight-Dark";
    style.package = pkgs.tokyo-night-gtk;
  };

  program.gtk = {
    enable = true;
      # iconTheme.package = pkgs.nordzy-icon-theme;
      iconTheme.package = pkgs.hicolor-icon-theme;
      iconTheme.name = "Hicolor-icon-theme";

      theme.package = pkgs.hicolor-icon-theme;
      theme.name = "Hicolor-icon-theme";
  };

  # Scripts
  home.packages = [
  ];

  programs.home-manager.enable = true;

}
