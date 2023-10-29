# [[file:../nixos.org::*Home-manager config][Home-manager config:1]]
{ config, pkgs, pkgs-stable, inputs, ... }:

{
  imports = [
    ./packages.nix
  ];

  home = {
    username = "aaron-nix";
    homeDirectory = "/home/aaron-nix";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  programs.git = {
    enable = true;
    userName = "a7r7";
    userEmail = "Aaron__Lee_@outlook.com";
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };    
#  wayland.windowManager.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#    extraConfig = ''
#      source=~/.config/hypr/main.conf
#    '';
#    #package = (inputs.hyprland.packages.${pkgs.system}.hyprland.override {
#    #  enableXWayland = true;
#    #  enableNvidiaPatches = false;
#    #});
#  };
}
# Home-manager config:1 ends here
