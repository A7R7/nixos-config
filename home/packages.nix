{ inputs, pkgs, pkgs-stable, nur, ... }:
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
    gparted
    fsearch
    obs-studio

    qq

    prismlauncher
    glfw-wayland-minecraft
    zulu21

    # audio production
    ardour
    # synthesizer-plugin
    zyn-fusion
    surge
    geonkick
    # sampler
    avldrums-lv2
    drumkv1
    drumgizmo
    # effect processor
    calf
    lsp-plugins
    


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

    # terminals & tuis
    kitty
    alacritty
    wezterm

    # cmd tools
    fastfetch
    thefuck
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
    ghostscript

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

    inputs.ags.packages.${system}.default

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
    python311Packages.epc
    python311Packages.orjson
    python311Packages.sexpdata
    python311Packages.six
    python311Packages.paramiko
    python311Packages.rapidfuzz
    python311Packages.python-pam
    sqlite
    nodejs
    go
    bun
    sassc
    typescript
    meson
    ninja
    # eslint
    maven
    texlive.combined.scheme-full


    gnome.adwaita-icon-theme
  ]) ++ 
  (with pkgs-stable; [
    clash-verge
  ])
  ;
}
