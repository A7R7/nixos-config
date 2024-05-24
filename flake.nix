# [[file:nixos.org::+begin_src nix :tangle flake.nix :noweb no-export
# {
#  description = "A7R7's NixOS Flake";
#  nixConfig = {
#  <<nixConfig>>
#  };
#  inputs = {
#  <<inputs>>
#  };
#  outputs =
#  <<outputs>>
# }
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
#  "https:/hyprland.cachix.org"
#  "https:/niri.cachix.org"
# \];
# extra-trusted-public-keys = \[
#  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
#  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
#  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
#  "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
#  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
#  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
#  "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
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
# mynur = {
#  url = "github:A7R7/nur-packages";
#  inputs.nixpkgs.follows = "nixpkgs";
# };
# # mynur.url = "git+file:./?dir=./nurpkgs";
# # mynur.url = "./nurpkgs";
# # hyprland wm
# hyprland.url = "git+https:/github.com/hyprwm/Hyprland?submodules=1";
# pyprland.url = "github:A7R7/pyprland";
# niri.url = "github:sodiboo/niri-flake";
# swayfx.url = "github:WillPower3309/swayfx";
# ags.url = "github:Aylur/ags";
# astal.url = "github:Aylur/Astal";
# musnix.url = "github:musnix/musnix";
# pip2nix.url = "github:nix-community/pip2nix";
# emacs.url = "github:nix-community/emacs-overlay";
# anyrun.url = "github:Kirottu/anyrun";
# anyrun.inputs.nixpkgs.follows = "nixpkgs";
# nbfc = {
#  url = "github:nbfc-linux/nbfc-linux";
#  inputs.nixpkgs.follows = "nixpkgs";
# };
#  #+end_src
# ** Outputs
# #+begin_src nix :noweb-ref outputs
# inputs@{
#  self,
#  nixpkgs,
#  home-manager,
#  ... }:
# let
#  username = "aaron";
#  system = "x86_64-linux";
#  pkgs = import nixpkgs {
#  inherit system;
#  config = {
#  allowUnfree = true;
#  cudaSupport = true;
#  cudaVersion = "12";
#  };
#  overlays = with inputs; \[
#  nur.overlay
#  mynur.overlay
#  emacs.overlay
#  niri.overlays.niri
#  swayfx.overlays.default
#  (final: prev: { v2311 = import inputs.nixpkgs-2311 {
#  inherit system;
#  config.allowUnfree = true;
#  };})
#  \];
#  };
# in
# {
#  nixosConfigurations = {
#  Omen16 = nixpkgs.lib.nixosSystem {
#  system = "x86_64-linux";
#  specialArgs = { inherit inputs username system pkgs; };
#  modules = \[
#  ./host/configuration.nix
#  ./host/omen16.nix
#  # home-manager.nixosModules.home-manager
#  # {
#  # home-manager.useGlobalPkgs = true;
#  # home-manager.useUserPackages = true;
#  # home-manager.users.aaron = import ./home/home.nix;
#  # home-manager.extraSpecialArgs = { inherit inputs username pkgs; };
#  # }
#  \];
#  };
#  };
#  homeConfigurations = {
#  aaron = home-manager.lib.homeManagerConfiguration {
#  inherit pkgs;
#  extraSpecialArgs = { inherit inputs username pkgs; };
#  modules = \[ ./home/home.nix \];
#  };
#  };
# };

# #+end_src

# #+RESULTS:

# * Host
# :PROPERTIES:
# :header-args:nix: :noweb-ref host-config
# :END:
# #+begin_src nix :tangle host/configuration.nix :noweb no-export :noweb-ref no
# { config, pkgs, lib, inputs, username, system, ... }:
# {
#  imports =
#  \[
#  /etc/nixos/hardware-configuration.nix
#  inputs.musnix.nixosModules.musnix
#  inputs.niri.nixosModules.niri
#  \];
#  <<host-config>>
# }
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
# networking = {
#  networkmanager.enable = true;
# };
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
# # Define a user account. Don't forget to set a password with ‘passwd’.
# users.users.${username} = {
#  isNormalUser = true;
#  extraGroups = \[ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"\];
#  # shell = pkgs.elvish;
# };
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
#  hicolor-icon-theme
#  inputs.nbfc.packages.${system}.default
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
# virtualisation = {
#  podman.enable = true;
#  libvirtd.enable = true;
#  waydroid.enable = true;
#  # virtualbox.host.enable = true;
#  # virtualbox.host.enableExtensionPack = true;
#  # virtualbox.guest.enable = true;
#  # virtualbox.guest.x11 = true;
#  # vmware.host.enable = true;
#  # vmware.guest.enable = true;
# };
# users.extraGroups.vboxusers.members = \[ "user-with-access-to-virtualbox" \];
# #+end_src
# ** Programs

# *** Shell
# #+begin_src nix
# programs.bash = {
#  interactiveShellInit = ''
#  if \[\[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} \]\]
#  then
#  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
#  exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
#  fi
#  ''; # launches fish unless the parent process is already fish
# };
# #+end_src
# *** Window managers
# #+begin_src nix
# services.xserver.desktopManager.gnome.enable = true;
# services.gnome = {
#  evolution-data-server.enable = true;
#  glib-networking.enable = true;
#  gnome-keyring.enable = true;
#  gnome-online-accounts.enable = true;
#  at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
# };
# #+end_src


