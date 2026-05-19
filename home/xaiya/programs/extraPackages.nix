{ pkgs, ... }: {
  sylveon.packages = {
      inherit (pkgs.jetbrains) webstorm;
  };
}