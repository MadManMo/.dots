{ pkgs, ... }:

{
  home.packages = with pkgs; [
 # ------------------------- // Desktop
      waybar
      wlogout
      hyprlock
      swww
      hellwal
      hyprcursor
      swaynotificationcenter
      networkmanagerapplet
      wireplumber
      playerctl
 ];
