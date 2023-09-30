{ config, pkgs, ... }:

{

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

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home.packages = with pkgs; [
    neofetch
    yq-go

    kitty
    alacritty

    # clash-verge
    # hyprland stuffs
    hyprpaper
    hyprpicker
    wlogout
    rofi-wayland-unwrapped

    neovide
    emacs29-pgtk

    firefox
    chromium
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs =
       "--proxy-server='https=127.0.0.1:7890;http=127.0.0.1:7890'";
    })
    widevine-cdm
    vivaldi-ffmpeg-codecs

    steam-tui
    steamcmd
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
    
    # tools
    bat
    eza
    ranger nnn
    fd
    ripgrep
    fzf
    socat
    jq
    acpi
    inotify-tools
    ffmpeg
    libnotify
    zoxide

    # tools
    wl-gammactl
    wl-clipboard
    wf-recorder
    hyprpicker
    wayshot
    swappy
    slurp
    imagemagick
    pavucontrol
    brightnessctl
    swww


    # langs
    nodejs
    go
    bun
    sassc
    typescript
    meson
    ninja
    # eslint
  ];

#  programs.clash-verge = {
#    enable = true;
#  };

}
