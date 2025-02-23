{ pkgs, ...}:

 {

 # -------------------------- // Desktop
      waybar
      wlogout
      hyprlock
      swww
      hellwal
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      dunst
      networkmanagerapplet
      wireplumber
      playerctl

 # ------------------------- // Editing
      ghostty
      foot
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
      gtk3
      gtk4
      glib # gtk theme management
      gsettings-desktop-schemas # gsettings schemas
      desktop-file-utils # for updating desktop database
      hicolor-icon-theme # Base fallback icon theme
      #adwaita-icon-theme # Standard GNOME icons, excellent fallback
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
  noto-fonts-cjk-sans
  nerd-fonts.roboto-mono
  nerd-fonts.noto-font
  nerd-fonts.fria-code
  nerd-fonts.fira-mono
  nerd-fonts.jetbrains-mono
  nerd-fonts.symbols-only
  ];

  environment.pathsToLink = [ "share/foot" ]
}
