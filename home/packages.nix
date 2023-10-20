{ pkgs, pkgs-stable, nur, ... }:
{

  home.packages = (with pkgs; [
    #guis
    libreoffice
    gimp-with-plugins
    inkscape

    neovide
    emacs29-pgtk
    zathura
    dbeaver

    qq

    prismlauncher
    glfw-wayland-minecraft
    openjdk19

    firefox
    chromium
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs =''
       --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime \\
       --proxy-server='https=127.0.0.1:7890;http=127.0.0.1:7890' \\
       %u
       '';
    })
    steam-tui
    steamcmd
    steam
    gamescope

    discord
    telegram-desktop

    logisim-evolution

    # terminals & tuis
    kitty
    alacritty
    wezterm

    # cmd tools
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
    autoconf
    tree

    carapace
    starship

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


    
    # gui-tools
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
    gcc
    ccache
    python311
    nodejs
    go
    bun
    sassc
    typescript
    meson
    ninja
    # eslint
    texlive.combined.scheme-full


    gnome.adwaita-icon-theme
  ]) ++ (with pkgs-stable; [
    clash-verge
  ]);
}
