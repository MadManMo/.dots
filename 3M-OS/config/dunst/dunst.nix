{ config, lib, pkgs, ... }:

let
  inherit (lib)
    types
    concatStringsSep
    escapeShellArgs
    ;
  inherit (lib.options) mkEnableOption mkOption literalExample;

  cfg = config.services.dunst;
  reservedSections = [
    "global"
    "experimental"
    "frame"
    "urgency_low"
    "urgency_normal"
    "urgency_critical"
  ];
in
{

  options.services.dunst = {

    enable = mkEnableOption "the dunst notifications daemon";

    iconThemes = mkOption {
      type = types.listOf types.str;
      default = [ "Adwaita" ];
      description = ''
        List of icon themes to use. The name has to be that of the top level directory of the icon theme. Make sure to also add the corresponding package to your system packages.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Extra command line options for dunst
      '';
    };

    globalConfig = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = ''
        The global configuration section for dunst.
      '';
    };

    urgencyConfig = {
      low = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          The low urgency section of the dunst configuration.
        '';
      };
      normal = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          The normal urgency section of the dunst configuration.
        '';
      };
      critical = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          The critical urgency section of the dunst configuration.
        '';
      };
    };

    rules = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = {};
      description = ''
        These rules allow the conditional modification of notifications.

        Note that rule names may not be one of the following
        keywords already used internally:
          ${concatStringsSep ", " reservedSections}
        There are 2 parts in configuring a rule: Defining when a rule
        matches and should apply (called filtering in the man page)
        and then the actions that should be taken when the rule is
        matched (called modifying in the man page).
      '';
      example = literalExample ''
        signed_off = {
          appname = "Pidgin";
          summary = "*signed off*";
          urgency = "low";
          script = "pidgin-signed-off.sh";
        };
      '';
    };

  };

  config =
    let
      dunstConfig = lib.generators.toINI {} allOptions;
      allOptions = {
        global = {
          icon_theme = lib.concatStringsSep ", " cfg.iconThemes;
        } // cfg.globalConfig;
        urgency_normal = cfg.urgencyConfig.normal;
        urgency_low = cfg.urgencyConfig.low;
        urgency_critical = cfg.urgencyConfig.critical;
      } // cfg.rules;

      dunst-args = [
        "-config"
        (pkgs.writeText "dunstrc" dunstConfig)
      ] ++ cfg.extraArgs;

    in
      lib.mkIf cfg.enable {

        assertions = lib.flip lib.mapAttrsToList cfg.rules (
          name: conf: {
            assertion = ! lib.elem name reservedSections;
            message = ''
              dunst config: ${name} is a reserved keyword. Please choose
              a different name for the rule.
            '';
          }
        );

        systemd.user.services.dunst.serviceConfig.ExecStart = [ "" "${lib.getBin pkgs.dunst}/bin/dunst ${escapeShellArgs dunst-args}" ];
        # [ "" ... ] is needed to overwrite the ExecStart directive from the upstream service file
        systemd.user.services.dunst.enable = true;

        systemd.packages = [ pkgs.dunst ];
        services.dbus.packages = [ pkgs.dunst ];
      };

}
