# [[file:../nixos.org::*Config][Config:1]]
{ config, pkgs, inputs, ... }:
let
  username = "aaron-nix";
  homeDirectory = "/home/aaron-nix";
in
{
  imports = [
    ./packages.nix
  ];
  # [[file:nixos.org::*Config][]]
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "23.11";
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      SHELL = "${pkgs.zsh}/bin/elvish";
    };
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };
  programs.home-manager.enable = true;
  
  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };
  
  # ends here
  # [[file:nixos.org::*Config][]]
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
     commit-mono
     monaspace
     ibm-plex
  ];
  # ends here
  # [[file:nixos.org::*Config][]]
  gtk.enable = true;
  gtk.theme = {
    name = "fluent-gtk-theme";
    package = pkgs.fluent-gtk-theme.override {
      tweaks = [ "blur" ];
    };
  };
  gtk.cursorTheme = {
    name = "whitesur-cursors";
    package = pkgs.whitesur-cursors;
  };
  gtk.gtk3.bookmarks = [
    "file://${homeDirectory}/Documents"
    "file://${homeDirectory}/Music"
    "file://${homeDirectory}/Pictures"
    "file://${homeDirectory}/Videos"
    "file://${homeDirectory}/Downloads"
    "file://${homeDirectory}/Desktop"
    "file://${homeDirectory}/Projects"
    "file://${homeDirectory}/.config Config"
    "file://${homeDirectory}/.local/share Local"
  ];
  
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  # ends here
  # [[file:nixos.org::*Config][]]
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-pgtk;
  };
  # ends here
  # [[file:nixos.org::*Config][]]
  services.syncthing = {
    enable = true;
    tray = {enable = true;};
  };
  services.emacs.enable = true;
  # ends here
}
# Config:1 ends here
