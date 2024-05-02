{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ./clone-vault.nix {}