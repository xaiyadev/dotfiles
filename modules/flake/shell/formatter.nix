{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs = with pkgs; [
          nixfmt # nix formating tool
          deadnix # find and remove unused nix files
          statix # Lints and suggestions for the nix programming language
          shellcheck # shell script analysis tool
          shfmt # format .sh files
          taplo # TOML toolkit
          yamlfmt # format .yaml or yml files

          # useful script for statix commands to work
          # https://github.com/isabelroses/dotfiles/blob/23c7db61455348653703d32ffdc2135fd045f6b8/modules/flake/programs/formatter.nix#L22C1-L26C14
          (writeShellScriptBin "statix-fix" ''
            for file in "$@"; do
              ${lib.getExe statix} fix "$file"
            done
          '')
        ];

        settings = {
          on-unmatched = "info";
          tree-root-file = "flake.nix";

          excludes = [
            "secrets/*"
            "assets/*"
          ];

          formatter = {
            nixfmt = {
              command = "nixfmt";
              includes = [ "*.nix" ];
            };

            deadnix = {
              command = "deadnix";

              # Warn if there was any dead nix files
              options = [ "--edit" ];
              includes = [ "*.nix" ];
            };

            statix = {
              command = "statix-fix";
              includes = [ "*.nix" ];
            };

            shellcheck = {
              command = "shellcheck";

              includes = [
                "*.sh"
                "*.bash"
                "*.envrc"
                "*.envrc.*"
              ];
            };

            shfmt = {
              command = "shfmt";
              options = [
                "-s" # simplify the code
                "-w" # write changes if found changes
                "-i"
                "2" # indent files for 2 spaces
              ];

              includes = [
                "*.sh"
                "*.bash"
                "*.envrc"
                "*.envrc.*"
              ];
            };

            taplo = {
              command = "taplo";
              options = "format";
              includes = [ "*.toml" ];
            };

            yamlfmt = {
              command = "yamlfmt";

              includes = [
                "*.yml"
                "*.yaml"
              ];
            };
          };
        };
      };
    };
}
