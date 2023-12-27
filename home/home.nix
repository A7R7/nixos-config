# [[file:../nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
# { config, pkgs, inputs, ... }:
# let
#  username = "aaron";
#  homeDirectory = "/home/aaron";
# in
# {
#  imports = \[
#  ./packages.nix
#  \];
#  <<hm-config>>
# }
# #+end_src
# *** Home
# #+begin_src nix
# home = {
#  username = username;
#  homeDirectory = homeDirectory;
#  stateVersion = "23.11";
#  sessionVariables = {
#  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
#  NIXPKGS_ALLOW_UNFREE = "1";
#  LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
#  # SHELL = "${pkgs.zsh}/bin/elvish";
#  };
#  sessionPath = \[
#  "$HOME/.local/bin"
#  \];
# };
# programs.home-manager.enable = true;

# nixpkgs = {
#  config = {
#  allowUnfree = true;
#  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
#  allowUnfreePredicate = (_: true);
#  cudaSupport = true;
#  cudaVersion = "12";
#  };
# };

# #+end_src

# #+RESULTS:

# *** Input method
#  #+begin_src nix
#  i18n.inputMethod = {
#  enabled = "fcitx5";
#  fcitx5 = {
#  addons = with pkgs; \[
#  fcitx5-gtk
#  fcitx5-rime
#  fcitx5-lua
#  fcitx5-chinese-addons
#  librime
#  \];
#  };
#  };
# #+end_src
# *** Font
# #+begin_src nix
# fonts.fontconfig.enable = true;
# home.packages = with pkgs; \[
#  nerdfonts
#  noto-fonts-monochrome-emoji
#  noto-fonts-emoji
#  noto-fonts-extra
#  source-han-mono
#  source-han-sans
#  source-han-serif
#  source-han-serif-vf-ttf

#  commit-mono
#  monaspace
#  # mynur.symbols-nerd-font
#  # mynur.ibm-plex-nerd-font
#  ibm-plex
#  mynur.sarasa-gothic-nerd-font
#  fontforge-gtk
# \];
# #+end_src

# #+RESULTS:

# *** GTK
# #+begin_src nix
# gtk.enable = true;
# # gtk.theme = {
# # name = "Fluent";
# # package = pkgs.fluent-gtk-theme.override {
# # tweaks = \[ "blur" \];
# # };
# # };
# gtk.iconTheme = {
#  name = "kora";
#  package = pkgs.kora-icon-theme;
# };
# # gtk.cursorTheme = {
# # package = pkgs.whitesur-cursors;
# # name = "whitesur-cursors";
# # size = 32;
# # };
# home.pointerCursor = {
#  package = pkgs.whitesur-cursors;
#  name = "WhiteSur-cursors";
#  size = 32;
#  x11.enable = true;
#  gtk.enable = true;
# };
# xresources.properties = {
#  "Xcursor.size" = 32;
#  "Xft.dpi" = 172;
# };
# #+end_src

# #+begin_src nix
# gtk.gtk3.bookmarks = \[
#  "file:/${homeDirectory}/Documents"
#  "file:/${homeDirectory}/Music"
#  "file:/${homeDirectory}/Pictures"
#  "file:/${homeDirectory}/Videos"
#  "file:/${homeDirectory}/Downloads"
#  "file:/${homeDirectory}/Desktop"
#  "file:/${homeDirectory}/Projects"
#  "file:/${homeDirectory}/.config Config"
#  "file:/${homeDirectory}/.local/share Local"
# \];

# #+end_src

# #+RESULTS:

# *** Programs
# #+begin_src nix
# programs.bash = {
#  enable = true; # this is needed for home.sessionVariables to work
# };
# programs.vscode = {
#  enable = true;
#  package = pkgs.vscode.fhs;
# };
# programs.emacs = {
#  enable = true;
#  package = pkgs.emacs-unstable-pgtk;
# };
# #+end_src

# #+RESULTS:

# *** Services
# #+begin_src nix
# services.syncthing = {
#  enable = true;
#  tray = {enable = true;};
# };
# services.emacs.enable = true;
# services.blueman-applet.enable = true;
# #+end_src
# ** Packages
# :PROPERTIES:
# :header-args:nix: :noweb-ref hm-packages
# :END:
# #+begin_src nix :tangle home/packages.nix :noweb no-export :noweb-ref no
#  { inputs, pkgs, ... }:
#  {
#  home.packages = (with pkgs; \[
#  <<hm-packages>>
#  \]);
#  }
# #+end_src

# *** Development
# **** Text-editor
# #+begin_src nix
# helix
# lapce # a rust powered editor
# libreoffice
# neovide
# marktext
# #+end_src

