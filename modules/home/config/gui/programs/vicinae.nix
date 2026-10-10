{
  osConfig,
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    ;

  inherit (osConfig.sylveon.graphical) sway;

  mkRayExt = name: sha256: npmDepsHash: (config.lib.vicinae.mkRayCastExtension { # TODO: global?
    inherit name sha256 npmDepsHash;
    rev = "b94f62edfdf9afe433c46aa2de870b48feae6520";
  });

in
{
  config = mkIf sway.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = false; # Is started through sway
      enableFirefoxIntegration = false; # switch to firefox? TODO

      settings = {
        "$schema" = "https://vicinae.com/schemas/config.json";

        close_on_focus_loss = false;
        pop_to_root_on_close = true;
        escape_key_behavior = "navigate_back";
        search_files_in_root = true;

        launcher_window = {
          opacity = 0.95;
          layer_shell.keyboard_interactivity = "exclusive";
        };

        font.normal = {
          family = "Maple Mono";
          size = 9.5;
        };

        theme.dark = {
          name = "catppuccin-mocha";
          icon_theme = "Catppuccin Mocha Flamingo";
        };

        providers = {
          "@knoopx/store.vicinae.github".preferences = {
            defaultIssueFilter = "my";
            defaultRepositoryFilter = "my";
            numberOfResults = "50";
            # githubToken TODO
          };

          "@system7/store.vicinae.keepassxc".preferences = {
            database = "/mnt/webdav/apricot/keepass/current.kdbx";
            lockAfterInactivity = "5";
          };

          calculator.entrypoints = {
            history.enabled = false;
            refresh-rates.enabled = false;
          };

          core.entrypoints = {
            list-extensions.enabled = false;
            manage-fallback.enabled = false;
            open-config-file.enabled = false;
            open-default-config.enabled = false;
            reload-scripts.enabled = false;
            report-bug.enabled = false;
            search-tray.enabled = false;
            settings.enabled = false;
            show-logs.enabled = false;
            sponsor.enabled = false;
            store.enabled = false;
          };

          manage-shortcuts.entrypoints = {
            create.enabled = false;
            manage.enabled = false;
          };

          power.entrypoints = {
            hibernate.enabled = false;
            lock.enabled = false;
            sleep.enabled = false;
            soft-reboot.enabled = false;
            suspend.enabled = false;
          };

          browser-extension.enabled = false;
          developer.enabled = false;
          font.enabled = false;
          media.enabled = false;
          raycast-compat.enabled = false;
          snippets.enabled = false;
          theme.enabled = false;
          wm.enabled = false;
        };
      };

      extensions = mkMerge [
        (with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [ 
          nix 
          keepassxc
        ])

        [(mkRayExt "tailscale"
          "sha256-IM/hG7nnhYIqF1HyTgzE4CC8Nb+WaTP3+bOWhDykGC4="
          "sha256-mnhIxY2SkeXNyt5PHu3RaLdYdnsKwwfLoEsSXUhI9Ww="
        )]
      ];
    };
  };
}
