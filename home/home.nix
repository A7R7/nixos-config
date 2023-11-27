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

  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "23.05";
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      SHELL = "${pkgs.zsh}/bin/elvish";
    };
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };


  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  gtk.enable = true;
  gtk.theme = {
    name = "Fluent-gtk-theme";
    package = pkgs.fluent-gtk-theme.override {
      tweaks = [ "blur" ];
    };
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

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "a7r7";
    userEmail = "Aaron__Lee_@outlook.com";
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
  services.syncthing = {
    enable = true;
    tray = {enable = true;};
  };
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    socketActivation.enable = true;
    client = {
      enable = true;
    };
  };

}
# Config:1 ends here
