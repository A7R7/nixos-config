# [[file:nixos.org::+begin_src nix :tangle flake.nix :noweb no-export
#  {
#  description = "A7R7's NixOS Flake";
#  nixConfig = {
#  <<nixConfig>>
#  };
#  inputs = {
#  <<inputs>>
#  };
#  outputs =
#  <<outputs>>
#  }
# #+end_src
# ** nixConfig
# #+begin_src nix :noweb-ref nixConfig
# experimental-features = \[ "nix-command" "flakes" \];
# # nix community's cache server
# extra-substituters = \[
#  "https:/nix-community.cachix.org"
#  "https:/nixpkgs-wayland.cachix.org"
#  "https:/anyrun.cachix.org"
#  "https:/cuda-maintainers.cachix.org"
# \];
# extra-trusted-public-keys = \[
#  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
#  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
#  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
#  "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
#  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
# \];

# #+end_src

# #+RESULTS:

# ** Inputs
# #+begin_src nix :noweb-ref inputs
# ## nixpkgs
# nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";
# nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
# nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
# nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
# home-manager = {
#  url = "github:nix-community/home-manager";
#  inputs.nixpkgs.follows = "nixpkgs";
# };

# utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
# nur.url = "github:nix-community/NUR";
# mynur.url = "github:A7R7/nur-packages";
# # mynur.url = "git+file:./?dir=./nurpkgs";
# # mynur.url = "./nurpkgs";
# # hyprland wm
# hyprland.url = "github:hyprwm/Hyprland";
# pyprland.url = "github:A7R7/pyprland";
# ags.url = "github:Aylur/ags";
# # ags.url = "github:Aylur/ags/feat/widgets-subclass-rewrite";
# musnix.url = "github:musnix/musnix";
# pip2nix.url = "github:nix-community/pip2nix";
# emacs.url = "github:nix-community/emacs-overlay";
# anyrun.url = "github:Kirottu/anyrun";
# anyrun.inputs.nixpkgs.follows = "nixpkgs";
#  #+end_src
# ** Outputs
# #+begin_src nix :noweb-ref outputs
#  inputs@{
#  self,
#  nixpkgs,
#  home-manager,
#  ... }:
#  let
#  username = "aaron";
#  system = "x86_64-linux";
#  pkgs = import nixpkgs {
#  inherit system;
#  config.allowUnfree = true;
#  overlays = with inputs; \[
#  nur.overlay
#  mynur.overlay
#  emacs.overlay
#  (final: prev: { v2305 = import inputs.nixpkgs-2305 {
#  inherit system;
#  config.allowUnfree = true;
#  };})
#  (final: prev: { v2311 = import inputs.nixpkgs-2311 {
#  inherit system;
#  config.allowUnfree = true;
#  };})
#  \];
#  };
#  in
#  {
#  nixosConfigurations = {
#  Omen16 = nixpkgs.lib.nixosSystem {
#  system = "x86_64-linux";
#  specialArgs = { inherit inputs username system pkgs; };
#  modules = \[ ./host/configuration.nix ./host/omen16.nix\];
#  };
#  };
#  homeConfigurations = {
#  aaron = home-manager.lib.homeManagerConfiguration {
#  inherit pkgs;
#  extraSpecialArgs = { inherit inputs username pkgs; };
#  modules = \[ ./home/home.nix \];
#  };
#  };
#  };

# #+end_src

# #+RESULTS:

# * Host
# :PROPERTIES:
# :header-args:nix: :noweb-ref host-config
# :END:
# #+begin_src nix :tangle host/configuration.nix :comments noweb :noweb no-export :noweb-ref no
#  { config, pkgs, lib, inputs, username, ... }:
#  {
#  imports =
#  \[
#  /etc/nixos/hardware-configuration.nix
#  inputs.musnix.nixosModules.musnix
#  \];
#  <<host-config>>
#  }
# #+end_src
# ** Nix
# #+begin_src nix
#  system.stateVersion = "23.11";
#  nixpkgs.config.allowUnfree = true;
#  nix = {
#  # This will add each flake input as a registry
#  # To make nix3 commands consistent with your flake
#  registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

#  # This will additionally add your inputs to the system's legacy channels
#  # Making legacy nix commands consistent as well, awesome!
#  nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

#  settings = {
#  experimental-features = "nix-command flakes";
#  auto-optimise-store = true;
#  trusted-users = \[ "${username}" \];
#  };
#  };
# #+end_src

# ** Boot
# \[\[file:/etc/nixos/hardware-configuration.nix\]\[/etc/nixos/hardware-configuration.nix\]\]
# #+begin_src nix
# boot = {
#  loader = {
#  # systemd-boot.enable = true;
#  grub = {
#  enable = true;
#  theme = pkgs.mynur.xenlism-grub-4k-nixos;
#  splashMode = "normal";
#  efiSupport = true;
#  useOSProber = true;
#  };
#  efi.canTouchEfiVariables = true;
#  efi.efiSysMountPoint = "/boot";
#  timeout = 10;
#  };
# };
# #+end_src
# ** Network & hostname
# #+begin_src nix
#  networking = {
#  networkmanager.enable = true;
#  };
# #+end_src
# ** Sound
# #+begin_src nix
#  musnix.enable = true;
#  sound.enable = false; # sound.enable is only meant for ALSA-based configurations
#  hardware.pulseaudio.enable = false;
#  hardware.bluetooth.enable = true;
#  security.rtkit.enable = true;
#  services. pipewire = {
#  enable = true;
#  alsa.enable = true;
#  alsa.support32Bit = true;
#  pulse.enable = true;
#  jack.enable = true;
#  };
# #+end_src
# ** Locale
# #+begin_src nix
#  time.timeZone = "Asia/Shanghai";
#  i18n = {
#  defaultLocale = "en_US.UTF-8";
#  supportedLocales = \[
#  "en_US.UTF-8/UTF-8"
#  "zh_CN.UTF-8/UTF-8"
#  \];
#  };
#  console = {
#  font = "Lat2-Terminus16";
#  useXkbConfig = true; # use xkbOptions in tty.
#  };


# #+end_src
# ** User

# #+begin_src nix
#  # Define a user account. Don't forget to set a password with ‘passwd’.
#  users.users.${username} = {
#  isNormalUser = true;
#  extraGroups = \[ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"\];
#  # shell = pkgs.elvish;
#  };
# #+end_src

