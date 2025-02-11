{ pkgs, ... }:

{
  home.packages = with pkgs; [
 # ------------------------- // Editing
      ghostty
      foot
      killall
      helix
      starship
      yazi
      nixfmt-rfc-style
      fzf
      comma
      jq
      nh
      inxi
      yad
  ];
