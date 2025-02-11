{ pkgs, ... }:

{
  home.packages = with pkgs; [
 # ------------------------- // Utility
      imv
      mpv
      grim
      slurp
      wl-clipboard
      pavucontrol
      rofi
      libnotify
      fastfetch
      gparted
  ];
