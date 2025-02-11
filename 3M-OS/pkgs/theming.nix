{ pkgs, ... }:

{
  home.packages = with pkgs; [
 # ------------------------- // Theming
      nwg-look
      gtk3
      gtk4
      glib # gtk theme management
      gsettings-desktop-schemas # gsettings schemas
      desktop-file-utils # for updating desktop database
      hicolor-icon-theme # Base fallback icon theme
      adwaita-icon-theme # Standard GNOME icons, excellent fallback
      dconf-editor # dconf editor
  ];
