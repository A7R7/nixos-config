{ pkgs ? import <nixpkgs> { } }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs);
in rec { 
  vscode-custom = callPackage ./vscode-custom {};
}
