{ config, pkgs, ... }:

{
  home = {
    username = "aaron-nix";
    homeDirectory = "/home/aaron-nix";
  };

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

  programs.emacs29-pgtk = {
    enable = true;
  }


  home.packages = with pkgs; [
    neofetch
    ranger
    nnn
    ripgrep
    jq
    yq-go
    eza
    fzf

    kitty
    alacritty

    clash-verge
    hyprpaper
    hyprpicker
    wlogout
    rofi-wayland-unwrapped
    neovide

    firefox
    # vivaldi
    steam

    eww-wayland
    gtk3
    gtk-layer-shell
    pango
    gdk-pixbuf
    cairo
    glib
    libgcc
    glibc


    cliphist
    wl-clipboard

    fira-code
    fira-code-symbols
    roboto
    nerdfonts
    sarasa-gothic

    meson

    stdenv
  ];

#  programs.clash-verge = {
#    enable = true;
#  };

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
}
