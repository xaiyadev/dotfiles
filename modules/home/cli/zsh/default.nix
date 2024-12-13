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

        # Load all atributes that I need from rose-pine
        (attrsets.genAttrs [ "git_status" "directory" "git_branch" "username" "fill" ] 
          (attr: attrsets.attrByPath [ attr ] null rose-pine-toml ))
       
        # Load my own modules/changed things from rose-pine
        {
          # Load Characters
          character = {
            success_symbol = "[➜](pine)";
            error_symbol = "[✗](love) ";
          };

          # Hostname/SSH names
          hostname = {
            ssh_only = false;
            ssh_symbol = "";

            format = "[@ $hostname]($style)";
            style = "bg:overlay fg:pine";
          };

          direnv = {
            disabled = false;

            symbol = "󱂸 ";
            allowed_msg = "󰄬";
            not_allowed_msg = "";
            
            format = "[](fg:overlay)[$symbol $allowed]($style)[](fg:overlay) ";
            style = "bg:overlay fg:gold";

          };

          cmd_duration = {
            disabled = false;

            format = "took [$duration]($style)";
            style = "fg:gold";
          };

          # nix-shells
          nix_shell = {
            impure_msg = "󰼩 ";
            pure_msg = "󱩰 ";

            format = "[](fg:overlay)[$state( \($name\))]($style)[](fg:overlay) ";
            style = "bg:overlay fg:foam";
          };

          # Show the current OS the shell is runing on 
          os = {
            disabled = false;
            format = "[ $symbol]($style)";

          };

          jobs = {
            symbol = " 󰀿 ";
            format = "[$symbol$number]($style)";
            style = "fg:rose";
          };

          # Overriding attributes from rose-pine modules
          git_branch.symbol = mkForce ""; # use an updated git_branch icon 
          directory.format = mkForce "[ : $path ]($style)[ ](fg:overlay)";

          username = {
            format = mkForce "[ ](fg:overlay)[  $user ]($style)";
            style_root = mkForce "bg:overlay fg:love"; # Change root colors to be red
          };
        }

       ];
      };

    };
}
