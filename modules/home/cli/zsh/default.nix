{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  osConfig,
  config,
  specialArgs,
  ...
}:
with lib;
with lib.${namespace};
let
    rose-pine-toml = (builtins.fromTOML 
      (builtins.readFile (builtins.fetchurl { 
        url = ''https://raw.githubusercontent.com/rose-pine/starship/refs/heads/main/rose-pine.toml''; sha256 = "13ywv52sdw7aryx8xskxvgwbj4dnbw40qnff4c9csklsm3d7c9dg"; 
      }))
    );
in
{

    /* The original module is started in nixos, this part is only for configuring the shell */
    config = mkIf osConfig.${namespace}.system.zsh.enable {
      
      programs.zsh = {
        enable = true;
        enableCompletion = true;

        syntaxHighlighting = enabled;
        autosuggestion = enabled;

        plugins = [
          # Nix Shell support
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";

            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "82ca15e638cc208e6d8368e34a1625ed75e08f90"; # v0.8.0
              sha256 = "1l99ayc9j9ns450blf4rs8511lygc2xvbhkg1xp791abcn8krn26";
            };
          }
        ];
      };

      programs.starship = {
        enable = true;
        settings = mkMerge [ 
        # Load rose-pine palette
        { palette = rose-pine-toml.palette; }
        { palettes.rose-pine = rose-pine-toml.palettes.rose-pine; }

        
        (attrsets.genAttrs [ "git_status" "fill" ] (attr: rose-pine-toml.attr))
        
        {
          # Load Characters
          character = {
            success_symbol = "[➜](pine)";
            error_symbol = "[✗](love) ";
          };

          directory = {
            truncation_symbol = mkForce ".../";
            
            # Load rose-pine format and style
            format  = rose-pine-toml.directory.format;
            style = rose-pine-toml.directory.style;

            substitutions = rose-pine-toml.directory.substitutions;
          };


          # Git Theming
          git_branch = {
            format = rose-pine-toml.git_branch.format;
            style = rose-pine-toml.git_branch.style;
          };

          username = {
            style_root = "bg:overlay fg:love";
            style_user = rose-pine-toml.username.username.style_user;
          };

          time.disabled = mkForce true;
        }
       ];
      };

    };
}
