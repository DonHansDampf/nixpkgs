{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager."2bwm";
in

{
  options = {
    services.xserver.windowManager."2bwm" = {
        enable = mkEnableOption "2bwm";
        startThroughSession = mkOption {
            type = with types; bool;
            default = false;
            description = "
                Start the window manager through the script defined in 
                sessionScript. Defaults to the the bspwm-session script
                provided by 2bwm
            ";
        };
        sessionScript = mkOption {
            default = "${pkgs."2bwm"}/bin/2bwm";
            # defaultText = "{pkgs."2bwm"}/bin/2bwm";
            description = "
                The start-session script to use. Defaults to the
                provided bspwm-session script from the 2bwm package.

                Does nothing unless `2bwm.startThroughSession` is enabled
            ";
        };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "2bwm";
      start = if cfg.startThroughSession
        then cfg.sessionScript
        else ''
            export _JAVA_AWT_WM_NONREPARENTING=1
            # SXHKD_SHELL=/bin/sh ${pkgs.sxhkd}/bin/sxhkd -f 100 &
            ${pkgs.rxvt_unicode}/bin/urxvt &
            ${pkgs."2bwm"}/bin/2bwm
        '';
    };
    environment.systemPackages = [ pkgs."2bwm" ];
  };
}
