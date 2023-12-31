# [[file:../nixos.org::*Config][Config:1]]
{ config, pkgs, inputs, ... }:
let
  username = "aaron";
  homeDirectory = "/home/aaron";
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
      LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
      # SHELL = "${pkgs.zsh}/bin/elvish";
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
      cudaSupport = true;
      cudaVersion = "12";
    };
  };
  
  # ends here
  # [[file:nixos.org::*Config][]]
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-rime
        fcitx5-lua
        fcitx5-chinese-addons
        librime
      ];
    };
  };
  # ends here
  # [[file:nixos.org::*Config][]]
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
     nerdfonts
     noto-fonts-monochrome-emoji
     noto-fonts-emoji
     noto-fonts-extra
     source-han-mono
     source-han-sans
     source-han-serif
     source-han-serif-vf-ttf
  
     commit-mono
     monaspace
     # mynur.symbols-nerd-font
     # mynur.ibm-plex-nerd-font
     ibm-plex
     mynur.sarasa-gothic-nerd-font
     fontforge-gtk
  ];
  # ends here
  # [[file:nixos.org::*Config][]]
  gtk.enable = true;
  # gtk.theme = {
  #   name = "Fluent";
  #   package = pkgs.fluent-gtk-theme.override {
  #     tweaks = [ "blur" ];
  #   };
  # };
  gtk.iconTheme = {
    name = "kora";
    package = pkgs.kora-icon-theme;
  };
  # gtk.cursorTheme = {
  #   package = pkgs.whitesur-cursors;
  #   name = "whitesur-cursors";
  #   size = 32;
  # };
  home.pointerCursor = {
    package = pkgs.whitesur-cursors;
    name = "WhiteSur-cursors";
    size = 32;
    x11.enable = true;
    gtk.enable = true;
  };
  xresources.properties = {
    "Xcursor.size" = 32;
    "Xft.dpi" = 172;
  };
  # ends here
  # [[file:nixos.org::*Config][]]
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
  
  # ends here
  # [[file:nixos.org::*Config][]]
  programs.bash = {
    enable = true; # this is needed for home.sessionVariables to work
  };
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
  services.blueman-applet.enable = true;
  # ends here
}
# Config:1 ends here
