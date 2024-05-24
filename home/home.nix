# [[file:../nixos.org::false;
#  settings = {
#  CPU_SCALING_GOVERNOR_ON_AC = "performance";
#  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

#  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
#  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

#  CPU_MIN_PERF_ON_AC = 0;
#  CPU_MAX_PERF_ON_AC = 100;
#  CPU_MIN_PERF_ON_BAT = 0;
#  CPU_MAX_PERF_ON_BAT = 20;

#  #Optional helps save long term battery health
#  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
#  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
#  };
# };
# #+end_src

# ** Security
# Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
# #+begin_src nix
# security.polkit.enable = true;
# # start polkit on login by creating a systemd user service
#  #+end_src
# * Home
# Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
# ** Config
# :PROPERTIES:
# :header-args:nix: :noweb-ref hm-config
# :END:][Config:1]]
{ config, pkgs, inputs, ... }:
let
  username = "aaron";
  homeDirectory = "/home/aaron";
in
{
  imports = [
    ./packages.nix
  ];
  # [[file:nixos.org::false;
  #  settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_BAT = 20;
  
  #  #Optional helps save long term battery health
  #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #  };
  # };
  # #+end_src
  
  # ** Security
  # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
  # #+begin_src nix
  # security.polkit.enable = true;
  # # start polkit on login by creating a systemd user service
  #  #+end_src
  # * Home
  # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
  # ** Config
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-config
  # :END:][]]
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "23.11";
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      # LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
      # SHELL = "${pkgs.zsh}/bin/elvish";
    };
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };
  programs.home-manager.enable = true;
  
  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
      cudaSupport = true;
      cudaVersion = "12";
    };
  };
  # ends here
  # [[file:nixos.org::false;
  #  settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_BAT = 20;
  
  #  #Optional helps save long term battery health
  #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #  };
  # };
  # #+end_src
  
  # ** Security
  # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
  # #+begin_src nix
  # security.polkit.enable = true;
  # # start polkit on login by creating a systemd user service
  #  #+end_src
  # * Home
  # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
  # ** Config
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-config
  # :END:][]]
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-rime
        fcitx5-lua
        fcitx5-chinese-addons
        librime
      ];
    };
  };
  # ends here
  # [[file:nixos.org::false;
  #  settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_BAT = 20;
  
  #  #Optional helps save long term battery health
  #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #  };
  # };
  # #+end_src
  
  # ** Security
  # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
  # #+begin_src nix
  # security.polkit.enable = true;
  # # start polkit on login by creating a systemd user service
  #  #+end_src
  # * Home
  # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
  # ** Config
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-config
  # :END:][]]
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
     (nerdfonts.override {
       fonts = [
         "CommitMono"
         "DroidSansMono"
         "FiraCode"
         "Hack"
         "IBMPlexMono"
         "Monaspace"
         "NerdFontsSymbolsOnly"
         "RobotoMono"
       ];})
     (google-fonts.override {
       fonts = [
         "Play"
       ];})
     symbola
     roboto roboto-serif
  
     noto-fonts-monochrome-emoji
     noto-fonts-emoji
     noto-fonts-extra
     source-han-mono
     source-han-sans
     source-han-serif
     source-han-serif-vf-ttf
  
     # commit-mono
     # monaspace
     # mynur.ibm-plex-nerd-font
     ibm-plex
  
     # corefonts
     # vistafonts
     mynur.sarasa-gothic-nerd-font
     fontforge-gtk
  
     lxgw-wenkai
     lxgw-neoxihei
     wqy_zenhei
     wqy_microhei
     jigmo
  
     lmmath
  ];
  # ends here
  # [[file:nixos.org::false;
  #  settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_BAT = 20;
  
  #  #Optional helps save long term battery health
  #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #  };
  # };
  # #+end_src
  
  # ** Security
  # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
  # #+begin_src nix
  # security.polkit.enable = true;
  # # start polkit on login by creating a systemd user service
  #  #+end_src
  # * Home
  # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
  # ** Config
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-config
  # :END:][]]
  gtk.enable = true;
  # gtk.theme = {
  #   name = "Fluent";
  #   package = pkgs.fluent-gtk-theme.override {
  #     tweaks = [ "blur" ];
  #   };
  # };
  gtk.iconTheme = {
    name = "kora";
    package = pkgs.kora-icon-theme;
  };
  # gtk.cursorTheme = {
  #   package = pkgs.whitesur-cursors;
  #   name = "whitesur-cursors";
  #   size = 32;
  # };
  home.pointerCursor = {
    package = pkgs.whitesur-cursors;
    name = "WhiteSur-cursors";
    size = 32;
    x11.enable = true;
    gtk.enable = true;
  };
  xresources.properties = {
    "Xcursor.size" = 32;
    "Xft.dpi" = 172;
  };
  # ends here
  # [[file:nixos.org::false;
  #  settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_BAT = 20;
  
  #  #Optional helps save long term battery health
  #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #  };
  # };
  # #+end_src
  
  # ** Security
  # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
  # #+begin_src nix
  # security.polkit.enable = true;
  # # start polkit on login by creating a systemd user service
  #  #+end_src
  # * Home
  # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
  # ** Config
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-config
  # :END:][]]
  gtk.gtk3.bookmarks = [
    "file://${homeDirectory}/Documents"
    "file://${homeDirectory}/Music"
    "file://${homeDirectory}/Pictures"
    "file://${homeDirectory}/Videos"
    "file://${homeDirectory}/Downloads"
    "file://${homeDirectory}/Desktop"
    "file://${homeDirectory}/Projects"
    "file://${homeDirectory}/.config Config"
    "file://${homeDirectory}/.local/share Local"
  ];
  
  # ends here
  # [[file:nixos.org::false;
  #  settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_BAT = 20;
  
  #  #Optional helps save long term battery health
  #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #  };
  # };
  # #+end_src
  
  # ** Security
  # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
  # #+begin_src nix
  # security.polkit.enable = true;
  # # start polkit on login by creating a systemd user service
  #  #+end_src
  # * Home
  # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
  # ** Config
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-config
  # :END:][]]
  programs.bash = {
    enable = true; # this is needed for home.sessionVariables to work
  };
  # ends here
  # [[file:nixos.org::false;
  #  settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_BAT = 20;
  
  #  #Optional helps save long term battery health
  #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #  };
  # };
  # #+end_src
  
  # ** Security
  # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
  # #+begin_src nix
  # security.polkit.enable = true;
  # # start polkit on login by creating a systemd user service
  #  #+end_src
  # * Home
  # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
  # ** Config
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-config
  # :END:][]]
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
  programs.obs-studio = {
    enable = false;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      # obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
  programs.emacs = {
    enable = true;
    # package = pkgs.mynur.emacs;
    package = pkgs.emacs29-pgtk;
  };
  # ends here
  # [[file:nixos.org::false;
  #  settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_BAT = 20;
  
  #  #Optional helps save long term battery health
  #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #  };
  # };
  # #+end_src
  
  # ** Security
  # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
  # #+begin_src nix
  # security.polkit.enable = true;
  # # start polkit on login by creating a systemd user service
  #  #+end_src
  # * Home
  # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
  # ** Config
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-config
  # :END:][]]
  services.syncthing = {
    enable = true;
    tray = {enable = true;};
  };
  services.emacs.enable = true;
  services.blueman-applet.enable = true;
  # ends here
}
# Config:1 ends here