# #+begin_src nix
# programs.hyprland = {
#  enable = true;
#  xwayland.enable = true;
#  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
#  # enableNvidiaPatches = false; # deprecated
# };
# #+end_src

# #+begin_src nix
# programs.wayfire = {
#  enable = true;
#  # package = pkgs.mynur.wayfire;
#  plugins = (with pkgs.wayfirePlugins; \[
#  wcm
#  wf-shell
#  wayfire-plugins-extra
#  \]);
#  # ++ \[
#  # pkgs.mynur.swayfire
#  # \];
# };
# #+end_src

# #+begin_src nix
# programs.niri = {
#  enable = true;
#  package = pkgs.niri-stable;
# };
# #+end_src

# #+begin_src nix
# programs.sway = {
#  enable = true;
#  package = pkgs.swayfx;
#  # wrapperFeatures.gtk = true;
# };
# #+end_src
# *** Misc
# #+begin_src nix
# programs.steam = {
#  enable = true;
#  # package = pkgs.v2311.steam;
#  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
#  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
# };
# #+end_src


# #+begin_src nix
# programs.adb.enable = true;
# programs.dconf.enable = true;
# #+end_src
# *** Xdg
# #+begin_src nix
# xdg.portal = {
#  enable = true;
#  wlr.enable = true;
#  # extraPortals = \[ pkgs.xdg-desktop-portal-gtk \];
# };
# #+end_src

# #+begin_src nix
# # xdg.mimeApps.defaultApplications = {
# # "mp4" = \[ "umpv.desktop" "mpv.desktop" \];
# # "png" = \[ "feh.desktop"\]
# # }
# #+end_src
# ** Fonts
# #+begin_src nix
# fonts.packages = with pkgs; \[
#  noto-fonts
#  noto-fonts-cjk
#  sarasa-gothic
# \];
# fonts.fontconfig = {
#  enable = true;
#  includeUserConf = true;
#  allowBitmaps = false;
#  hinting.enable = false;
# };
# #+end_src
# ** Services
# *** COMMENT Greetd
# #+begin_src nix
# services.greetd = {
#  enable = true;
# };
# #+end_src

# #+begin_src nix
# programs.regreet = {
#  enable = false;
# };
# #+end_src
# *** Xserver
# #+begin_src nix
# services.xserver.enable = true;
# services.xserver.excludePackages = \[ pkgs.xterm \];
# services.xserver.xkb.layout = "us";
# services.xserver.xkb.options = "caps:escape";
# # services.displayManager.gdm.enable = true;
# services.displayManager.sddm = {
#  enable = true;
#  theme = "chili";
# };
# # displayManager.lightdm.enable = true;
# # displayManager.lightdm.greeters.slick.enable = true;
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
# services.syncthing = {
#  enable = true;
#  openDefaultPorts = true; # 22000/TCP and 22000/UDP
#  dataDir = "/home/${username}";
#  configDir = "/home/${username}/.config/syncthing";
#  user = "${username}";
#  group = "users";
#  # guiAdd.0:8384"; # To be able to access the web GUI
# };
# #+end_src
# *** Blueman
# #+begin_src nix
# services.blueman.enable = true;
# #+end_src
# *** COMMENT Jtag
# for vivado to link to board.
# #+begin_src nix
# services.udev.packages = \[
#  (pkgs.writeTextFile {
#  name = "xilinx-dilligent-usb-udev";
#  destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
#  text = ''
#  ATTR{idVendor}=="1443", MODE:="666"
#  ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
#  '';
#  })
#  (pkgs.writeTextFile {
#  name = "xilinx-pcusb-udev";
#  destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
#  text = ''
#  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
#  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
#  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
#  ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
#  ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
#  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
#  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
#  '';
#  })
#  (pkgs.writeTextFile {
#  name = "xilinx-ftdi-usb-udev";
#  destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
#  text = ''
#  ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
#  '';
#  })
# \];
# #+end_src
# *** Print
# #+begin_src nix
# services.printing.enable = true;
# services.printing.drivers = \[ pkgs.hplipWithPlugin \];
# services.avahi = {
#  enable = true;
#  nssmdns4 = true;
#  openFirewall = true;
# };
# #+end_src
# *** Ollama
# #+begin_src nix
# services.ollama.enable = true;
# #+end_src
# *** COMMENT NBFC
# Notebook fancontrol
# #+begin_src nix :tangle no
# systemd.services.nbfc_service = {
#  enable = true;
#  description = "NoteBook FanControl service";
#  serviceConfig.Type = "simple";
#  path = \[ pkgs.kmod \];
#  script = let nbfc = inputs.nbfc.defaultPackage.${system}; in
#  "${nbfc}/bin/nbfc_service --config-file '/home/${username}/.config/nbfc.json'";
#  wantedBy = \[ "multi-user.target" \];
# };
# #+end_src
# *** Misc
# #+begin_src nix
# services.flatpak.enable = true;
# services.openssh.enable = true;
# # userspace virtual filesystem
# services.gvfs.enable = true;
# # an automatic device mounting daemon
# services.devmon.enable = true;
# # allows applications to query and manipulate storage devices.
# services.udisks2.enable = true;
# # a DBus service for accessing the list of user accounts and information attached to those accounts.
# # services.accounts-daemon.enable = true;
# services.ratbagd.enable = true; # configuring gamming mouse
#  #+end_src
# ** Power management

