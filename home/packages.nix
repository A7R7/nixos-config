{ inputs, pkgs, pkgs-stable, nur, ... }:
{
  home.packages = (with pkgs; [
    neovide
    emacs29-pgtk
    marktext
    libreoffice
    gcc ccache cmake clang-tools
    (python311.withPackages(ps: with ps; [ 
      # required by lsp-bridge, holo-layer, and blink search
      epc orjson sexpdata six paramiko rapidfuzz 
      pynput inflect pyqt6 pyqt6-sip
      python-pam requests
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
    rnix-lsp # WIP Language Server for Nix
    texlive.combined.scheme-full
    
    sqlite
    dbeaver
    doxygen
    doxygen_gui  
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
    _7zz
    lazygit
    hugo
    pipes-rs
    tty-clock
    cava
    cmatrix
    fastfetch
    uniscribe # describe unicodes
    unipicker # pick unicodes
    nerdfix # find nerd font icons  
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
    tidal-dl
    gimp-with-plugins
    inkscape
    imagemagick    # editing and manipulating digital images
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
    nsxiv          # the best image viewer
    gnome.nautilus # gnome's file manager
    gnome.gnome-tweaks # gnome's file manager
    gnome.gnome-characters
    cinnamon.nemo  # cinnamon's file manager
    
    hyprpaper      # wallpaper utility
    swww           # dynamic wallpaper
    gnome.adwaita-icon-theme
    
    hyprkeys       # keybind retrieval utility
    hyprnome       # gnome like workspace switch
    
    hyprshade      # screen color filters
    wl-gammactl    # set contrast, brightness and gamma on wl
    
    hyprpicker     # wlroots color picker
    wayshot        # screenshots tool
    grimblast      # screenshots tool
    wf-recorder    # screen recording tool
    swappy         # Wayland native snapshot editing tool
    
    wl-clipboard   # wayland clipboard
    
    wlogout        # logout gui
    rofi-wayland-unwrapped # app launcher
    pavucontrol    # sound control
    brightnessctl  # brightness control
    
    eww-wayland    # bar
    
    # bar and shell in gjs
    inputs.ags.packages.${system}.default 
    
    # hyprland plugin set in python
    inputs.pyprland.packages.${system}.default
    gparted        # disk partition manager
    fsearch        # search files in disk
    lshw     
  ]);
}