# ** Pkgs
# #+begin_src nix
# environment.systemPackages = with pkgs; \[
#  vim neovim
#  wget
#  curl
#  git
#  stow
#  man
#  efibootmgr
#  gnumake
#  killall
#  home-manager
#  dash elvish fish nushell tcsh xonsh zsh
#  sddm-chili-theme
# \];
#  #+end_src
# *** Shells
# Shells. Yeah I'd like to try different shells.
# #+begin_src nix
# environment.shells = with pkgs; \[
#  dash elvish fish nushell tcsh xonsh zsh
# \];
# #+end_src
# This adds ~~/.local/bin~ to PATH.
# #+begin_src nix
# environment.localBinInPath = true;
# #+end_src

# ** Virtualisation
# #+begin_src nix
#  virtualisation = {
#  podman.enable = true;
#  libvirtd.enable = true;
#  waydroid.enable = true;
#  };
# #+end_src
# ** Programs
# #+begin_src nix
# # programs.regreet = {
# # This line installs ReGreet,
# # sets up systemd tmpfiles for it,
# # enables services.greetd and also configures its default session to start ReGreet using cage.
# # enable = true;
# # };

# #+end_src
# *** Window managers
# #+begin_src nix
# #+end_src

# #+begin_src nix
# programs.hyprland = {
#  enable = true;
#  xwayland.enable = true;
#  # enableNvidiaPatches = false; # deprecated
# };
# #+end_src

# #+begin_src nix
# programs.wayfire = {
#  enable = true;
#  package = pkgs.mynur.wayfire;
#  plugins = (with pkgs.wayfirePlugins; \[
#  wcm
#  wf-shell
#  wayfire-plugins-extra
#  \]) ++ \[
#  pkgs.mynur.swayfire
#  \];
# };
# environment.sessionVariables.WAYFIRE_CONFIG_FILE = "$HOME/.config/wayfire/wayfire.ini";
# #+end_src
# *** Misc
# #+begin_src nix
# programs.steam = {
#  enable = true;
#  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
#  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
# };
# #+end_src

# #+begin_src nix
# xdg.portal = {
#  enable = true;
#  wlr.enable = true;
#  # extraPortals = \[ pkgs.xdg-desktop-portal-gtk \];
# };
# #+end_src

# #+begin_src nix
# programs.adb.enable = true;
# programs.dconf.enable = true;
# #+end_src
# ** Fonts
# #+begin_src nix
#  fonts.fonts = with pkgs; \[
#  noto-fonts
#  noto-fonts-cjk
#  roboto roboto-serif
#  sarasa-gothic
#  \];
#  fonts.fontconfig = {
#  enable = true;
#  includeUserConf = true;
#  allowBitmaps = false;
#  };
# #+end_src
# ** Services
# *** COMMENT Greetd
# #+begin_src nix
#  services.greetd = {
#  enable = true;
#  settings = rec {
#  initial_session = {
#  command = "${pkgs.hyprland}/bin/Hyprland";
#  user = "${username}";
#  };
#  default_session = initial_session;
#  };
#  };
# #+end_src
# *** Xserver
#  #+begin_src nix
#  services.xserver.enable = true;
#  services.xserver.excludePackages = \[ pkgs.xterm \];
#  services.xserver.layout = "us";
#  services.xserver.xkbOptions = "caps:escape";
#  # services.xserver.displayManager.gdm.enable = true;
#  services.xserver.displayManager.sddm = {
#  enable = true;
#  # wayland.enable = true;
#  theme = "chili";
#  };
#  # displayManager.lightdm.enable = true;
#  # displayManager.lightdm.greeters.slick.enable = true;
#  # desktopManager.gnome.enable = true;
# #+end_src
# *** Misc
# #+begin_src nix
# services.tlp.enable = true;
# services.printing.enable = true;
# services.flatpak.enable = true;
# services.openssh.enable = true;
# # userspace virtual filesystem
# services.gvfs.enable = true;
# # an automatic device mounting daemon
# services.devmon.enable = true;
# # a DBus service that allows applications to query and manipulate storage devices.
# services.udisks2.enable = true;
# # a DBus service that provides power management support to applications.
# services.upower.enable = true;
# # a DBus service for accessing the list of user accounts and information attached to those accounts.
# services.accounts-daemon.enable = true;
#  #+end_src
# *** GNOME
# #+begin_src nix
#  services.gnome = {
#  evolution-data-server.enable = true;
#  glib-networking.enable = true;
#  gnome-keyring.enable = true;
#  gnome-online-accounts.enable = true;
#  at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
#  };
# #+end_src

