{ channels, ...  }:

final: prev: {
    enpass = prev.enpass.override { extraPkgs = pkgs: [ pkgs.qt6.qtwayland ]; };
}