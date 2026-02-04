{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # The nix formatter checks the files instead of formating them
      # The formatter is put into a workflow at .tangled/workflows/format.yaml

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
          (writeShellScriptBin "statix-check" ''
            for file in "$@"; do
              ${lib.getExe statix} check "$file"
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
              options = "-c"; # Check files instead of formating

              includes = [ "*.nix" ];
            };

            deadnix = {
              command = "deadnix";

              # Warn if there was any dead nix files
              options = [ "--fail" ];
              includes = [ "*.nix" ];
            };

            statix = {
              command = "statix-check";
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
                "-d" # error out of the changes
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
              options = "error";
              includes = [ "*.toml" ];
            };

            yamlfmt = {
              command = "yamlfmt";
              options = [
                "-dry"
                "-continue_on_error"
              ];

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
