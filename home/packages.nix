{ inputs, pkgs, pkgs-stable, nur, ... }:
{
  home.packages = (with pkgs; [
    emacs29-pgtk
    neovide
    marktext
    libreoffice
    gcc ccache cmake clang-tools
    (python311.withPackages(ps: with ps; [
      # required by lsp-bridge, holo-layer, and blink search
    
      epc orjson sexpdata six paramiko rapidfuzz
      pynput inflect pyqt6 pyqt6-sip
      python-pam requests
      numpy toolz
      pyperclip
      mynur.pix2text pillow pytorch torchvision opencv
      # the unusable package manager
      pip pipdeptree
    ]))
    poetry
    
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
    
    pyright
    javascript-typescript-langserver
    sqlite
    dbeaver
    niv
    nix-universal-prefetch
    inputs.pip2nix.defaultPackage.${system}
    doxygen
    doxygen_gui
    mynur.logisim-ita
    kitty
    alacritty
    wezterm
    carapace
    starship
    lf
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
    pandoc
    gh
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
    kdenlive
    vlc
    zathura
    firefox
    chromium
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs = "--enable-wayland-ime";
    })
    mynur.thorium-browser
    qq
    discord
    telegram-desktop
    thunderbird
    pkgs-stable.clash-verge
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
    gtk-engine-murrine
    gnome-themes-extra
    cinnamon.nemo  # cinnamon's file manager
    doublecmd
    peazip
    
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
    fontforge-gtk
    mynur.sarasa-gothic-nerd-font
    gparted        # disk partition manager
    fsearch        # search files in disk
    lshw
    solaar         # connect with logitech devices
    iotop
    btop
    logiops        # Unofficial userspace driver for HID++ Logitech devices
  ]);
}