# #+begin_src nix
# # a DBus service that provides power management support to applications.
# services.upower.enable = true;
# services.tlp = {
#  enable =][Flake:1]]
{
  description = "A7R7's NixOS Flake";
  nixConfig = {
    # [[file:nixos.org::+begin_src nix :tangle flake.nix :noweb no-export
    # {
    #  description = "A7R7's NixOS Flake";
    #  nixConfig = {
    #  <<nixConfig>>
    #  };
    #  inputs = {
    #  <<inputs>>
    #  };
    #  outputs =
    #  <<outputs>>
    # }
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
    #  "https:/hyprland.cachix.org"
    #  "https:/niri.cachix.org"
    # \];
    # extra-trusted-public-keys = \[
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #  "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    #  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    #  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    #  "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
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
    # mynur = {
    #  url = "github:A7R7/nur-packages";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    # # mynur.url = "git+file:./?dir=./nurpkgs";
    # # mynur.url = "./nurpkgs";
    # # hyprland wm
    # hyprland.url = "git+https:/github.com/hyprwm/Hyprland?submodules=1";
    # pyprland.url = "github:A7R7/pyprland";
    # niri.url = "github:sodiboo/niri-flake";
    # swayfx.url = "github:WillPower3309/swayfx";
    # ags.url = "github:Aylur/ags";
    # astal.url = "github:Aylur/Astal";
    # musnix.url = "github:musnix/musnix";
    # pip2nix.url = "github:nix-community/pip2nix";
    # emacs.url = "github:nix-community/emacs-overlay";
    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    # nbfc = {
    #  url = "github:nbfc-linux/nbfc-linux";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    #  #+end_src
    # ** Outputs
    # #+begin_src nix :noweb-ref outputs
    # inputs@{
    #  self,
    #  nixpkgs,
    #  home-manager,
    #  ... }:
    # let
    #  username = "aaron";
    #  system = "x86_64-linux";
    #  pkgs = import nixpkgs {
    #  inherit system;
    #  config = {
    #  allowUnfree = true;
    #  cudaSupport = true;
    #  cudaVersion = "12";
    #  };
    #  overlays = with inputs; \[
    #  nur.overlay
    #  mynur.overlay
    #  emacs.overlay
    #  niri.overlays.niri
    #  swayfx.overlays.default
    #  (final: prev: { v2311 = import inputs.nixpkgs-2311 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  \];
    #  };
    # in
    # {
    #  nixosConfigurations = {
    #  Omen16 = nixpkgs.lib.nixosSystem {
    #  system = "x86_64-linux";
    #  specialArgs = { inherit inputs username system pkgs; };
    #  modules = \[
    #  ./host/configuration.nix
    #  ./host/omen16.nix
    #  # home-manager.nixosModules.home-manager
    #  # {
    #  # home-manager.useGlobalPkgs = true;
    #  # home-manager.useUserPackages = true;
    #  # home-manager.users.aaron = import ./home/home.nix;
    #  # home-manager.extraSpecialArgs = { inherit inputs username pkgs; };
    #  # }
    #  \];
    #  };
    #  };
    #  homeConfigurations = {
    #  aaron = home-manager.lib.homeManagerConfiguration {
    #  inherit pkgs;
    #  extraSpecialArgs = { inherit inputs username pkgs; };
    #  modules = \[ ./home/home.nix \];
    #  };
    #  };
    # };
    
    # #+end_src
    
    # #+RESULTS:
    
    # * Host
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref host-config
    # :END:
    # #+begin_src nix :tangle host/configuration.nix :noweb no-export :noweb-ref no
    # { config, pkgs, lib, inputs, username, system, ... }:
    # {
    #  imports =
    #  \[
    #  /etc/nixos/hardware-configuration.nix
    #  inputs.musnix.nixosModules.musnix
    #  inputs.niri.nixosModules.niri
    #  \];
    #  <<host-config>>
    # }
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
    # networking = {
    #  networkmanager.enable = true;
    # };
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
    # # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.users.${username} = {
    #  isNormalUser = true;
    #  extraGroups = \[ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"\];
    #  # shell = pkgs.elvish;
    # };
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
    #  hicolor-icon-theme
    #  inputs.nbfc.packages.${system}.default
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
    # virtualisation = {
    #  podman.enable = true;
    #  libvirtd.enable = true;
    #  waydroid.enable = true;
    #  # virtualbox.host.enable = true;
    #  # virtualbox.host.enableExtensionPack = true;
    #  # virtualbox.guest.enable = true;
    #  # virtualbox.guest.x11 = true;
    #  # vmware.host.enable = true;
    #  # vmware.guest.enable = true;
    # };
    # users.extraGroups.vboxusers.members = \[ "user-with-access-to-virtualbox" \];
    # #+end_src
    # ** Programs
    
    # *** Shell
    # #+begin_src nix
    # programs.bash = {
    #  interactiveShellInit = ''
    #  if \[\[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} \]\]
    #  then
    #  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #  exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #  fi
    #  ''; # launches fish unless the parent process is already fish
    # };
    # #+end_src
    # *** Window managers
    # #+begin_src nix
    # services.xserver.desktopManager.gnome.enable = true;
    # services.gnome = {
    #  evolution-data-server.enable = true;
    #  glib-networking.enable = true;
    #  gnome-keyring.enable = true;
    #  gnome-online-accounts.enable = true;
    #  at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
    # };
    # #+end_src
    
    
    # #+begin_src nix
    # programs.hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #  # enableNvidiaPatches = false; # deprecated
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.wayfire = {
    #  enable = true;
    #  # package = pkgs.mynur.wayfire;
    #  plugins = (with pkgs.wayfirePlugins; \[
    #  wcm
    #  wf-shell
    #  wayfire-plugins-extra
    #  \]);
    #  # ++ \[
    #  # pkgs.mynur.swayfire
    #  # \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.niri = {
    #  enable = true;
    #  package = pkgs.niri-stable;
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.sway = {
    #  enable = true;
    #  package = pkgs.swayfx;
    #  # wrapperFeatures.gtk = true;
    # };
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # programs.steam = {
    #  enable = true;
    #  # package = pkgs.v2311.steam;
    #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # };
    # #+end_src
    
    
    # #+begin_src nix
    # programs.adb.enable = true;
    # programs.dconf.enable = true;
    # #+end_src
    # *** Xdg
    # #+begin_src nix
    # xdg.portal = {
    #  enable = true;
    #  wlr.enable = true;
    #  # extraPortals = \[ pkgs.xdg-desktop-portal-gtk \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # # xdg.mimeApps.defaultApplications = {
    # # "mp4" = \[ "umpv.desktop" "mpv.desktop" \];
    # # "png" = \[ "feh.desktop"\]
    # # }
    # #+end_src
    # ** Fonts
    # #+begin_src nix
    # fonts.packages = with pkgs; \[
    #  noto-fonts
    #  noto-fonts-cjk
    #  sarasa-gothic
    # \];
    # fonts.fontconfig = {
    #  enable = true;
    #  includeUserConf = true;
    #  allowBitmaps = false;
    #  hinting.enable = false;
    # };
    # #+end_src
    # ** Services
    # *** COMMENT Greetd
    # #+begin_src nix
    # services.greetd = {
    #  enable = true;
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.regreet = {
    #  enable = false;
    # };
    # #+end_src
    # *** Xserver
    # #+begin_src nix
    # services.xserver.enable = true;
    # services.xserver.excludePackages = \[ pkgs.xterm \];
    # services.xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "caps:escape";
    # # services.displayManager.gdm.enable = true;
    # services.displayManager.sddm = {
    #  enable = true;
    #  theme = "chili";
    # };
    # # displayManager.lightdm.enable = true;
    # # displayManager.lightdm.greeters.slick.enable = true;
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
    # services.syncthing = {
    #  enable = true;
    #  openDefaultPorts = true; # 22000/TCP and 22000/UDP
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #  user = "${username}";
    #  group = "users";
    #  # guiAdd.0:8384"; # To be able to access the web GUI
    # };
    # #+end_src
    # *** Blueman
    # #+begin_src nix
    # services.blueman.enable = true;
    # #+end_src
    # *** COMMENT Jtag
    # for vivado to link to board.
    # #+begin_src nix
    # services.udev.packages = \[
    #  (pkgs.writeTextFile {
    #  name = "xilinx-dilligent-usb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
    #  text = ''
    #  ATTR{idVendor}=="1443", MODE:="666"
    #  ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
    #  '';
    #  })
    #  (pkgs.writeTextFile {
    #  name = "xilinx-pcusb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
    #  text = ''
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
    #  '';
    #  })
    #  (pkgs.writeTextFile {
    #  name = "xilinx-ftdi-usb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
    #  text = ''
    #  ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
    #  '';
    #  })
    # \];
    # #+end_src
    # *** Print
    # #+begin_src nix
    # services.printing.enable = true;
    # services.printing.drivers = \[ pkgs.hplipWithPlugin \];
    # services.avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    # };
    # #+end_src
    # *** Ollama
    # #+begin_src nix
    # services.ollama.enable = true;
    # #+end_src
    # *** COMMENT NBFC
    # Notebook fancontrol
    # #+begin_src nix :tangle no
    # systemd.services.nbfc_service = {
    #  enable = true;
    #  description = "NoteBook FanControl service";
    #  serviceConfig.Type = "simple";
    #  path = \[ pkgs.kmod \];
    #  script = let nbfc = inputs.nbfc.defaultPackage.${system}; in
    #  "${nbfc}/bin/nbfc_service --config-file '/home/${username}/.config/nbfc.json'";
    #  wantedBy = \[ "multi-user.target" \];
    # };
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # services.flatpak.enable = true;
    # services.openssh.enable = true;
    # # userspace virtual filesystem
    # services.gvfs.enable = true;
    # # an automatic device mounting daemon
    # services.devmon.enable = true;
    # # allows applications to query and manipulate storage devices.
    # services.udisks2.enable = true;
    # # a DBus service for accessing the list of user accounts and information attached to those accounts.
    # # services.accounts-daemon.enable = true;
    # services.ratbagd.enable = true; # configuring gamming mouse
    #  #+end_src
    # ** Power management
    
    # #+begin_src nix
    # # a DBus service that provides power management support to applications.
    # services.upower.enable = true;
    # services.tlp = {
    #  enable =][]]
    experimental-features = [ "nix-command" "flakes" ];
    # nix community's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://anyrun.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://hyprland.cachix.org"
      "https://niri.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
    
    # ends here
  };
  inputs = {
    # [[file:nixos.org::+begin_src nix :tangle flake.nix :noweb no-export
    # {
    #  description = "A7R7's NixOS Flake";
    #  nixConfig = {
    #  <<nixConfig>>
    #  };
    #  inputs = {
    #  <<inputs>>
    #  };
    #  outputs =
    #  <<outputs>>
    # }
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
    #  "https:/hyprland.cachix.org"
    #  "https:/niri.cachix.org"
    # \];
    # extra-trusted-public-keys = \[
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #  "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    #  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    #  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    #  "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
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
    # mynur = {
    #  url = "github:A7R7/nur-packages";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    # # mynur.url = "git+file:./?dir=./nurpkgs";
    # # mynur.url = "./nurpkgs";
    # # hyprland wm
    # hyprland.url = "git+https:/github.com/hyprwm/Hyprland?submodules=1";
    # pyprland.url = "github:A7R7/pyprland";
    # niri.url = "github:sodiboo/niri-flake";
    # swayfx.url = "github:WillPower3309/swayfx";
    # ags.url = "github:Aylur/ags";
    # astal.url = "github:Aylur/Astal";
    # musnix.url = "github:musnix/musnix";
    # pip2nix.url = "github:nix-community/pip2nix";
    # emacs.url = "github:nix-community/emacs-overlay";
    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    # nbfc = {
    #  url = "github:nbfc-linux/nbfc-linux";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    #  #+end_src
    # ** Outputs
    # #+begin_src nix :noweb-ref outputs
    # inputs@{
    #  self,
    #  nixpkgs,
    #  home-manager,
    #  ... }:
    # let
    #  username = "aaron";
    #  system = "x86_64-linux";
    #  pkgs = import nixpkgs {
    #  inherit system;
    #  config = {
    #  allowUnfree = true;
    #  cudaSupport = true;
    #  cudaVersion = "12";
    #  };
    #  overlays = with inputs; \[
    #  nur.overlay
    #  mynur.overlay
    #  emacs.overlay
    #  niri.overlays.niri
    #  swayfx.overlays.default
    #  (final: prev: { v2311 = import inputs.nixpkgs-2311 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  \];
    #  };
    # in
    # {
    #  nixosConfigurations = {
    #  Omen16 = nixpkgs.lib.nixosSystem {
    #  system = "x86_64-linux";
    #  specialArgs = { inherit inputs username system pkgs; };
    #  modules = \[
    #  ./host/configuration.nix
    #  ./host/omen16.nix
    #  # home-manager.nixosModules.home-manager
    #  # {
    #  # home-manager.useGlobalPkgs = true;
    #  # home-manager.useUserPackages = true;
    #  # home-manager.users.aaron = import ./home/home.nix;
    #  # home-manager.extraSpecialArgs = { inherit inputs username pkgs; };
    #  # }
    #  \];
    #  };
    #  };
    #  homeConfigurations = {
    #  aaron = home-manager.lib.homeManagerConfiguration {
    #  inherit pkgs;
    #  extraSpecialArgs = { inherit inputs username pkgs; };
    #  modules = \[ ./home/home.nix \];
    #  };
    #  };
    # };
    
    # #+end_src
    
    # #+RESULTS:
    
    # * Host
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref host-config
    # :END:
    # #+begin_src nix :tangle host/configuration.nix :noweb no-export :noweb-ref no
    # { config, pkgs, lib, inputs, username, system, ... }:
    # {
    #  imports =
    #  \[
    #  /etc/nixos/hardware-configuration.nix
    #  inputs.musnix.nixosModules.musnix
    #  inputs.niri.nixosModules.niri
    #  \];
    #  <<host-config>>
    # }
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
    # networking = {
    #  networkmanager.enable = true;
    # };
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
    # # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.users.${username} = {
    #  isNormalUser = true;
    #  extraGroups = \[ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"\];
    #  # shell = pkgs.elvish;
    # };
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
    #  hicolor-icon-theme
    #  inputs.nbfc.packages.${system}.default
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
    # virtualisation = {
    #  podman.enable = true;
    #  libvirtd.enable = true;
    #  waydroid.enable = true;
    #  # virtualbox.host.enable = true;
    #  # virtualbox.host.enableExtensionPack = true;
    #  # virtualbox.guest.enable = true;
    #  # virtualbox.guest.x11 = true;
    #  # vmware.host.enable = true;
    #  # vmware.guest.enable = true;
    # };
    # users.extraGroups.vboxusers.members = \[ "user-with-access-to-virtualbox" \];
    # #+end_src
    # ** Programs
    
    # *** Shell
    # #+begin_src nix
    # programs.bash = {
    #  interactiveShellInit = ''
    #  if \[\[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} \]\]
    #  then
    #  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #  exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #  fi
    #  ''; # launches fish unless the parent process is already fish
    # };
    # #+end_src
    # *** Window managers
    # #+begin_src nix
    # services.xserver.desktopManager.gnome.enable = true;
    # services.gnome = {
    #  evolution-data-server.enable = true;
    #  glib-networking.enable = true;
    #  gnome-keyring.enable = true;
    #  gnome-online-accounts.enable = true;
    #  at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
    # };
    # #+end_src
    
    
    # #+begin_src nix
    # programs.hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #  # enableNvidiaPatches = false; # deprecated
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.wayfire = {
    #  enable = true;
    #  # package = pkgs.mynur.wayfire;
    #  plugins = (with pkgs.wayfirePlugins; \[
    #  wcm
    #  wf-shell
    #  wayfire-plugins-extra
    #  \]);
    #  # ++ \[
    #  # pkgs.mynur.swayfire
    #  # \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.niri = {
    #  enable = true;
    #  package = pkgs.niri-stable;
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.sway = {
    #  enable = true;
    #  package = pkgs.swayfx;
    #  # wrapperFeatures.gtk = true;
    # };
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # programs.steam = {
    #  enable = true;
    #  # package = pkgs.v2311.steam;
    #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # };
    # #+end_src
    
    
    # #+begin_src nix
    # programs.adb.enable = true;
    # programs.dconf.enable = true;
    # #+end_src
    # *** Xdg
    # #+begin_src nix
    # xdg.portal = {
    #  enable = true;
    #  wlr.enable = true;
    #  # extraPortals = \[ pkgs.xdg-desktop-portal-gtk \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # # xdg.mimeApps.defaultApplications = {
    # # "mp4" = \[ "umpv.desktop" "mpv.desktop" \];
    # # "png" = \[ "feh.desktop"\]
    # # }
    # #+end_src
    # ** Fonts
    # #+begin_src nix
    # fonts.packages = with pkgs; \[
    #  noto-fonts
    #  noto-fonts-cjk
    #  sarasa-gothic
    # \];
    # fonts.fontconfig = {
    #  enable = true;
    #  includeUserConf = true;
    #  allowBitmaps = false;
    #  hinting.enable = false;
    # };
    # #+end_src
    # ** Services
    # *** COMMENT Greetd
    # #+begin_src nix
    # services.greetd = {
    #  enable = true;
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.regreet = {
    #  enable = false;
    # };
    # #+end_src
    # *** Xserver
    # #+begin_src nix
    # services.xserver.enable = true;
    # services.xserver.excludePackages = \[ pkgs.xterm \];
    # services.xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "caps:escape";
    # # services.displayManager.gdm.enable = true;
    # services.displayManager.sddm = {
    #  enable = true;
    #  theme = "chili";
    # };
    # # displayManager.lightdm.enable = true;
    # # displayManager.lightdm.greeters.slick.enable = true;
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
    # services.syncthing = {
    #  enable = true;
    #  openDefaultPorts = true; # 22000/TCP and 22000/UDP
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #  user = "${username}";
    #  group = "users";
    #  # guiAdd.0:8384"; # To be able to access the web GUI
    # };
    # #+end_src
    # *** Blueman
    # #+begin_src nix
    # services.blueman.enable = true;
    # #+end_src
    # *** COMMENT Jtag
    # for vivado to link to board.
    # #+begin_src nix
    # services.udev.packages = \[
    #  (pkgs.writeTextFile {
    #  name = "xilinx-dilligent-usb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
    #  text = ''
    #  ATTR{idVendor}=="1443", MODE:="666"
    #  ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
    #  '';
    #  })
    #  (pkgs.writeTextFile {
    #  name = "xilinx-pcusb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
    #  text = ''
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
    #  '';
    #  })
    #  (pkgs.writeTextFile {
    #  name = "xilinx-ftdi-usb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
    #  text = ''
    #  ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
    #  '';
    #  })
    # \];
    # #+end_src
    # *** Print
    # #+begin_src nix
    # services.printing.enable = true;
    # services.printing.drivers = \[ pkgs.hplipWithPlugin \];
    # services.avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    # };
    # #+end_src
    # *** Ollama
    # #+begin_src nix
    # services.ollama.enable = true;
    # #+end_src
    # *** COMMENT NBFC
    # Notebook fancontrol
    # #+begin_src nix :tangle no
    # systemd.services.nbfc_service = {
    #  enable = true;
    #  description = "NoteBook FanControl service";
    #  serviceConfig.Type = "simple";
    #  path = \[ pkgs.kmod \];
    #  script = let nbfc = inputs.nbfc.defaultPackage.${system}; in
    #  "${nbfc}/bin/nbfc_service --config-file '/home/${username}/.config/nbfc.json'";
    #  wantedBy = \[ "multi-user.target" \];
    # };
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # services.flatpak.enable = true;
    # services.openssh.enable = true;
    # # userspace virtual filesystem
    # services.gvfs.enable = true;
    # # an automatic device mounting daemon
    # services.devmon.enable = true;
    # # allows applications to query and manipulate storage devices.
    # services.udisks2.enable = true;
    # # a DBus service for accessing the list of user accounts and information attached to those accounts.
    # # services.accounts-daemon.enable = true;
    # services.ratbagd.enable = true; # configuring gamming mouse
    #  #+end_src
    # ** Power management
    
    # #+begin_src nix
    # # a DBus service that provides power management support to applications.
    # services.upower.enable = true;
    # services.tlp = {
    #  enable =][]]
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
    mynur = {
      url = "github:A7R7/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # mynur.url = "git+file:./?dir=./nurpkgs";
    # mynur.url = "./nurpkgs";
    # hyprland wm
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    pyprland.url = "github:A7R7/pyprland";
    niri.url = "github:sodiboo/niri-flake";
    swayfx.url = "github:WillPower3309/swayfx";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/Astal";
    musnix.url = "github:musnix/musnix";
    pip2nix.url = "github:nix-community/pip2nix";
    emacs.url = "github:nix-community/emacs-overlay";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    nbfc = {
      url = "github:nbfc-linux/nbfc-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ends here
  };
  outputs =
    # [[file:nixos.org::+begin_src nix :tangle flake.nix :noweb no-export
    # {
    #  description = "A7R7's NixOS Flake";
    #  nixConfig = {
    #  <<nixConfig>>
    #  };
    #  inputs = {
    #  <<inputs>>
    #  };
    #  outputs =
    #  <<outputs>>
    # }
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
    #  "https:/hyprland.cachix.org"
    #  "https:/niri.cachix.org"
    # \];
    # extra-trusted-public-keys = \[
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #  "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    #  "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    #  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    #  "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
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
    # mynur = {
    #  url = "github:A7R7/nur-packages";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    # # mynur.url = "git+file:./?dir=./nurpkgs";
    # # mynur.url = "./nurpkgs";
    # # hyprland wm
    # hyprland.url = "git+https:/github.com/hyprwm/Hyprland?submodules=1";
    # pyprland.url = "github:A7R7/pyprland";
    # niri.url = "github:sodiboo/niri-flake";
    # swayfx.url = "github:WillPower3309/swayfx";
    # ags.url = "github:Aylur/ags";
    # astal.url = "github:Aylur/Astal";
    # musnix.url = "github:musnix/musnix";
    # pip2nix.url = "github:nix-community/pip2nix";
    # emacs.url = "github:nix-community/emacs-overlay";
    # anyrun.url = "github:Kirottu/anyrun";
    # anyrun.inputs.nixpkgs.follows = "nixpkgs";
    # nbfc = {
    #  url = "github:nbfc-linux/nbfc-linux";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    #  #+end_src
    # ** Outputs
    # #+begin_src nix :noweb-ref outputs
    # inputs@{
    #  self,
    #  nixpkgs,
    #  home-manager,
    #  ... }:
    # let
    #  username = "aaron";
    #  system = "x86_64-linux";
    #  pkgs = import nixpkgs {
    #  inherit system;
    #  config = {
    #  allowUnfree = true;
    #  cudaSupport = true;
    #  cudaVersion = "12";
    #  };
    #  overlays = with inputs; \[
    #  nur.overlay
    #  mynur.overlay
    #  emacs.overlay
    #  niri.overlays.niri
    #  swayfx.overlays.default
    #  (final: prev: { v2311 = import inputs.nixpkgs-2311 {
    #  inherit system;
    #  config.allowUnfree = true;
    #  };})
    #  \];
    #  };
    # in
    # {
    #  nixosConfigurations = {
    #  Omen16 = nixpkgs.lib.nixosSystem {
    #  system = "x86_64-linux";
    #  specialArgs = { inherit inputs username system pkgs; };
    #  modules = \[
    #  ./host/configuration.nix
    #  ./host/omen16.nix
    #  # home-manager.nixosModules.home-manager
    #  # {
    #  # home-manager.useGlobalPkgs = true;
    #  # home-manager.useUserPackages = true;
    #  # home-manager.users.aaron = import ./home/home.nix;
    #  # home-manager.extraSpecialArgs = { inherit inputs username pkgs; };
    #  # }
    #  \];
    #  };
    #  };
    #  homeConfigurations = {
    #  aaron = home-manager.lib.homeManagerConfiguration {
    #  inherit pkgs;
    #  extraSpecialArgs = { inherit inputs username pkgs; };
    #  modules = \[ ./home/home.nix \];
    #  };
    #  };
    # };
    
    # #+end_src
    
    # #+RESULTS:
    
    # * Host
    # :PROPERTIES:
    # :header-args:nix: :noweb-ref host-config
    # :END:
    # #+begin_src nix :tangle host/configuration.nix :noweb no-export :noweb-ref no
    # { config, pkgs, lib, inputs, username, system, ... }:
    # {
    #  imports =
    #  \[
    #  /etc/nixos/hardware-configuration.nix
    #  inputs.musnix.nixosModules.musnix
    #  inputs.niri.nixosModules.niri
    #  \];
    #  <<host-config>>
    # }
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
    # networking = {
    #  networkmanager.enable = true;
    # };
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
    # # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.users.${username} = {
    #  isNormalUser = true;
    #  extraGroups = \[ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"\];
    #  # shell = pkgs.elvish;
    # };
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
    #  hicolor-icon-theme
    #  inputs.nbfc.packages.${system}.default
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
    # virtualisation = {
    #  podman.enable = true;
    #  libvirtd.enable = true;
    #  waydroid.enable = true;
    #  # virtualbox.host.enable = true;
    #  # virtualbox.host.enableExtensionPack = true;
    #  # virtualbox.guest.enable = true;
    #  # virtualbox.guest.x11 = true;
    #  # vmware.host.enable = true;
    #  # vmware.guest.enable = true;
    # };
    # users.extraGroups.vboxusers.members = \[ "user-with-access-to-virtualbox" \];
    # #+end_src
    # ** Programs
    
    # *** Shell
    # #+begin_src nix
    # programs.bash = {
    #  interactiveShellInit = ''
    #  if \[\[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} \]\]
    #  then
    #  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #  exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #  fi
    #  ''; # launches fish unless the parent process is already fish
    # };
    # #+end_src
    # *** Window managers
    # #+begin_src nix
    # services.xserver.desktopManager.gnome.enable = true;
    # services.gnome = {
    #  evolution-data-server.enable = true;
    #  glib-networking.enable = true;
    #  gnome-keyring.enable = true;
    #  gnome-online-accounts.enable = true;
    #  at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
    # };
    # #+end_src
    
    
    # #+begin_src nix
    # programs.hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #  # enableNvidiaPatches = false; # deprecated
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.wayfire = {
    #  enable = true;
    #  # package = pkgs.mynur.wayfire;
    #  plugins = (with pkgs.wayfirePlugins; \[
    #  wcm
    #  wf-shell
    #  wayfire-plugins-extra
    #  \]);
    #  # ++ \[
    #  # pkgs.mynur.swayfire
    #  # \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.niri = {
    #  enable = true;
    #  package = pkgs.niri-stable;
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.sway = {
    #  enable = true;
    #  package = pkgs.swayfx;
    #  # wrapperFeatures.gtk = true;
    # };
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # programs.steam = {
    #  enable = true;
    #  # package = pkgs.v2311.steam;
    #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # };
    # #+end_src
    
    
    # #+begin_src nix
    # programs.adb.enable = true;
    # programs.dconf.enable = true;
    # #+end_src
    # *** Xdg
    # #+begin_src nix
    # xdg.portal = {
    #  enable = true;
    #  wlr.enable = true;
    #  # extraPortals = \[ pkgs.xdg-desktop-portal-gtk \];
    # };
    # #+end_src
    
    # #+begin_src nix
    # # xdg.mimeApps.defaultApplications = {
    # # "mp4" = \[ "umpv.desktop" "mpv.desktop" \];
    # # "png" = \[ "feh.desktop"\]
    # # }
    # #+end_src
    # ** Fonts
    # #+begin_src nix
    # fonts.packages = with pkgs; \[
    #  noto-fonts
    #  noto-fonts-cjk
    #  sarasa-gothic
    # \];
    # fonts.fontconfig = {
    #  enable = true;
    #  includeUserConf = true;
    #  allowBitmaps = false;
    #  hinting.enable = false;
    # };
    # #+end_src
    # ** Services
    # *** COMMENT Greetd
    # #+begin_src nix
    # services.greetd = {
    #  enable = true;
    # };
    # #+end_src
    
    # #+begin_src nix
    # programs.regreet = {
    #  enable = false;
    # };
    # #+end_src
    # *** Xserver
    # #+begin_src nix
    # services.xserver.enable = true;
    # services.xserver.excludePackages = \[ pkgs.xterm \];
    # services.xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "caps:escape";
    # # services.displayManager.gdm.enable = true;
    # services.displayManager.sddm = {
    #  enable = true;
    #  theme = "chili";
    # };
    # # displayManager.lightdm.enable = true;
    # # displayManager.lightdm.greeters.slick.enable = true;
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
    # services.syncthing = {
    #  enable = true;
    #  openDefaultPorts = true; # 22000/TCP and 22000/UDP
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #  user = "${username}";
    #  group = "users";
    #  # guiAdd.0:8384"; # To be able to access the web GUI
    # };
    # #+end_src
    # *** Blueman
    # #+begin_src nix
    # services.blueman.enable = true;
    # #+end_src
    # *** COMMENT Jtag
    # for vivado to link to board.
    # #+begin_src nix
    # services.udev.packages = \[
    #  (pkgs.writeTextFile {
    #  name = "xilinx-dilligent-usb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
    #  text = ''
    #  ATTR{idVendor}=="1443", MODE:="666"
    #  ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
    #  '';
    #  })
    #  (pkgs.writeTextFile {
    #  name = "xilinx-pcusb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
    #  text = ''
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
    #  ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
    #  '';
    #  })
    #  (pkgs.writeTextFile {
    #  name = "xilinx-ftdi-usb-udev";
    #  destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
    #  text = ''
    #  ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
    #  '';
    #  })
    # \];
    # #+end_src
    # *** Print
    # #+begin_src nix
    # services.printing.enable = true;
    # services.printing.drivers = \[ pkgs.hplipWithPlugin \];
    # services.avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    # };
    # #+end_src
    # *** Ollama
    # #+begin_src nix
    # services.ollama.enable = true;
    # #+end_src
    # *** COMMENT NBFC
    # Notebook fancontrol
    # #+begin_src nix :tangle no
    # systemd.services.nbfc_service = {
    #  enable = true;
    #  description = "NoteBook FanControl service";
    #  serviceConfig.Type = "simple";
    #  path = \[ pkgs.kmod \];
    #  script = let nbfc = inputs.nbfc.defaultPackage.${system}; in
    #  "${nbfc}/bin/nbfc_service --config-file '/home/${username}/.config/nbfc.json'";
    #  wantedBy = \[ "multi-user.target" \];
    # };
    # #+end_src
    # *** Misc
    # #+begin_src nix
    # services.flatpak.enable = true;
    # services.openssh.enable = true;
    # # userspace virtual filesystem
    # services.gvfs.enable = true;
    # # an automatic device mounting daemon
    # services.devmon.enable = true;
    # # allows applications to query and manipulate storage devices.
    # services.udisks2.enable = true;
    # # a DBus service for accessing the list of user accounts and information attached to those accounts.
    # # services.accounts-daemon.enable = true;
    # services.ratbagd.enable = true; # configuring gamming mouse
    #  #+end_src
    # ** Power management
    
    # #+begin_src nix
    # # a DBus service that provides power management support to applications.
    # services.upower.enable = true;
    # services.tlp = {
    #  enable =][]]
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
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaVersion = "12";
        };
        overlays = with inputs; [
          nur.overlay
          mynur.overlay
          emacs.overlay
          niri.overlays.niri
          swayfx.overlays.default
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
          modules = [
            ./host/configuration.nix
            ./host/omen16.nix
            # home-manager.nixosModules.home-manager
            # {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users.aaron = import ./home/home.nix;
            #   home-manager.extraSpecialArgs =  { inherit inputs username pkgs; };
            # }
          ];
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