# *** DAE
# #+begin_src nix
#  services.dae = {
#  enable = true;
#  configFile = "/home/${username}/.config/dae/config.dae";
#  };
# #+end_src
# *** Syncthing
# \[\[https:/github.com/syncthing/syncthing\]\[Syncthing\]\] is a continuouts file synchronization program using UPnP, which synchronize files *WITHOUT* centralized services.
# #+begin_src nix
#  services.syncthing = {
#  enable = true;
#  openDefaultPorts = true; # 22000/TCP and 22000/UDP
#  dataDir = "/home/${username}";
#  configDir = "/home/${username}/.config/syncthing";
#  user = "${username}";
#  group = "users";
#  # guiAdd.0:8384"; # To be able to access the web GUI
#  };
# #+end_src
# *** Blueman
# #+begin_src nix
# services.blueman.enable = true;
# #+end_src
# ** Security
# Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
# #+begin_src nix
#  security.polkit.enable = true;
#  # start polkit on login by creating a systemd user service
#  #+end_src
# * Home
# Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
# ** Config
# :PROPERTIES:
# :header-args:nix: :noweb-ref hm-config
# :END:
# #+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
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
#  pytorch][Flake:1]]
{
  description = "A7R7's NixOS Flake";
  nixConfig = {
    # [[file:nixos.org::+begin_src nix :tangle flake.nix :noweb no-export
    #  {
    #  description = "A7R7's NixOS Flake";
    #  nixConfig = {
    #  <<nixConfig>>
    #  };
    #  inputs = {
    #  <<inputs>>
    #  };
    #  outputs =
    #  <<outputs>>
    #  }
    # #+end_src
    # ** nixConfig
    # #+begin_src nix :noweb-ref nixConfig
    # experimental-features = \[ "nix-command" "flakes" \];
    # # nix community's cache server
    # extra-substituters = \[
    #  "https:/nix-community.cachix.org"
    #  "https:/nixpkgs-wayland.cachix.org"
    #  "https:/anyrun.cachix.org"
    #  "https:/cuda-maintainers.cachix.org"
    # \];
    # extra-trusted-public-keys = \[
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #  "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    #  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    # \];
    
    # #+end_src
    
    # #+RESULTS:
    
    # ** Inputs
    # #+begin_src nix :noweb-ref inputs
    # ## nixpkgs
    # nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    
    # utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    # nur.url = "github:nix-community/NUR";
    # mynur.url = "github:A7R7/nur-packages";
    # # mynur.url = "git+file:./?dir=./nurpkgs";
    # # mynur.url = "./nurpkgs";
    # # hyprland wm
    # hyprland.url = "github:hyprwm/Hyprland";
    # pyprland.url = "github:A7R7/pyprland";
    # ags.url = "github:Aylur/ags";
    # # ags.url = "github:Aylur/ags/feat/widgets-subclass-rewrite";
    # musnix.url = "github:musnix/musnix";
    # pip2nix.url = "github:nix-community/pip2nix";
    # emacs.url = "github:nix-community/emacs-overlay";
    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    #  #+end_src
    # ** Outputs
    # #+begin_src nix :noweb-ref outputs
    #  inputs@{
    #  self,
    #  nixpkgs,
    #  home-manager,
    #  ... }:
    #  let
    #  username = "aaron";
    #  system = "x86_64-linux";
    #  pkgs = import nixpkgs {
    #  inherit system;
    #  config.allowUnfree = true;
    #  overlays = with inputs; \[
    #  nur.overlay
    #  mynur.overlay
    #  emacs.overlay
    #  (final: prev: { v2305 = import inputs.nixpkgs-2305 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  (final: prev: { v2311 = import inputs.nixpkgs-2311 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  \];
    #  };
    #  in
    #  {
    #  nixosConfigurations = {
    #  Omen16 = nixpkgs.lib.nixosSystem {
    #  system = "x86_64-linux";
    #  specialArgs = { inherit inputs username system pkgs; };
    #  modules = \[ ./host/configuration.nix ./host/omen16.nix\];
    #  };
    #  };
    #  homeConfigurations = {
    #  aaron = home-manager.lib.homeManagerConfiguration {
    #  inherit pkgs;
    #  extraSpecialArgs = { inherit inputs username pkgs; };
    #  modules = \[ ./home/home.nix \];
    #  };
    #  };
    #  };
    
    # #+end_src
    
    # #+RESULTS:
    
    # * Host
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref host-config
    # :END:
    # #+begin_src nix :tangle host/configuration.nix :comments noweb :noweb no-export :noweb-ref no
    #  { config, pkgs, lib, inputs, username, ... }:
    #  {
    #  imports =
    #  \[
    #  /etc/nixos/hardware-configuration.nix
    #  inputs.musnix.nixosModules.musnix
    #  \];
    #  <<host-config>>
    #  }
    # #+end_src
    # ** Nix
    # #+begin_src nix
    #  system.stateVersion = "23.11";
    #  nixpkgs.config.allowUnfree = true;
    #  nix = {
    #  # This will add each flake input as a registry
    #  # To make nix3 commands consistent with your flake
    #  registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    
    #  # This will additionally add your inputs to the system's legacy channels
    #  # Making legacy nix commands consistent as well, awesome!
    #  nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    
    #  settings = {
    #  experimental-features = "nix-command flakes";
    #  auto-optimise-store = true;
    #  trusted-users = \[ "${username}" \];
    #  };
    #  };
    # #+end_src
    
    # ** Boot
    # \[\[file:/etc/nixos/hardware-configuration.nix\]\[/etc/nixos/hardware-configuration.nix\]\]
    # #+begin_src nix
    # boot = {
    #  loader = {
    #  # systemd-boot.enable = true;
    #  grub = {
    #  enable = true;
    #  theme = pkgs.mynur.xenlism-grub-4k-nixos;
    #  splashMode = "normal";
    #  efiSupport = true;
    #  useOSProber = true;
    #  };
    #  efi.canTouchEfiVariables = true;
    #  efi.efiSysMountPoint = "/boot";
    #  timeout = 10;
    #  };
    # };
    # #+end_src
    # ** Network & hostname
    # #+begin_src nix
    #  networking = {
    #  networkmanager.enable = true;
    #  };
    # #+end_src
    # ** Sound
    # #+begin_src nix
    #  musnix.enable = true;
    #  sound.enable = false; # sound.enable is only meant for ALSA-based configurations
    #  hardware.pulseaudio.enable = false;
    #  hardware.bluetooth.enable = true;
    #  security.rtkit.enable = true;
    #  services. pipewire = {
    #  enable = true;
    #  alsa.enable = true;
    #  alsa.support32Bit = true;
    #  pulse.enable = true;
    #  jack.enable = true;
    #  };
    # #+end_src
    # ** Locale
    # #+begin_src nix
    #  time.timeZone = "Asia/Shanghai";
    #  i18n = {
    #  defaultLocale = "en_US.UTF-8";
    #  supportedLocales = \[
    #  "en_US.UTF-8/UTF-8"
    #  "zh_CN.UTF-8/UTF-8"
    #  \];
    #  };
    #  console = {
    #  font = "Lat2-Terminus16";
    #  useXkbConfig = true; # use xkbOptions in tty.
    #  };
    
    
    # #+end_src
    # ** User
    
    # #+begin_src nix
    #  # Define a user account. Don't forget to set a password with ‘passwd’.
    #  users.users.${username} = {
    #  isNormalUser = true;
    #  extraGroups = \[ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"\];
    #  # shell = pkgs.elvish;
    #  };
    # #+end_src
    
    # ** Pkgs
    # #+begin_src nix
    # environment.systemPackages = with pkgs; \[
    #  vim neovim
    #  wget
    #  curl
    #  git
    #  stow
    #  man
    #  efibootmgr
    #  gnumake
    #  killall
    #  home-manager
    #  dash elvish fish nushell tcsh xonsh zsh
    #  sddm-chili-theme
    # \];
    #  #+end_src
    # *** Shells
    # Shells. Yeah I'd like to try different shells.
    # #+begin_src nix
    # environment.shells = with pkgs; \[
    #  dash elvish fish nushell tcsh xonsh zsh
    # \];
    # #+end_src
    # This adds ~~/.local/bin~ to PATH.
    # #+begin_src nix
    # environment.localBinInPath = true;
    # #+end_src
    
    # ** Virtualisation
    # #+begin_src nix
    #  virtualisation = {
    #  podman.enable = true;
    #  libvirtd.enable = true;
    #  waydroid.enable = true;
    #  };
    # #+end_src
    # ** Programs
    # #+begin_src nix
    # # programs.regreet = {
    # # This line installs ReGreet,
    # # sets up systemd tmpfiles for it,
    # # enables services.greetd and also configures its default session to start ReGreet using cage.
    # # enable = true;
    # # };
    
    # #+end_src
    # *** Window managers
    # #+begin_src nix
    # #+end_src
    
    # #+begin_src nix
    # programs.hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  # enableNvidiaPatches = false; # deprecated
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.wayfire = {
    #  enable = true;
    #  package = pkgs.mynur.wayfire;
    #  plugins = (with pkgs.wayfirePlugins; \[
    #  wcm
    #  wf-shell
    #  wayfire-plugins-extra
    #  \]) ++ \[
    #  pkgs.mynur.swayfire
    #  \];
    # };
    # environment.sessionVariables.WAYFIRE_CONFIG_FILE = "$HOME/.config/wayfire/wayfire.ini";
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # programs.steam = {
    #  enable = true;
    #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # };
    # #+end_src
    
    # #+begin_src nix
    # xdg.portal = {
    #  enable = true;
    #  wlr.enable = true;
    #  # extraPortals = \[ pkgs.xdg-desktop-portal-gtk \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.adb.enable = true;
    # programs.dconf.enable = true;
    # #+end_src
    # ** Fonts
    # #+begin_src nix
    #  fonts.fonts = with pkgs; \[
    #  noto-fonts
    #  noto-fonts-cjk
    #  roboto roboto-serif
    #  sarasa-gothic
    #  \];
    #  fonts.fontconfig = {
    #  enable = true;
    #  includeUserConf = true;
    #  allowBitmaps = false;
    #  };
    # #+end_src
    # ** Services
    # *** COMMENT Greetd
    # #+begin_src nix
    #  services.greetd = {
    #  enable = true;
    #  settings = rec {
    #  initial_session = {
    #  command = "${pkgs.hyprland}/bin/Hyprland";
    #  user = "${username}";
    #  };
    #  default_session = initial_session;
    #  };
    #  };
    # #+end_src
    # *** Xserver
    #  #+begin_src nix
    #  services.xserver.enable = true;
    #  services.xserver.excludePackages = \[ pkgs.xterm \];
    #  services.xserver.layout = "us";
    #  services.xserver.xkbOptions = "caps:escape";
    #  # services.xserver.displayManager.gdm.enable = true;
    #  services.xserver.displayManager.sddm = {
    #  enable = true;
    #  # wayland.enable = true;
    #  theme = "chili";
    #  };
    #  # displayManager.lightdm.enable = true;
    #  # displayManager.lightdm.greeters.slick.enable = true;
    #  # desktopManager.gnome.enable = true;
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # services.tlp.enable = true;
    # services.printing.enable = true;
    # services.flatpak.enable = true;
    # services.openssh.enable = true;
    # # userspace virtual filesystem
    # services.gvfs.enable = true;
    # # an automatic device mounting daemon
    # services.devmon.enable = true;
    # # a DBus service that allows applications to query and manipulate storage devices.
    # services.udisks2.enable = true;
    # # a DBus service that provides power management support to applications.
    # services.upower.enable = true;
    # # a DBus service for accessing the list of user accounts and information attached to those accounts.
    # services.accounts-daemon.enable = true;
    #  #+end_src
    # *** GNOME
    # #+begin_src nix
    #  services.gnome = {
    #  evolution-data-server.enable = true;
    #  glib-networking.enable = true;
    #  gnome-keyring.enable = true;
    #  gnome-online-accounts.enable = true;
    #  at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
    #  };
    # #+end_src
    
    # *** DAE
    # #+begin_src nix
    #  services.dae = {
    #  enable = true;
    #  configFile = "/home/${username}/.config/dae/config.dae";
    #  };
    # #+end_src
    # *** Syncthing
    # \[\[https:/github.com/syncthing/syncthing\]\[Syncthing\]\] is a continuouts file synchronization program using UPnP, which synchronize files *WITHOUT* centralized services.
    # #+begin_src nix
    #  services.syncthing = {
    #  enable = true;
    #  openDefaultPorts = true; # 22000/TCP and 22000/UDP
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #  user = "${username}";
    #  group = "users";
    #  # guiAdd.0:8384"; # To be able to access the web GUI
    #  };
    # #+end_src
    # *** Blueman
    # #+begin_src nix
    # services.blueman.enable = true;
    # #+end_src
    # ** Security
    # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
    # #+begin_src nix
    #  security.polkit.enable = true;
    #  # start polkit on login by creating a systemd user service
    #  #+end_src
    # * Home
    # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
    # ** Config
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref hm-config
    # :END:
    # #+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
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
    experimental-features = [ "nix-command" "flakes" ];
    # nix community's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://anyrun.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
    
    # ends here
  };
  inputs = {
    # [[file:nixos.org::+begin_src nix :tangle flake.nix :noweb no-export
    #  {
    #  description = "A7R7's NixOS Flake";
    #  nixConfig = {
    #  <<nixConfig>>
    #  };
    #  inputs = {
    #  <<inputs>>
    #  };
    #  outputs =
    #  <<outputs>>
    #  }
    # #+end_src
    # ** nixConfig
    # #+begin_src nix :noweb-ref nixConfig
    # experimental-features = \[ "nix-command" "flakes" \];
    # # nix community's cache server
    # extra-substituters = \[
    #  "https:/nix-community.cachix.org"
    #  "https:/nixpkgs-wayland.cachix.org"
    #  "https:/anyrun.cachix.org"
    #  "https:/cuda-maintainers.cachix.org"
    # \];
    # extra-trusted-public-keys = \[
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #  "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    #  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    # \];
    
    # #+end_src
    
    # #+RESULTS:
    
    # ** Inputs
    # #+begin_src nix :noweb-ref inputs
    # ## nixpkgs
    # nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    
    # utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    # nur.url = "github:nix-community/NUR";
    # mynur.url = "github:A7R7/nur-packages";
    # # mynur.url = "git+file:./?dir=./nurpkgs";
    # # mynur.url = "./nurpkgs";
    # # hyprland wm
    # hyprland.url = "github:hyprwm/Hyprland";
    # pyprland.url = "github:A7R7/pyprland";
    # ags.url = "github:Aylur/ags";
    # # ags.url = "github:Aylur/ags/feat/widgets-subclass-rewrite";
    # musnix.url = "github:musnix/musnix";
    # pip2nix.url = "github:nix-community/pip2nix";
    # emacs.url = "github:nix-community/emacs-overlay";
    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    #  #+end_src
    # ** Outputs
    # #+begin_src nix :noweb-ref outputs
    #  inputs@{
    #  self,
    #  nixpkgs,
    #  home-manager,
    #  ... }:
    #  let
    #  username = "aaron";
    #  system = "x86_64-linux";
    #  pkgs = import nixpkgs {
    #  inherit system;
    #  config.allowUnfree = true;
    #  overlays = with inputs; \[
    #  nur.overlay
    #  mynur.overlay
    #  emacs.overlay
    #  (final: prev: { v2305 = import inputs.nixpkgs-2305 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  (final: prev: { v2311 = import inputs.nixpkgs-2311 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  \];
    #  };
    #  in
    #  {
    #  nixosConfigurations = {
    #  Omen16 = nixpkgs.lib.nixosSystem {
    #  system = "x86_64-linux";
    #  specialArgs = { inherit inputs username system pkgs; };
    #  modules = \[ ./host/configuration.nix ./host/omen16.nix\];
    #  };
    #  };
    #  homeConfigurations = {
    #  aaron = home-manager.lib.homeManagerConfiguration {
    #  inherit pkgs;
    #  extraSpecialArgs = { inherit inputs username pkgs; };
    #  modules = \[ ./home/home.nix \];
    #  };
    #  };
    #  };
    
    # #+end_src
    
    # #+RESULTS:
    
    # * Host
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref host-config
    # :END:
    # #+begin_src nix :tangle host/configuration.nix :comments noweb :noweb no-export :noweb-ref no
    #  { config, pkgs, lib, inputs, username, ... }:
    #  {
    #  imports =
    #  \[
    #  /etc/nixos/hardware-configuration.nix
    #  inputs.musnix.nixosModules.musnix
    #  \];
    #  <<host-config>>
    #  }
    # #+end_src
    # ** Nix
    # #+begin_src nix
    #  system.stateVersion = "23.11";
    #  nixpkgs.config.allowUnfree = true;
    #  nix = {
    #  # This will add each flake input as a registry
    #  # To make nix3 commands consistent with your flake
    #  registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    
    #  # This will additionally add your inputs to the system's legacy channels
    #  # Making legacy nix commands consistent as well, awesome!
    #  nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    
    #  settings = {
    #  experimental-features = "nix-command flakes";
    #  auto-optimise-store = true;
    #  trusted-users = \[ "${username}" \];
    #  };
    #  };
    # #+end_src
    
    # ** Boot
    # \[\[file:/etc/nixos/hardware-configuration.nix\]\[/etc/nixos/hardware-configuration.nix\]\]
    # #+begin_src nix
    # boot = {
    #  loader = {
    #  # systemd-boot.enable = true;
    #  grub = {
    #  enable = true;
    #  theme = pkgs.mynur.xenlism-grub-4k-nixos;
    #  splashMode = "normal";
    #  efiSupport = true;
    #  useOSProber = true;
    #  };
    #  efi.canTouchEfiVariables = true;
    #  efi.efiSysMountPoint = "/boot";
    #  timeout = 10;
    #  };
    # };
    # #+end_src
    # ** Network & hostname
    # #+begin_src nix
    #  networking = {
    #  networkmanager.enable = true;
    #  };
    # #+end_src
    # ** Sound
    # #+begin_src nix
    #  musnix.enable = true;
    #  sound.enable = false; # sound.enable is only meant for ALSA-based configurations
    #  hardware.pulseaudio.enable = false;
    #  hardware.bluetooth.enable = true;
    #  security.rtkit.enable = true;
    #  services. pipewire = {
    #  enable = true;
    #  alsa.enable = true;
    #  alsa.support32Bit = true;
    #  pulse.enable = true;
    #  jack.enable = true;
    #  };
    # #+end_src
    # ** Locale
    # #+begin_src nix
    #  time.timeZone = "Asia/Shanghai";
    #  i18n = {
    #  defaultLocale = "en_US.UTF-8";
    #  supportedLocales = \[
    #  "en_US.UTF-8/UTF-8"
    #  "zh_CN.UTF-8/UTF-8"
    #  \];
    #  };
    #  console = {
    #  font = "Lat2-Terminus16";
    #  useXkbConfig = true; # use xkbOptions in tty.
    #  };
    
    
    # #+end_src
    # ** User
    
    # #+begin_src nix
    #  # Define a user account. Don't forget to set a password with ‘passwd’.
    #  users.users.${username} = {
    #  isNormalUser = true;
    #  extraGroups = \[ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"\];
    #  # shell = pkgs.elvish;
    #  };
    # #+end_src
    
    # ** Pkgs
    # #+begin_src nix
    # environment.systemPackages = with pkgs; \[
    #  vim neovim
    #  wget
    #  curl
    #  git
    #  stow
    #  man
    #  efibootmgr
    #  gnumake
    #  killall
    #  home-manager
    #  dash elvish fish nushell tcsh xonsh zsh
    #  sddm-chili-theme
    # \];
    #  #+end_src
    # *** Shells
    # Shells. Yeah I'd like to try different shells.
    # #+begin_src nix
    # environment.shells = with pkgs; \[
    #  dash elvish fish nushell tcsh xonsh zsh
    # \];
    # #+end_src
    # This adds ~~/.local/bin~ to PATH.
    # #+begin_src nix
    # environment.localBinInPath = true;
    # #+end_src
    
    # ** Virtualisation
    # #+begin_src nix
    #  virtualisation = {
    #  podman.enable = true;
    #  libvirtd.enable = true;
    #  waydroid.enable = true;
    #  };
    # #+end_src
    # ** Programs
    # #+begin_src nix
    # # programs.regreet = {
    # # This line installs ReGreet,
    # # sets up systemd tmpfiles for it,
    # # enables services.greetd and also configures its default session to start ReGreet using cage.
    # # enable = true;
    # # };
    
    # #+end_src
    # *** Window managers
    # #+begin_src nix
    # #+end_src
    
    # #+begin_src nix
    # programs.hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  # enableNvidiaPatches = false; # deprecated
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.wayfire = {
    #  enable = true;
    #  package = pkgs.mynur.wayfire;
    #  plugins = (with pkgs.wayfirePlugins; \[
    #  wcm
    #  wf-shell
    #  wayfire-plugins-extra
    #  \]) ++ \[
    #  pkgs.mynur.swayfire
    #  \];
    # };
    # environment.sessionVariables.WAYFIRE_CONFIG_FILE = "$HOME/.config/wayfire/wayfire.ini";
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # programs.steam = {
    #  enable = true;
    #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # };
    # #+end_src
    
    # #+begin_src nix
    # xdg.portal = {
    #  enable = true;
    #  wlr.enable = true;
    #  # extraPortals = \[ pkgs.xdg-desktop-portal-gtk \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.adb.enable = true;
    # programs.dconf.enable = true;
    # #+end_src
    # ** Fonts
    # #+begin_src nix
    #  fonts.fonts = with pkgs; \[
    #  noto-fonts
    #  noto-fonts-cjk
    #  roboto roboto-serif
    #  sarasa-gothic
    #  \];
    #  fonts.fontconfig = {
    #  enable = true;
    #  includeUserConf = true;
    #  allowBitmaps = false;
    #  };
    # #+end_src
    # ** Services
    # *** COMMENT Greetd
    # #+begin_src nix
    #  services.greetd = {
    #  enable = true;
    #  settings = rec {
    #  initial_session = {
    #  command = "${pkgs.hyprland}/bin/Hyprland";
    #  user = "${username}";
    #  };
    #  default_session = initial_session;
    #  };
    #  };
    # #+end_src
    # *** Xserver
    #  #+begin_src nix
    #  services.xserver.enable = true;
    #  services.xserver.excludePackages = \[ pkgs.xterm \];
    #  services.xserver.layout = "us";
    #  services.xserver.xkbOptions = "caps:escape";
    #  # services.xserver.displayManager.gdm.enable = true;
    #  services.xserver.displayManager.sddm = {
    #  enable = true;
    #  # wayland.enable = true;
    #  theme = "chili";
    #  };
    #  # displayManager.lightdm.enable = true;
    #  # displayManager.lightdm.greeters.slick.enable = true;
    #  # desktopManager.gnome.enable = true;
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # services.tlp.enable = true;
    # services.printing.enable = true;
    # services.flatpak.enable = true;
    # services.openssh.enable = true;
    # # userspace virtual filesystem
    # services.gvfs.enable = true;
    # # an automatic device mounting daemon
    # services.devmon.enable = true;
    # # a DBus service that allows applications to query and manipulate storage devices.
    # services.udisks2.enable = true;
    # # a DBus service that provides power management support to applications.
    # services.upower.enable = true;
    # # a DBus service for accessing the list of user accounts and information attached to those accounts.
    # services.accounts-daemon.enable = true;
    #  #+end_src
    # *** GNOME
    # #+begin_src nix
    #  services.gnome = {
    #  evolution-data-server.enable = true;
    #  glib-networking.enable = true;
    #  gnome-keyring.enable = true;
    #  gnome-online-accounts.enable = true;
    #  at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
    #  };
    # #+end_src
    
    # *** DAE
    # #+begin_src nix
    #  services.dae = {
    #  enable = true;
    #  configFile = "/home/${username}/.config/dae/config.dae";
    #  };
    # #+end_src
    # *** Syncthing
    # \[\[https:/github.com/syncthing/syncthing\]\[Syncthing\]\] is a continuouts file synchronization program using UPnP, which synchronize files *WITHOUT* centralized services.
    # #+begin_src nix
    #  services.syncthing = {
    #  enable = true;
    #  openDefaultPorts = true; # 22000/TCP and 22000/UDP
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #  user = "${username}";
    #  group = "users";
    #  # guiAdd.0:8384"; # To be able to access the web GUI
    #  };
    # #+end_src
    # *** Blueman
    # #+begin_src nix
    # services.blueman.enable = true;
    # #+end_src
    # ** Security
    # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
    # #+begin_src nix
    #  security.polkit.enable = true;
    #  # start polkit on login by creating a systemd user service
    #  #+end_src
    # * Home
    # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
    # ** Config
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref hm-config
    # :END:
    # #+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
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
    ## nixpkgs
    nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nur.url = "github:nix-community/NUR";
    mynur.url = "github:A7R7/nur-packages";
    # mynur.url = "git+file:./?dir=./nurpkgs";
    # mynur.url = "./nurpkgs";
    # hyprland wm
    hyprland.url = "github:hyprwm/Hyprland";
    pyprland.url = "github:A7R7/pyprland";
    ags.url = "github:Aylur/ags";
    # ags.url = "github:Aylur/ags/feat/widgets-subclass-rewrite";
    musnix.url = "github:musnix/musnix";
    pip2nix.url = "github:nix-community/pip2nix";
    emacs.url = "github:nix-community/emacs-overlay";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    # ends here
  };
  outputs =
    # [[file:nixos.org::+begin_src nix :tangle flake.nix :noweb no-export
    #  {
    #  description = "A7R7's NixOS Flake";
    #  nixConfig = {
    #  <<nixConfig>>
    #  };
    #  inputs = {
    #  <<inputs>>
    #  };
    #  outputs =
    #  <<outputs>>
    #  }
    # #+end_src
    # ** nixConfig
    # #+begin_src nix :noweb-ref nixConfig
    # experimental-features = \[ "nix-command" "flakes" \];
    # # nix community's cache server
    # extra-substituters = \[
    #  "https:/nix-community.cachix.org"
    #  "https:/nixpkgs-wayland.cachix.org"
    #  "https:/anyrun.cachix.org"
    #  "https:/cuda-maintainers.cachix.org"
    # \];
    # extra-trusted-public-keys = \[
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #  "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    #  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    # \];
    
    # #+end_src
    
    # #+RESULTS:
    
    # ** Inputs
    # #+begin_src nix :noweb-ref inputs
    # ## nixpkgs
    # nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # home-manager = {
    #  url = "github:nix-community/home-manager";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    
    # utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    # nur.url = "github:nix-community/NUR";
    # mynur.url = "github:A7R7/nur-packages";
    # # mynur.url = "git+file:./?dir=./nurpkgs";
    # # mynur.url = "./nurpkgs";
    # # hyprland wm
    # hyprland.url = "github:hyprwm/Hyprland";
    # pyprland.url = "github:A7R7/pyprland";
    # ags.url = "github:Aylur/ags";
    # # ags.url = "github:Aylur/ags/feat/widgets-subclass-rewrite";
    # musnix.url = "github:musnix/musnix";
    # pip2nix.url = "github:nix-community/pip2nix";
    # emacs.url = "github:nix-community/emacs-overlay";
    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    #  #+end_src
    # ** Outputs
    # #+begin_src nix :noweb-ref outputs
    #  inputs@{
    #  self,
    #  nixpkgs,
    #  home-manager,
    #  ... }:
    #  let
    #  username = "aaron";
    #  system = "x86_64-linux";
    #  pkgs = import nixpkgs {
    #  inherit system;
    #  config.allowUnfree = true;
    #  overlays = with inputs; \[
    #  nur.overlay
    #  mynur.overlay
    #  emacs.overlay
    #  (final: prev: { v2305 = import inputs.nixpkgs-2305 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  (final: prev: { v2311 = import inputs.nixpkgs-2311 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  \];
    #  };
    #  in
    #  {
    #  nixosConfigurations = {
    #  Omen16 = nixpkgs.lib.nixosSystem {
    #  system = "x86_64-linux";
    #  specialArgs = { inherit inputs username system pkgs; };
    #  modules = \[ ./host/configuration.nix ./host/omen16.nix\];
    #  };
    #  };
    #  homeConfigurations = {
    #  aaron = home-manager.lib.homeManagerConfiguration {
    #  inherit pkgs;
    #  extraSpecialArgs = { inherit inputs username pkgs; };
    #  modules = \[ ./home/home.nix \];
    #  };
    #  };
    #  };
    
    # #+end_src
    
    # #+RESULTS:
    
    # * Host
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref host-config
    # :END:
    # #+begin_src nix :tangle host/configuration.nix :comments noweb :noweb no-export :noweb-ref no
    #  { config, pkgs, lib, inputs, username, ... }:
    #  {
    #  imports =
    #  \[
    #  /etc/nixos/hardware-configuration.nix
    #  inputs.musnix.nixosModules.musnix
    #  \];
    #  <<host-config>>
    #  }
    # #+end_src
    # ** Nix
    # #+begin_src nix
    #  system.stateVersion = "23.11";
    #  nixpkgs.config.allowUnfree = true;
    #  nix = {
    #  # This will add each flake input as a registry
    #  # To make nix3 commands consistent with your flake
    #  registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    
    #  # This will additionally add your inputs to the system's legacy channels
    #  # Making legacy nix commands consistent as well, awesome!
    #  nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    
    #  settings = {
    #  experimental-features = "nix-command flakes";
    #  auto-optimise-store = true;
    #  trusted-users = \[ "${username}" \];
    #  };
    #  };
    # #+end_src
    
    # ** Boot
    # \[\[file:/etc/nixos/hardware-configuration.nix\]\[/etc/nixos/hardware-configuration.nix\]\]
    # #+begin_src nix
    # boot = {
    #  loader = {
    #  # systemd-boot.enable = true;
    #  grub = {
    #  enable = true;
    #  theme = pkgs.mynur.xenlism-grub-4k-nixos;
    #  splashMode = "normal";
    #  efiSupport = true;
    #  useOSProber = true;
    #  };
    #  efi.canTouchEfiVariables = true;
    #  efi.efiSysMountPoint = "/boot";
    #  timeout = 10;
    #  };
    # };
    # #+end_src
    # ** Network & hostname
    # #+begin_src nix
    #  networking = {
    #  networkmanager.enable = true;
    #  };
    # #+end_src
    # ** Sound
    # #+begin_src nix
    #  musnix.enable = true;
    #  sound.enable = false; # sound.enable is only meant for ALSA-based configurations
    #  hardware.pulseaudio.enable = false;
    #  hardware.bluetooth.enable = true;
    #  security.rtkit.enable = true;
    #  services. pipewire = {
    #  enable = true;
    #  alsa.enable = true;
    #  alsa.support32Bit = true;
    #  pulse.enable = true;
    #  jack.enable = true;
    #  };
    # #+end_src
    # ** Locale
    # #+begin_src nix
    #  time.timeZone = "Asia/Shanghai";
    #  i18n = {
    #  defaultLocale = "en_US.UTF-8";
    #  supportedLocales = \[
    #  "en_US.UTF-8/UTF-8"
    #  "zh_CN.UTF-8/UTF-8"
    #  \];
    #  };
    #  console = {
    #  font = "Lat2-Terminus16";
    #  useXkbConfig = true; # use xkbOptions in tty.
    #  };
    
    
    # #+end_src
    # ** User
    
    # #+begin_src nix
    #  # Define a user account. Don't forget to set a password with ‘passwd’.
    #  users.users.${username} = {
    #  isNormalUser = true;
    #  extraGroups = \[ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"\];
    #  # shell = pkgs.elvish;
    #  };
    # #+end_src
    
    # ** Pkgs
    # #+begin_src nix
    # environment.systemPackages = with pkgs; \[
    #  vim neovim
    #  wget
    #  curl
    #  git
    #  stow
    #  man
    #  efibootmgr
    #  gnumake
    #  killall
    #  home-manager
    #  dash elvish fish nushell tcsh xonsh zsh
    #  sddm-chili-theme
    # \];
    #  #+end_src
    # *** Shells
    # Shells. Yeah I'd like to try different shells.
    # #+begin_src nix
    # environment.shells = with pkgs; \[
    #  dash elvish fish nushell tcsh xonsh zsh
    # \];
    # #+end_src
    # This adds ~~/.local/bin~ to PATH.
    # #+begin_src nix
    # environment.localBinInPath = true;
    # #+end_src
    
    # ** Virtualisation
    # #+begin_src nix
    #  virtualisation = {
    #  podman.enable = true;
    #  libvirtd.enable = true;
    #  waydroid.enable = true;
    #  };
    # #+end_src
    # ** Programs
    # #+begin_src nix
    # # programs.regreet = {
    # # This line installs ReGreet,
    # # sets up systemd tmpfiles for it,
    # # enables services.greetd and also configures its default session to start ReGreet using cage.
    # # enable = true;
    # # };
    
    # #+end_src
    # *** Window managers
    # #+begin_src nix
    # #+end_src
    
    # #+begin_src nix
    # programs.hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  # enableNvidiaPatches = false; # deprecated
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.wayfire = {
    #  enable = true;
    #  package = pkgs.mynur.wayfire;
    #  plugins = (with pkgs.wayfirePlugins; \[
    #  wcm
    #  wf-shell
    #  wayfire-plugins-extra
    #  \]) ++ \[
    #  pkgs.mynur.swayfire
    #  \];
    # };
    # environment.sessionVariables.WAYFIRE_CONFIG_FILE = "$HOME/.config/wayfire/wayfire.ini";
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # programs.steam = {
    #  enable = true;
    #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # };
    # #+end_src
    
    # #+begin_src nix
    # xdg.portal = {
    #  enable = true;
    #  wlr.enable = true;
    #  # extraPortals = \[ pkgs.xdg-desktop-portal-gtk \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.adb.enable = true;
    # programs.dconf.enable = true;
    # #+end_src
    # ** Fonts
    # #+begin_src nix
    #  fonts.fonts = with pkgs; \[
    #  noto-fonts
    #  noto-fonts-cjk
    #  roboto roboto-serif
    #  sarasa-gothic
    #  \];
    #  fonts.fontconfig = {
    #  enable = true;
    #  includeUserConf = true;
    #  allowBitmaps = false;
    #  };
    # #+end_src
    # ** Services
    # *** COMMENT Greetd
    # #+begin_src nix
    #  services.greetd = {
    #  enable = true;
    #  settings = rec {
    #  initial_session = {
    #  command = "${pkgs.hyprland}/bin/Hyprland";
    #  user = "${username}";
    #  };
    #  default_session = initial_session;
    #  };
    #  };
    # #+end_src
    # *** Xserver
    #  #+begin_src nix
    #  services.xserver.enable = true;
    #  services.xserver.excludePackages = \[ pkgs.xterm \];
    #  services.xserver.layout = "us";
    #  services.xserver.xkbOptions = "caps:escape";
    #  # services.xserver.displayManager.gdm.enable = true;
    #  services.xserver.displayManager.sddm = {
    #  enable = true;
    #  # wayland.enable = true;
    #  theme = "chili";
    #  };
    #  # displayManager.lightdm.enable = true;
    #  # displayManager.lightdm.greeters.slick.enable = true;
    #  # desktopManager.gnome.enable = true;
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # services.tlp.enable = true;
    # services.printing.enable = true;
    # services.flatpak.enable = true;
    # services.openssh.enable = true;
    # # userspace virtual filesystem
    # services.gvfs.enable = true;
    # # an automatic device mounting daemon
    # services.devmon.enable = true;
    # # a DBus service that allows applications to query and manipulate storage devices.
    # services.udisks2.enable = true;
    # # a DBus service that provides power management support to applications.
    # services.upower.enable = true;
    # # a DBus service for accessing the list of user accounts and information attached to those accounts.
    # services.accounts-daemon.enable = true;
    #  #+end_src
    # *** GNOME
    # #+begin_src nix
    #  services.gnome = {
    #  evolution-data-server.enable = true;
    #  glib-networking.enable = true;
    #  gnome-keyring.enable = true;
    #  gnome-online-accounts.enable = true;
    #  at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
    #  };
    # #+end_src
    
    # *** DAE
    # #+begin_src nix
    #  services.dae = {
    #  enable = true;
    #  configFile = "/home/${username}/.config/dae/config.dae";
    #  };
    # #+end_src
    # *** Syncthing
    # \[\[https:/github.com/syncthing/syncthing\]\[Syncthing\]\] is a continuouts file synchronization program using UPnP, which synchronize files *WITHOUT* centralized services.
    # #+begin_src nix
    #  services.syncthing = {
    #  enable = true;
    #  openDefaultPorts = true; # 22000/TCP and 22000/UDP
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #  user = "${username}";
    #  group = "users";
    #  # guiAdd.0:8384"; # To be able to access the web GUI
    #  };
    # #+end_src
    # *** Blueman
    # #+begin_src nix
    # services.blueman.enable = true;
    # #+end_src
    # ** Security
    # Polkit is used for controlling system-wide privileges. It provides an organized way for non-privileged processes to communicate with privileged ones, especially for those GUI applications.
    # #+begin_src nix
    #  security.polkit.enable = true;
    #  # start polkit on login by creating a systemd user service
    #  #+end_src
    # * Home
    # Becareful that packages installed by ~nix profile install~ can conflict with packages defined here! Therefore, it is recommended to clear nix profile list before home-manager switch.
    # ** Config
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref hm-config
    # :END:
    # #+begin_src nix :tangle home/home.nix :comments noweb :noweb no-export :noweb-ref no
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
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ... }:
    let
      username = "aaron";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = with inputs; [
          nur.overlay
          mynur.overlay
          emacs.overlay
          (final: prev: { v2305 = import inputs.nixpkgs-2305 {
              inherit system;
              config.allowUnfree = true;
          };})
          (final: prev: { v2311 = import inputs.nixpkgs-2311 {
              inherit system;
              config.allowUnfree = true;
          };})
        ];
      };
    in
      {
      nixosConfigurations = {
        Omen16 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs username system pkgs; };
          modules = [ ./host/configuration.nix ./host/omen16.nix];
        };
      };
    	homeConfigurations = {
        aaron = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs username pkgs; };
          modules = [ ./home/home.nix ];
        };
      };
    };
    
    # ends here
}
# Flake:1 ends here
