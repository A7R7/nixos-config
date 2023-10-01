{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #guis
    libreoffice
    gimp-with-plugins
    inkscape

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
    steam-tui
    steamcmd
    steam

    # clash-verge

    # terminals & tuis
    kitty
    alacritty
    wezterm

    # tools
    fastfetch
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

    # hyprland
    hyprpaper
    hyprpicker
    wlogout
    rofi-wayland-unwrapped

    # eww
    eww-wayland
    gtk3
    gtk-layer-shell
    pango
    gdk-pixbuf
    cairo
    glib
    libgcc
    glibc


    # fonts
    fira-code
    fira-code-symbols
    roboto
    nerdfonts
    sarasa-gothic 
    
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
    yq-go
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
}
