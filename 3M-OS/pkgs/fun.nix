{ pkgs, ... }:

{
  home.packages = with pkgs; [
 # ------------------------- // Fun
      wpgtk
      figlet
      mission-center
      cava
      btop
  ];
