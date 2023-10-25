{ inputs, pkgs, pkgs-stable, nur, ... }:
{

  home.packages = (with pkgs; [
    #guis
    libreoffice
    gimp-with-plugins
    inkscape
    gnome.nautilus

    neovide
    emacs29-pgtk
    marktext
    vscode

    zathura
    dbeaver
    gparted
    fsearch
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    tauon

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
    distrho
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
      commandLineArgs = "--enable-wayland-ime";
    })
    steam-tui
    steamcmd
    steam
    gamescope

    discord
    telegram-desktop

    piper

    # terminals & tuis
    kitty
    alacritty
    wezterm
    
    # cmd toys
    pipes-rs
    tty-clock
    cava
    cmatrix

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
    
    hugo

    carapace
    starship

    # hyprland
    hyprpaper  # wallpaper utility
    swww       # dynamic wallpaper
    hyprkeys   # keybind retrieval utility
    hyprnome   # gnome like workspace switch
    hyprshade  # screen color filters
    hyprpicker # wlroots color picker
    grimblast  # screenshots
    wlogout    # logout gui
    rofi-wayland-unwrapped # app launcher


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
    inputs.pyprland.packages.${system}.default

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


    # langs
    gcc
    ccache
    cmake
    (python311.withPackages(ps: with ps; [ 
      epc orjson sexpdata six paramiko rapidfuzz # required by lsp-bridge
      python-pam
      numpy toolz 
    ]))
    octave
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
    pkg-config

    texlive.combined.scheme-full


    gnome.adwaita-icon-theme
  ]) ++ 
  (with pkgs-stable; [
    clash-verge
  ])
  ;
}
