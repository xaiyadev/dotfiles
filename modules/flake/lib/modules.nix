{ lib, inputs, }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) bool str int;

  # Simplified one lining mkOption
  # example: ``mkOpt str "" "Example Option"``
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  # Creating options for my services
  # Inspired from: isabelroses
  # example: ``mkServiceOpt "service" { port = 3000; host = "127.0.0.1"; domain = "xaiya.dev"; extraConfig = { //// }; }
  mkServiceOpt = 
    name:
    {
      port ? 0,
      host ? "[::1]",
      domain ? "xaiya.dev", # Change if new domains/other devices?
      extraConfig ? {}
    }: {
      enable = mkOpt bool false ''Enable the "${name}" service'';
      port = mkOpt int port ''On what port ${name} runs on'';
      host = mkOpt str host ''On what host ${name} runs on'';
      domain = mkOpt str domain ''What domain should be used for ${name}'';
    } // extraConfig ;

in
{
  inherit 
    mkOpt 
    mkServiceOpt
    ;
}