# **** Languages
# These tools can be seen as runtimes, for non serious usage and quick testing.
# To seriously do development on nixos I have to write derivations.
# #+begin_src nix
#  gcc ccache cmake clang-tools bear
#  (python311.withPackages(ps: with ps; \[
#  # required by lsp-bridge, holo-layer, and blink search
#  epc orjson sexpdata six paramiko rapidfuzz
#  pynput inflect pyqt6 pyqt6-sip
#  python-pam requests
#  numpy pandas toolz
#  # pyperclip
#  pillow
#  # grad-cam
#  # pytorchWithCuda
#  pytorch][Config:1]]
{ config, pkgs, inputs, ... }:
let
  username = "aaron";
  homeDirectory = "/home/aaron";
in
{
  imports = [
    ./packages.nix
  ];
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron";
  #  homeDirectory = "/home/aaron";
  # in
  # {
  #  imports = \[
  #  ./packages.nix
  #  \];
  #  <<hm-config>>
  # }
  # #+end_src
  # *** Home
  # #+begin_src nix
  # home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  # };
  # programs.home-manager.enable = true;
  
  # nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
  #  cudaSupport = true;
  #  cudaVersion = "12";
  #  };
  # };
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Input method
  #  #+begin_src nix
  #  i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5 = {
  #  addons = with pkgs; \[
  #  fcitx5-gtk
  #  fcitx5-rime
  #  fcitx5-lua
  #  fcitx5-chinese-addons
  #  librime
  #  \];
  #  };
  #  };
  # #+end_src
  # *** Font
  # #+begin_src nix
  # fonts.fontconfig.enable = true;
  # home.packages = with pkgs; \[
  #  nerdfonts
  #  noto-fonts-monochrome-emoji
  #  noto-fonts-emoji
  #  noto-fonts-extra
  #  source-han-mono
  #  source-han-sans
  #  source-han-serif
  #  source-han-serif-vf-ttf
  
  #  commit-mono
  #  monaspace
  #  # mynur.symbols-nerd-font
  #  # mynur.ibm-plex-nerd-font
  #  ibm-plex
  #  mynur.sarasa-gothic-nerd-font
  #  fontforge-gtk
  # \];
  # #+end_src
  
  # #+RESULTS:
  
  # *** GTK
  # #+begin_src nix
  # gtk.enable = true;
  # # gtk.theme = {
  # # name = "Fluent";
  # # package = pkgs.fluent-gtk-theme.override {
  # # tweaks = \[ "blur" \];
  # # };
  # # };
  # gtk.iconTheme = {
  #  name = "kora";
  #  package = pkgs.kora-icon-theme;
  # };
  # # gtk.cursorTheme = {
  # # package = pkgs.whitesur-cursors;
  # # name = "whitesur-cursors";
  # # size = 32;
  # # };
  # home.pointerCursor = {
  #  package = pkgs.whitesur-cursors;
  #  name = "WhiteSur-cursors";
  #  size = 32;
  #  x11.enable = true;
  #  gtk.enable = true;
  # };
  # xresources.properties = {
  #  "Xcursor.size" = 32;
  #  "Xft.dpi" = 172;
  # };
  # #+end_src
  
  # #+begin_src nix
  # gtk.gtk3.bookmarks = \[
  #  "file:/${homeDirectory}/Documents"
  #  "file:/${homeDirectory}/Music"
  #  "file:/${homeDirectory}/Pictures"
  #  "file:/${homeDirectory}/Videos"
  #  "file:/${homeDirectory}/Downloads"
  #  "file:/${homeDirectory}/Desktop"
  #  "file:/${homeDirectory}/Projects"
  #  "file:/${homeDirectory}/.config Config"
  #  "file:/${homeDirectory}/.local/share Local"
  # \];
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Programs
  # #+begin_src nix
  # programs.bash = {
  #  enable = true; # this is needed for home.sessionVariables to work
  # };
  # programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode.fhs;
  # };
  # programs.emacs = {
  #  enable = true;
  #  package = pkgs.emacs-unstable-pgtk;
  # };
  # #+end_src
  
  # #+RESULTS:
  
  # *** Services
  # #+begin_src nix
  # services.syncthing = {
  #  enable = true;
  #  tray = {enable = true;};
  # };
  # services.emacs.enable = true;
  # services.blueman-applet.enable = true;
  # #+end_src
  # ** Packages
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-packages
  # :END:
  # #+begin_src nix :tangle home/packages.nix :noweb no-export :noweb-ref no
  #  { inputs, pkgs, ... }:
  #  {
  #  home.packages = (with pkgs; \[
  #  <<hm-packages>>
  #  \]);
  #  }
  # #+end_src
  
  # *** Development
  # **** Text-editor
  # #+begin_src nix
  # helix
  # lapce # a rust powered editor
  # libreoffice
  # neovide
  # marktext
  # #+end_src
  
  # **** Languages
  # These tools can be seen as runtimes, for non serious usage and quick testing.
  # To seriously do development on nixos I have to write derivations.
  # #+begin_src nix
  #  gcc ccache cmake clang-tools bear
  #  (python311.withPackages(ps: with ps; \[
  #  # required by lsp-bridge, holo-layer, and blink search
  #  epc orjson sexpdata six paramiko rapidfuzz
  #  pynput inflect pyqt6 pyqt6-sip
  #  python-pam requests
  #  numpy pandas toolz
  #  # pyperclip
  #  pillow
  #  # grad-cam
  #  # pytorchWithCuda
  #  pytorch][]]
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "23.11";
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
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
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron";
  #  homeDirectory = "/home/aaron";
  # in
  # {
  #  imports = \[
  #  ./packages.nix
  #  \];
  #  <<hm-config>>
  # }
  # #+end_src
  # *** Home
  # #+begin_src nix
  # home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  # };
  # programs.home-manager.enable = true;
  
  # nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
  #  cudaSupport = true;
  #  cudaVersion = "12";
  #  };
  # };
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Input method
  #  #+begin_src nix
  #  i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5 = {
  #  addons = with pkgs; \[
  #  fcitx5-gtk
  #  fcitx5-rime
  #  fcitx5-lua
  #  fcitx5-chinese-addons
  #  librime
  #  \];
  #  };
  #  };
  # #+end_src
  # *** Font
  # #+begin_src nix
  # fonts.fontconfig.enable = true;
  # home.packages = with pkgs; \[
  #  nerdfonts
  #  noto-fonts-monochrome-emoji
  #  noto-fonts-emoji
  #  noto-fonts-extra
  #  source-han-mono
  #  source-han-sans
  #  source-han-serif
  #  source-han-serif-vf-ttf
  
  #  commit-mono
  #  monaspace
  #  # mynur.symbols-nerd-font
  #  # mynur.ibm-plex-nerd-font
  #  ibm-plex
  #  mynur.sarasa-gothic-nerd-font
  #  fontforge-gtk
  # \];
  # #+end_src
  
  # #+RESULTS:
  
  # *** GTK
  # #+begin_src nix
  # gtk.enable = true;
  # # gtk.theme = {
  # # name = "Fluent";
  # # package = pkgs.fluent-gtk-theme.override {
  # # tweaks = \[ "blur" \];
  # # };
  # # };
  # gtk.iconTheme = {
  #  name = "kora";
  #  package = pkgs.kora-icon-theme;
  # };
  # # gtk.cursorTheme = {
  # # package = pkgs.whitesur-cursors;
  # # name = "whitesur-cursors";
  # # size = 32;
  # # };
  # home.pointerCursor = {
  #  package = pkgs.whitesur-cursors;
  #  name = "WhiteSur-cursors";
  #  size = 32;
  #  x11.enable = true;
  #  gtk.enable = true;
  # };
  # xresources.properties = {
  #  "Xcursor.size" = 32;
  #  "Xft.dpi" = 172;
  # };
  # #+end_src
  
  # #+begin_src nix
  # gtk.gtk3.bookmarks = \[
  #  "file:/${homeDirectory}/Documents"
  #  "file:/${homeDirectory}/Music"
  #  "file:/${homeDirectory}/Pictures"
  #  "file:/${homeDirectory}/Videos"
  #  "file:/${homeDirectory}/Downloads"
  #  "file:/${homeDirectory}/Desktop"
  #  "file:/${homeDirectory}/Projects"
  #  "file:/${homeDirectory}/.config Config"
  #  "file:/${homeDirectory}/.local/share Local"
  # \];
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Programs
  # #+begin_src nix
  # programs.bash = {
  #  enable = true; # this is needed for home.sessionVariables to work
  # };
  # programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode.fhs;
  # };
  # programs.emacs = {
  #  enable = true;
  #  package = pkgs.emacs-unstable-pgtk;
  # };
  # #+end_src
  
  # #+RESULTS:
  
  # *** Services
  # #+begin_src nix
  # services.syncthing = {
  #  enable = true;
  #  tray = {enable = true;};
  # };
  # services.emacs.enable = true;
  # services.blueman-applet.enable = true;
  # #+end_src
  # ** Packages
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-packages
  # :END:
  # #+begin_src nix :tangle home/packages.nix :noweb no-export :noweb-ref no
  #  { inputs, pkgs, ... }:
  #  {
  #  home.packages = (with pkgs; \[
  #  <<hm-packages>>
  #  \]);
  #  }
  # #+end_src
  
  # *** Development
  # **** Text-editor
  # #+begin_src nix
  # helix
  # lapce # a rust powered editor
  # libreoffice
  # neovide
  # marktext
  # #+end_src
  
  # **** Languages
  # These tools can be seen as runtimes, for non serious usage and quick testing.
  # To seriously do development on nixos I have to write derivations.
  # #+begin_src nix
  #  gcc ccache cmake clang-tools bear
  #  (python311.withPackages(ps: with ps; \[
  #  # required by lsp-bridge, holo-layer, and blink search
  #  epc orjson sexpdata six paramiko rapidfuzz
  #  pynput inflect pyqt6 pyqt6-sip
  #  python-pam requests
  #  numpy pandas toolz
  #  # pyperclip
  #  pillow
  #  # grad-cam
  #  # pytorchWithCuda
  #  pytorch][]]
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
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron";
  #  homeDirectory = "/home/aaron";
  # in
  # {
  #  imports = \[
  #  ./packages.nix
  #  \];
  #  <<hm-config>>
  # }
  # #+end_src
  # *** Home
  # #+begin_src nix
  # home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  # };
  # programs.home-manager.enable = true;
  
  # nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
  #  cudaSupport = true;
  #  cudaVersion = "12";
  #  };
  # };
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Input method
  #  #+begin_src nix
  #  i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5 = {
  #  addons = with pkgs; \[
  #  fcitx5-gtk
  #  fcitx5-rime
  #  fcitx5-lua
  #  fcitx5-chinese-addons
  #  librime
  #  \];
  #  };
  #  };
  # #+end_src
  # *** Font
  # #+begin_src nix
  # fonts.fontconfig.enable = true;
  # home.packages = with pkgs; \[
  #  nerdfonts
  #  noto-fonts-monochrome-emoji
  #  noto-fonts-emoji
  #  noto-fonts-extra
  #  source-han-mono
  #  source-han-sans
  #  source-han-serif
  #  source-han-serif-vf-ttf
  
  #  commit-mono
  #  monaspace
  #  # mynur.symbols-nerd-font
  #  # mynur.ibm-plex-nerd-font
  #  ibm-plex
  #  mynur.sarasa-gothic-nerd-font
  #  fontforge-gtk
  # \];
  # #+end_src
  
  # #+RESULTS:
  
  # *** GTK
  # #+begin_src nix
  # gtk.enable = true;
  # # gtk.theme = {
  # # name = "Fluent";
  # # package = pkgs.fluent-gtk-theme.override {
  # # tweaks = \[ "blur" \];
  # # };
  # # };
  # gtk.iconTheme = {
  #  name = "kora";
  #  package = pkgs.kora-icon-theme;
  # };
  # # gtk.cursorTheme = {
  # # package = pkgs.whitesur-cursors;
  # # name = "whitesur-cursors";
  # # size = 32;
  # # };
  # home.pointerCursor = {
  #  package = pkgs.whitesur-cursors;
  #  name = "WhiteSur-cursors";
  #  size = 32;
  #  x11.enable = true;
  #  gtk.enable = true;
  # };
  # xresources.properties = {
  #  "Xcursor.size" = 32;
  #  "Xft.dpi" = 172;
  # };
  # #+end_src
  
  # #+begin_src nix
  # gtk.gtk3.bookmarks = \[
  #  "file:/${homeDirectory}/Documents"
  #  "file:/${homeDirectory}/Music"
  #  "file:/${homeDirectory}/Pictures"
  #  "file:/${homeDirectory}/Videos"
  #  "file:/${homeDirectory}/Downloads"
  #  "file:/${homeDirectory}/Desktop"
  #  "file:/${homeDirectory}/Projects"
  #  "file:/${homeDirectory}/.config Config"
  #  "file:/${homeDirectory}/.local/share Local"
  # \];
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Programs
  # #+begin_src nix
  # programs.bash = {
  #  enable = true; # this is needed for home.sessionVariables to work
  # };
  # programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode.fhs;
  # };
  # programs.emacs = {
  #  enable = true;
  #  package = pkgs.emacs-unstable-pgtk;
  # };
  # #+end_src
  
  # #+RESULTS:
  
  # *** Services
  # #+begin_src nix
  # services.syncthing = {
  #  enable = true;
  #  tray = {enable = true;};
  # };
  # services.emacs.enable = true;
  # services.blueman-applet.enable = true;
  # #+end_src
  # ** Packages
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-packages
  # :END:
  # #+begin_src nix :tangle home/packages.nix :noweb no-export :noweb-ref no
  #  { inputs, pkgs, ... }:
  #  {
  #  home.packages = (with pkgs; \[
  #  <<hm-packages>>
  #  \]);
  #  }
  # #+end_src
  
  # *** Development
  # **** Text-editor
  # #+begin_src nix
  # helix
  # lapce # a rust powered editor
  # libreoffice
  # neovide
  # marktext
  # #+end_src
  
  # **** Languages
  # These tools can be seen as runtimes, for non serious usage and quick testing.
  # To seriously do development on nixos I have to write derivations.
  # #+begin_src nix
  #  gcc ccache cmake clang-tools bear
  #  (python311.withPackages(ps: with ps; \[
  #  # required by lsp-bridge, holo-layer, and blink search
  #  epc orjson sexpdata six paramiko rapidfuzz
  #  pynput inflect pyqt6 pyqt6-sip
  #  python-pam requests
  #  numpy pandas toolz
  #  # pyperclip
  #  pillow
  #  # grad-cam
  #  # pytorchWithCuda
  #  pytorch][]]
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
     nerdfonts
     noto-fonts-monochrome-emoji
     noto-fonts-emoji
     noto-fonts-extra
     source-han-mono
     source-han-sans
     source-han-serif
     source-han-serif-vf-ttf
  
     commit-mono
     monaspace
     # mynur.symbols-nerd-font
     # mynur.ibm-plex-nerd-font
     ibm-plex
     mynur.sarasa-gothic-nerd-font
     fontforge-gtk
  ];
  # ends here
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron";
  #  homeDirectory = "/home/aaron";
  # in
  # {
  #  imports = \[
  #  ./packages.nix
  #  \];
  #  <<hm-config>>
  # }
  # #+end_src
  # *** Home
  # #+begin_src nix
  # home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  # };
  # programs.home-manager.enable = true;
  
  # nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
  #  cudaSupport = true;
  #  cudaVersion = "12";
  #  };
  # };
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Input method
  #  #+begin_src nix
  #  i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5 = {
  #  addons = with pkgs; \[
  #  fcitx5-gtk
  #  fcitx5-rime
  #  fcitx5-lua
  #  fcitx5-chinese-addons
  #  librime
  #  \];
  #  };
  #  };
  # #+end_src
  # *** Font
  # #+begin_src nix
  # fonts.fontconfig.enable = true;
  # home.packages = with pkgs; \[
  #  nerdfonts
  #  noto-fonts-monochrome-emoji
  #  noto-fonts-emoji
  #  noto-fonts-extra
  #  source-han-mono
  #  source-han-sans
  #  source-han-serif
  #  source-han-serif-vf-ttf
  
  #  commit-mono
  #  monaspace
  #  # mynur.symbols-nerd-font
  #  # mynur.ibm-plex-nerd-font
  #  ibm-plex
  #  mynur.sarasa-gothic-nerd-font
  #  fontforge-gtk
  # \];
  # #+end_src
  
  # #+RESULTS:
  
  # *** GTK
  # #+begin_src nix
  # gtk.enable = true;
  # # gtk.theme = {
  # # name = "Fluent";
  # # package = pkgs.fluent-gtk-theme.override {
  # # tweaks = \[ "blur" \];
  # # };
  # # };
  # gtk.iconTheme = {
  #  name = "kora";
  #  package = pkgs.kora-icon-theme;
  # };
  # # gtk.cursorTheme = {
  # # package = pkgs.whitesur-cursors;
  # # name = "whitesur-cursors";
  # # size = 32;
  # # };
  # home.pointerCursor = {
  #  package = pkgs.whitesur-cursors;
  #  name = "WhiteSur-cursors";
  #  size = 32;
  #  x11.enable = true;
  #  gtk.enable = true;
  # };
  # xresources.properties = {
  #  "Xcursor.size" = 32;
  #  "Xft.dpi" = 172;
  # };
  # #+end_src
  
  # #+begin_src nix
  # gtk.gtk3.bookmarks = \[
  #  "file:/${homeDirectory}/Documents"
  #  "file:/${homeDirectory}/Music"
  #  "file:/${homeDirectory}/Pictures"
  #  "file:/${homeDirectory}/Videos"
  #  "file:/${homeDirectory}/Downloads"
  #  "file:/${homeDirectory}/Desktop"
  #  "file:/${homeDirectory}/Projects"
  #  "file:/${homeDirectory}/.config Config"
  #  "file:/${homeDirectory}/.local/share Local"
  # \];
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Programs
  # #+begin_src nix
  # programs.bash = {
  #  enable = true; # this is needed for home.sessionVariables to work
  # };
  # programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode.fhs;
  # };
  # programs.emacs = {
  #  enable = true;
  #  package = pkgs.emacs-unstable-pgtk;
  # };
  # #+end_src
  
  # #+RESULTS:
  
  # *** Services
  # #+begin_src nix
  # services.syncthing = {
  #  enable = true;
  #  tray = {enable = true;};
  # };
  # services.emacs.enable = true;
  # services.blueman-applet.enable = true;
  # #+end_src
  # ** Packages
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-packages
  # :END:
  # #+begin_src nix :tangle home/packages.nix :noweb no-export :noweb-ref no
  #  { inputs, pkgs, ... }:
  #  {
  #  home.packages = (with pkgs; \[
  #  <<hm-packages>>
  #  \]);
  #  }
  # #+end_src
  
  # *** Development
  # **** Text-editor
  # #+begin_src nix
  # helix
  # lapce # a rust powered editor
  # libreoffice
  # neovide
  # marktext
  # #+end_src
  
  # **** Languages
  # These tools can be seen as runtimes, for non serious usage and quick testing.
  # To seriously do development on nixos I have to write derivations.
  # #+begin_src nix
  #  gcc ccache cmake clang-tools bear
  #  (python311.withPackages(ps: with ps; \[
  #  # required by lsp-bridge, holo-layer, and blink search
  #  epc orjson sexpdata six paramiko rapidfuzz
  #  pynput inflect pyqt6 pyqt6-sip
  #  python-pam requests
  #  numpy pandas toolz
  #  # pyperclip
  #  pillow
  #  # grad-cam
  #  # pytorchWithCuda
  #  pytorch][]]
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
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron";
  #  homeDirectory = "/home/aaron";
  # in
  # {
  #  imports = \[
  #  ./packages.nix
  #  \];
  #  <<hm-config>>
  # }
  # #+end_src
  # *** Home
  # #+begin_src nix
  # home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  # };
  # programs.home-manager.enable = true;
  
  # nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
  #  cudaSupport = true;
  #  cudaVersion = "12";
  #  };
  # };
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Input method
  #  #+begin_src nix
  #  i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5 = {
  #  addons = with pkgs; \[
  #  fcitx5-gtk
  #  fcitx5-rime
  #  fcitx5-lua
  #  fcitx5-chinese-addons
  #  librime
  #  \];
  #  };
  #  };
  # #+end_src
  # *** Font
  # #+begin_src nix
  # fonts.fontconfig.enable = true;
  # home.packages = with pkgs; \[
  #  nerdfonts
  #  noto-fonts-monochrome-emoji
  #  noto-fonts-emoji
  #  noto-fonts-extra
  #  source-han-mono
  #  source-han-sans
  #  source-han-serif
  #  source-han-serif-vf-ttf
  
  #  commit-mono
  #  monaspace
  #  # mynur.symbols-nerd-font
  #  # mynur.ibm-plex-nerd-font
  #  ibm-plex
  #  mynur.sarasa-gothic-nerd-font
  #  fontforge-gtk
  # \];
  # #+end_src
  
  # #+RESULTS:
  
  # *** GTK
  # #+begin_src nix
  # gtk.enable = true;
  # # gtk.theme = {
  # # name = "Fluent";
  # # package = pkgs.fluent-gtk-theme.override {
  # # tweaks = \[ "blur" \];
  # # };
  # # };
  # gtk.iconTheme = {
  #  name = "kora";
  #  package = pkgs.kora-icon-theme;
  # };
  # # gtk.cursorTheme = {
  # # package = pkgs.whitesur-cursors;
  # # name = "whitesur-cursors";
  # # size = 32;
  # # };
  # home.pointerCursor = {
  #  package = pkgs.whitesur-cursors;
  #  name = "WhiteSur-cursors";
  #  size = 32;
  #  x11.enable = true;
  #  gtk.enable = true;
  # };
  # xresources.properties = {
  #  "Xcursor.size" = 32;
  #  "Xft.dpi" = 172;
  # };
  # #+end_src
  
  # #+begin_src nix
  # gtk.gtk3.bookmarks = \[
  #  "file:/${homeDirectory}/Documents"
  #  "file:/${homeDirectory}/Music"
  #  "file:/${homeDirectory}/Pictures"
  #  "file:/${homeDirectory}/Videos"
  #  "file:/${homeDirectory}/Downloads"
  #  "file:/${homeDirectory}/Desktop"
  #  "file:/${homeDirectory}/Projects"
  #  "file:/${homeDirectory}/.config Config"
  #  "file:/${homeDirectory}/.local/share Local"
  # \];
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Programs
  # #+begin_src nix
  # programs.bash = {
  #  enable = true; # this is needed for home.sessionVariables to work
  # };
  # programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode.fhs;
  # };
  # programs.emacs = {
  #  enable = true;
  #  package = pkgs.emacs-unstable-pgtk;
  # };
  # #+end_src
  
  # #+RESULTS:
  
  # *** Services
  # #+begin_src nix
  # services.syncthing = {
  #  enable = true;
  #  tray = {enable = true;};
  # };
  # services.emacs.enable = true;
  # services.blueman-applet.enable = true;
  # #+end_src
  # ** Packages
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-packages
  # :END:
  # #+begin_src nix :tangle home/packages.nix :noweb no-export :noweb-ref no
  #  { inputs, pkgs, ... }:
  #  {
  #  home.packages = (with pkgs; \[
  #  <<hm-packages>>
  #  \]);
  #  }
  # #+end_src
  
  # *** Development
  # **** Text-editor
  # #+begin_src nix
  # helix
  # lapce # a rust powered editor
  # libreoffice
  # neovide
  # marktext
  # #+end_src
  
  # **** Languages
  # These tools can be seen as runtimes, for non serious usage and quick testing.
  # To seriously do development on nixos I have to write derivations.
  # #+begin_src nix
  #  gcc ccache cmake clang-tools bear
  #  (python311.withPackages(ps: with ps; \[
  #  # required by lsp-bridge, holo-layer, and blink search
  #  epc orjson sexpdata six paramiko rapidfuzz
  #  pynput inflect pyqt6 pyqt6-sip
  #  python-pam requests
  #  numpy pandas toolz
  #  # pyperclip
  #  pillow
  #  # grad-cam
  #  # pytorchWithCuda
  #  pytorch][]]
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
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron";
  #  homeDirectory = "/home/aaron";
  # in
  # {
  #  imports = \[
  #  ./packages.nix
  #  \];
  #  <<hm-config>>
  # }
  # #+end_src
  # *** Home
  # #+begin_src nix
  # home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  # };
  # programs.home-manager.enable = true;
  
  # nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
  #  cudaSupport = true;
  #  cudaVersion = "12";
  #  };
  # };
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Input method
  #  #+begin_src nix
  #  i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5 = {
  #  addons = with pkgs; \[
  #  fcitx5-gtk
  #  fcitx5-rime
  #  fcitx5-lua
  #  fcitx5-chinese-addons
  #  librime
  #  \];
  #  };
  #  };
  # #+end_src
  # *** Font
  # #+begin_src nix
  # fonts.fontconfig.enable = true;
  # home.packages = with pkgs; \[
  #  nerdfonts
  #  noto-fonts-monochrome-emoji
  #  noto-fonts-emoji
  #  noto-fonts-extra
  #  source-han-mono
  #  source-han-sans
  #  source-han-serif
  #  source-han-serif-vf-ttf
  
  #  commit-mono
  #  monaspace
  #  # mynur.symbols-nerd-font
  #  # mynur.ibm-plex-nerd-font
  #  ibm-plex
  #  mynur.sarasa-gothic-nerd-font
  #  fontforge-gtk
  # \];
  # #+end_src
  
  # #+RESULTS:
  
  # *** GTK
  # #+begin_src nix
  # gtk.enable = true;
  # # gtk.theme = {
  # # name = "Fluent";
  # # package = pkgs.fluent-gtk-theme.override {
  # # tweaks = \[ "blur" \];
  # # };
  # # };
  # gtk.iconTheme = {
  #  name = "kora";
  #  package = pkgs.kora-icon-theme;
  # };
  # # gtk.cursorTheme = {
  # # package = pkgs.whitesur-cursors;
  # # name = "whitesur-cursors";
  # # size = 32;
  # # };
  # home.pointerCursor = {
  #  package = pkgs.whitesur-cursors;
  #  name = "WhiteSur-cursors";
  #  size = 32;
  #  x11.enable = true;
  #  gtk.enable = true;
  # };
  # xresources.properties = {
  #  "Xcursor.size" = 32;
  #  "Xft.dpi" = 172;
  # };
  # #+end_src
  
  # #+begin_src nix
  # gtk.gtk3.bookmarks = \[
  #  "file:/${homeDirectory}/Documents"
  #  "file:/${homeDirectory}/Music"
  #  "file:/${homeDirectory}/Pictures"
  #  "file:/${homeDirectory}/Videos"
  #  "file:/${homeDirectory}/Downloads"
  #  "file:/${homeDirectory}/Desktop"
  #  "file:/${homeDirectory}/Projects"
  #  "file:/${homeDirectory}/.config Config"
  #  "file:/${homeDirectory}/.local/share Local"
  # \];
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Programs
  # #+begin_src nix
  # programs.bash = {
  #  enable = true; # this is needed for home.sessionVariables to work
  # };
  # programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode.fhs;
  # };
  # programs.emacs = {
  #  enable = true;
  #  package = pkgs.emacs-unstable-pgtk;
  # };
  # #+end_src
  
  # #+RESULTS:
  
  # *** Services
  # #+begin_src nix
  # services.syncthing = {
  #  enable = true;
  #  tray = {enable = true;};
  # };
  # services.emacs.enable = true;
  # services.blueman-applet.enable = true;
  # #+end_src
  # ** Packages
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-packages
  # :END:
  # #+begin_src nix :tangle home/packages.nix :noweb no-export :noweb-ref no
  #  { inputs, pkgs, ... }:
  #  {
  #  home.packages = (with pkgs; \[
  #  <<hm-packages>>
  #  \]);
  #  }
  # #+end_src
  
  # *** Development
  # **** Text-editor
  # #+begin_src nix
  # helix
  # lapce # a rust powered editor
  # libreoffice
  # neovide
  # marktext
  # #+end_src
  
  # **** Languages
  # These tools can be seen as runtimes, for non serious usage and quick testing.
  # To seriously do development on nixos I have to write derivations.
  # #+begin_src nix
  #  gcc ccache cmake clang-tools bear
  #  (python311.withPackages(ps: with ps; \[
  #  # required by lsp-bridge, holo-layer, and blink search
  #  epc orjson sexpdata six paramiko rapidfuzz
  #  pynput inflect pyqt6 pyqt6-sip
  #  python-pam requests
  #  numpy pandas toolz
  #  # pyperclip
  #  pillow
  #  # grad-cam
  #  # pytorchWithCuda
  #  pytorch][]]
  programs.bash = {
    enable = true; # this is needed for home.sessionVariables to work
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-pgtk;
  };
  # ends here
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron";
  #  homeDirectory = "/home/aaron";
  # in
  # {
  #  imports = \[
  #  ./packages.nix
  #  \];
  #  <<hm-config>>
  # }
  # #+end_src
  # *** Home
  # #+begin_src nix
  # home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  # };
  # programs.home-manager.enable = true;
  
  # nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
  #  cudaSupport = true;
  #  cudaVersion = "12";
  #  };
  # };
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Input method
  #  #+begin_src nix
  #  i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5 = {
  #  addons = with pkgs; \[
  #  fcitx5-gtk
  #  fcitx5-rime
  #  fcitx5-lua
  #  fcitx5-chinese-addons
  #  librime
  #  \];
  #  };
  #  };
  # #+end_src
  # *** Font
  # #+begin_src nix
  # fonts.fontconfig.enable = true;
  # home.packages = with pkgs; \[
  #  nerdfonts
  #  noto-fonts-monochrome-emoji
  #  noto-fonts-emoji
  #  noto-fonts-extra
  #  source-han-mono
  #  source-han-sans
  #  source-han-serif
  #  source-han-serif-vf-ttf
  
  #  commit-mono
  #  monaspace
  #  # mynur.symbols-nerd-font
  #  # mynur.ibm-plex-nerd-font
  #  ibm-plex
  #  mynur.sarasa-gothic-nerd-font
  #  fontforge-gtk
  # \];
  # #+end_src
  
  # #+RESULTS:
  
  # *** GTK
  # #+begin_src nix
  # gtk.enable = true;
  # # gtk.theme = {
  # # name = "Fluent";
  # # package = pkgs.fluent-gtk-theme.override {
  # # tweaks = \[ "blur" \];
  # # };
  # # };
  # gtk.iconTheme = {
  #  name = "kora";
  #  package = pkgs.kora-icon-theme;
  # };
  # # gtk.cursorTheme = {
  # # package = pkgs.whitesur-cursors;
  # # name = "whitesur-cursors";
  # # size = 32;
  # # };
  # home.pointerCursor = {
  #  package = pkgs.whitesur-cursors;
  #  name = "WhiteSur-cursors";
  #  size = 32;
  #  x11.enable = true;
  #  gtk.enable = true;
  # };
  # xresources.properties = {
  #  "Xcursor.size" = 32;
  #  "Xft.dpi" = 172;
  # };
  # #+end_src
  
  # #+begin_src nix
  # gtk.gtk3.bookmarks = \[
  #  "file:/${homeDirectory}/Documents"
  #  "file:/${homeDirectory}/Music"
  #  "file:/${homeDirectory}/Pictures"
  #  "file:/${homeDirectory}/Videos"
  #  "file:/${homeDirectory}/Downloads"
  #  "file:/${homeDirectory}/Desktop"
  #  "file:/${homeDirectory}/Projects"
  #  "file:/${homeDirectory}/.config Config"
  #  "file:/${homeDirectory}/.local/share Local"
  # \];
  
  # #+end_src
  
  # #+RESULTS:
  
  # *** Programs
  # #+begin_src nix
  # programs.bash = {
  #  enable = true; # this is needed for home.sessionVariables to work
  # };
  # programs.vscode = {
  #  enable = true;
  #  package = pkgs.vscode.fhs;
  # };
  # programs.emacs = {
  #  enable = true;
  #  package = pkgs.emacs-unstable-pgtk;
  # };
  # #+end_src
  
  # #+RESULTS:
  
  # *** Services
  # #+begin_src nix
  # services.syncthing = {
  #  enable = true;
  #  tray = {enable = true;};
  # };
  # services.emacs.enable = true;
  # services.blueman-applet.enable = true;
  # #+end_src
  # ** Packages
  # :PROPERTIES:
  # :header-args:nix: :noweb-ref hm-packages
  # :END:
  # #+begin_src nix :tangle home/packages.nix :noweb no-export :noweb-ref no
  #  { inputs, pkgs, ... }:
  #  {
  #  home.packages = (with pkgs; \[
  #  <<hm-packages>>
  #  \]);
  #  }
  # #+end_src
  
  # *** Development
  # **** Text-editor
  # #+begin_src nix
  # helix
  # lapce # a rust powered editor
  # libreoffice
  # neovide
  # marktext
  # #+end_src
  
  # **** Languages
  # These tools can be seen as runtimes, for non serious usage and quick testing.
  # To seriously do development on nixos I have to write derivations.
  # #+begin_src nix
  #  gcc ccache cmake clang-tools bear
  #  (python311.withPackages(ps: with ps; \[
  #  # required by lsp-bridge, holo-layer, and blink search
  #  epc orjson sexpdata six paramiko rapidfuzz
  #  pynput inflect pyqt6 pyqt6-sip
  #  python-pam requests
  #  numpy pandas toolz
  #  # pyperclip
  #  pillow
  #  # grad-cam
  #  # pytorchWithCuda
  #  pytorch][]]
  services.syncthing = {
    enable = true;
    tray = {enable = true;};
  };
  services.emacs.enable = true;
  services.blueman-applet.enable = true;
  # ends here
}
# Config:1 ends here
