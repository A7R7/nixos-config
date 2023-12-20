# [[file:../nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
# { config, pkgs, inputs, ... }:
# let
#  username = "aaron-nix";
#  homeDirectory = "/home/aaron-nix";
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
#  home = {
#  username = username;
#  homeDirectory = homeDirectory;
#  stateVersion = "23.11";
#  sessionVariables = {
#  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
#  NIXPKGS_ALLOW_UNFREE = "1";
#  # SHELL = "${pkgs.zsh}/bin/elvish";
#  };
#  sessionPath = \[
#  "$HOME/.local/bin"
#  \];
#  };
#  programs.home-manager.enable = true;

#  nixpkgs = {
#  config = {
#  allowUnfree = true;
#  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
#  allowUnfreePredicate = (_: true);
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
#  mynur.symbols-nerd-font
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
# gtk.theme = {
#  name = "fluent-gtk-theme";
#  package = pkgs.fluent-gtk-theme.override {
#  tweaks = \[ "blur" \];
#  };
# };
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
#  name = "WhiteSur-][Config:1]]
{ config, pkgs, inputs, ... }:
let
  username = "aaron-nix";
  homeDirectory = "/home/aaron-nix";
in
{
  imports = [
    ./packages.nix
  ];
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron-nix";
  #  homeDirectory = "/home/aaron-nix";
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
  #  home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  #  };
  #  programs.home-manager.enable = true;
  
  #  nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
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
  #  mynur.symbols-nerd-font
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
  # gtk.theme = {
  #  name = "fluent-gtk-theme";
  #  package = pkgs.fluent-gtk-theme.override {
  #  tweaks = \[ "blur" \];
  #  };
  # };
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
  #  name = "WhiteSur-][]]
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "23.11";
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
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
    };
  };
  
  # ends here
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron-nix";
  #  homeDirectory = "/home/aaron-nix";
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
  #  home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  #  };
  #  programs.home-manager.enable = true;
  
  #  nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
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
  #  mynur.symbols-nerd-font
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
  # gtk.theme = {
  #  name = "fluent-gtk-theme";
  #  package = pkgs.fluent-gtk-theme.override {
  #  tweaks = \[ "blur" \];
  #  };
  # };
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
  #  name = "WhiteSur-][]]
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
     mynur.symbols-nerd-font
     # mynur.ibm-plex-nerd-font
     ibm-plex
     mynur.sarasa-gothic-nerd-font
     fontforge-gtk
  ];
  # ends here
  # [[file:nixos.org::+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
  # { config, pkgs, inputs, ... }:
  # let
  #  username = "aaron-nix";
  #  homeDirectory = "/home/aaron-nix";
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
  #  home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  #  };
  #  programs.home-manager.enable = true;
  
  #  nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
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
  #  mynur.symbols-nerd-font
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
  # gtk.theme = {
  #  name = "fluent-gtk-theme";
  #  package = pkgs.fluent-gtk-theme.override {
  #  tweaks = \[ "blur" \];
  #  };
  # };
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
  #  name = "WhiteSur-][]]
  gtk.enable = true;
  gtk.theme = {
    name = "fluent-gtk-theme";
    package = pkgs.fluent-gtk-theme.override {
      tweaks = [ "blur" ];
    };
  };
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
  #  username = "aaron-nix";
  #  homeDirectory = "/home/aaron-nix";
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
  #  home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  #  };
  #  programs.home-manager.enable = true;
  
  #  nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
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
  #  mynur.symbols-nerd-font
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
  # gtk.theme = {
  #  name = "fluent-gtk-theme";
  #  package = pkgs.fluent-gtk-theme.override {
  #  tweaks = \[ "blur" \];
  #  };
  # };
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
  #  name = "WhiteSur-][]]
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
  #  username = "aaron-nix";
  #  homeDirectory = "/home/aaron-nix";
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
  #  home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  #  };
  #  programs.home-manager.enable = true;
  
  #  nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
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
  #  mynur.symbols-nerd-font
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
  # gtk.theme = {
  #  name = "fluent-gtk-theme";
  #  package = pkgs.fluent-gtk-theme.override {
  #  tweaks = \[ "blur" \];
  #  };
  # };
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
  #  name = "WhiteSur-][]]
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
  #  username = "aaron-nix";
  #  homeDirectory = "/home/aaron-nix";
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
  #  home = {
  #  username = username;
  #  homeDirectory = homeDirectory;
  #  stateVersion = "23.11";
  #  sessionVariables = {
  #  QT_XCB_GL_INTEGRATION = "none"; # kde-connect
  #  NIXPKGS_ALLOW_UNFREE = "1";
  #  # SHELL = "${pkgs.zsh}/bin/elvish";
  #  };
  #  sessionPath = \[
  #  "$HOME/.local/bin"
  #  \];
  #  };
  #  programs.home-manager.enable = true;
  
  #  nixpkgs = {
  #  config = {
  #  allowUnfree = true;
  #  # Workaround for https:/github.com/nix-community/home-manager/issues/2942
  #  allowUnfreePredicate = (_: true);
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
  #  mynur.symbols-nerd-font
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
  # gtk.theme = {
  #  name = "fluent-gtk-theme";
  #  package = pkgs.fluent-gtk-theme.override {
  #  tweaks = \[ "blur" \];
  #  };
  # };
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
  #  name = "WhiteSur-][]]
  services.syncthing = {
    enable = true;
    tray = {enable = true;};
  };
  services.emacs.enable = true;
  # ends here
}
# Config:1 ends here
