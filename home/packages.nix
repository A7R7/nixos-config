{ inputs, pkgs, ... }:
{
  home.packages = (with pkgs; [
    helix
    lapce  # a rust powered editor
    libreoffice
    wpsoffice
    neovide
    marktext
    # nur.repos.lschuermann.vivado-2020_1
    gcc ccache cmake clang-tools bear
    (python311.withPackages(ps: with ps; [
      # pytorch-bin torchvision-bin
      #(torchvision.override {torch = pytorch-bin; })
      # required by lsp-bridge, holo-layer, and blink search
      epc orjson sexpdata six paramiko rapidfuzz
      pynput inflect pyqt6 pyqt6-sip
      python-pam requests
      numpy pandas toolz
      scipy cython
      # pyperclip
      pillow
      # imageio imageio-ffmpeg
      # grad-cam
      # opencv4
      # onnxruntime
      jupyter ipython matplotlib
      # pip pipdeptree
      # mynur.pix2tex
      # mynur.pix2text
      nvidia-ml-py
    ]))
    
    poetry
    # octave
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
    texliveFull
    pyright
    javascript-typescript-langserver
    rust-analyzer
    mynur.jdtls
    sqlite
    dbeaver
    niv
    nix-universal-prefetch
    inputs.pip2nix.defaultPackage.${system}
    nix-your-shell
    nix-output-monitor
    doxygen
    doxygen_gui
    mynur.logisim-ita
    uncrustify
    gtk-engine-murrine
    gnome-themes-extra
    mynur.tdlib # for building telegrame clients
    kitty
    alacritty
    wezterm
    blackbox-terminal
    gitstatus # 10x faster than git status
    gitoxide  # rust git client
    carapace
    starship
    lf
    thefuck   #
    bat       # rust cat
    eza       # rust ls
    ranger nnn # cmdline file explorer
    joshuto   # rust ranger
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
    zinit
    just
    # ueberzugpp # allow showing child window in terminal
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
    # gimp-with-plugins
    inkscape
    imagemagick    # editing and manipulating digital images
    # kdenlive
    vlc
    zathura
    firefox
    floorp
    chromium
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    #   commandLineArgs = "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime";
    })
    # vivaldi
    (mynur.thorium-browser.override {
      commandLineArgs = "--enable-features=WaylandWindowDecorations --gtk-version=4";
    })
    qq
    discord
    telegram-desktop
    element-desktop
    thunderbird
    weechat # IRC
    nur.repos.linyinfeng.wemeet
    # nur.repos.xddxdd.dingtalk
    mynur.clash-verge-rev
    # nur.repos.xddxdd.baidunetdisk
    prismlauncher
    glfw-wayland-minecraft
    zulu21
    steam-tui
    steamcmd
    steam
    gamescope
    kanshi         # manage monitor position on wayland
    wlsunset       # screen color temperature mnger
    swayidle       # idle mnger
    # swaylock       # lock mnger
    wlogout        # logout mnger
    swaynotificationcenter # not only show notifications but also have a drawer
    rofi-wayland-unwrapped # app launcher
    inputs.anyrun.packages.${system}.anyrun-with-all-plugins # app launcher
    
    eww            # bar
    waybar         # bar
    
    pavucontrol    # sound control
    brightnessctl  # brightness control
    grim           # wl raw screenshot
    grimblast      # wrapper around grim
    slurp          # reigon selection (outputs reigon coordinates)
    swappy         # Wayland native snapshot editing tool
    wf-recorder    # screen recording tool
    
    hyprpaper      # hyprland wallpaper utility
    swww           # dynamic wallpaper
    wl-clipboard-rs # wayland clipboard
    # gnome stuffs
    gnome.nautilus # gnome's file manager
    gnome.gnome-tweaks # gnome's file manager
    gnome.gnome-characters
    gnome-themes-extra
    gtk-engine-murrine
    cinnamon.nemo  # cinnamon's file manager
    doublecmd
    peazip         # achiever
    nsxiv          # the best image viewer
    
    gnome.adwaita-icon-theme
    
    # hyprkeys       # keybind retrieval utility
    # hyprnome       # gnome like workspace switch
    
    # hyprshade      # screen color filters
    # wl-gammactl    # set contrast, brightness and gamma on wl
    
    v2311.hyprpicker     # wlroots color picker
    wayshot        # screenshots tool
    
    
    # bar and shell in gjs
    inputs.ags.packages.${system}.default
    
    # hyprland plugin set in python
    inputs.pyprland.packages.${system}.default
    gparted        # disk partition manager
    fsearch        # search files in disk
    lshw
    solaar         # connect with logitech devices
    iotop
    btop
    logiops        # Unofficial userspace driver for HID++ Logitech devices
    powertop       # Analyze power consumption on Intel-based laptops
    mission-center
    filelight      # inspecting disk usage statistics
    xorg.xhost          # launch gui with sudo in cmdline
    networkmanagerapplet # network manager, gtk frontend
    wlr-randr      # wlroots screen manager
  ]);
}
