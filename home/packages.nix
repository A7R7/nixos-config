{ inputs, pkgs, pkgs-stable, nur, ... }:
{
  home.packages = (with pkgs; [
    neovide
    emacs29-pgtk
    marktext
    vscode
    libreoffice
    gcc
    ccache
    cmake
    (python311.withPackages(ps: with ps; [ 
      # required by lsp-bridge
      epc orjson sexpdata six paramiko rapidfuzz 
      python-pam
      numpy toolz 
    ]))
    octave
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
    rnix-lsp
    texlive.combined.scheme-full
    
    sqlite
    dbeaver
    kitty
    alacritty
    wezterm
    carapace
    starship
    
    thefuck
    bat
    eza
    ranger nnn
    fd
    ripgrep
    fzf
    socat
    jq
    yq-go
    acpi
    inotify-tools
    ffmpeg
    libnotify
    zoxide
    autoconf
    tree
    ghostscript
    
    hugo
    pipes-rs
    tty-clock
    cava
    cmatrix
    fastfetch  
    # daw
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
    tauon
    gimp-with-plugins
    inkscape
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    zathura   
    firefox
    chromium
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs = "--enable-wayland-ime";
    })
    qq
    discord
    telegram-desktop
    clash-verge
    prismlauncher
    glfw-wayland-minecraft
    zulu21
    steam-tui
    steamcmd
    steam
    gamescope
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
    
    eww-wayland # bar
    pango       # font renderer
    
    gnome.adwaita-icon-theme
    # bar and shell in gjs
    inputs.ags.packages.${system}.default 
    # hyprland plugin set in python
    inputs.pyprland.packages.${system}.default
    gnome.nautilus # gnome's file manager
    gparted        # disk partition manager
    fsearch        # search files in disk
    wl-gammactl
    wl-clipboard   # wayland clipboard
    wf-recorder
    wayshot
    swappy
    slurp
    imagemagick
    pavucontrol    # sound control
    brightnessctl  # brightness control     
  ]);
}
