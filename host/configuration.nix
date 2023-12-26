# [[file:../nixos.org::*Host][Host:1]]
{ config, pkgs, lib, inputs, username, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      inputs.musnix.nixosModules.musnix
    ];
  # [[file:nixos.org::*Host][]]
  system.stateVersion = "23.11";
  nixpkgs.config.allowUnfree = true;
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = [ "${username}" ];
    };
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  boot = {
    loader = {
      # systemd-boot.enable = true;
      grub = {
        enable = true;
        theme = pkgs.mynur.xenlism-grub-4k-nixos;
        splashMode = "normal";
        efiSupport = true;
        useOSProber = true;
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = 10;
    };
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  networking = {
    networkmanager.enable = true;
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  musnix.enable = true;
  sound.enable = false; # sound.enable is only meant for ALSA-based configurations
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  services. pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  time.timeZone = "Asia/Shanghai";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  
  
  # ends here
  # [[file:nixos.org::*Host][]]
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
  # environment.sessionVariables.GTK_IM_MODULE = "fcitx5";
  # environment.sessionVariables.QT_IM_MODULE = "fcitx5";
  # environment.sessionVariables.XMODIFIERS = "@im=fcitx5";
  # ends here
  # [[file:nixos.org::*Host][]]
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"];
    # shell = pkgs.elvish;
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  environment.systemPackages = with pkgs; [
    vim neovim
    wget
    curl
    git
    stow
    man
    efibootmgr
    gnumake
    killall
    home-manager
    dash elvish fish nushell tcsh xonsh zsh
    sddm-chili-theme
  ];
  # ends here
  # [[file:nixos.org::*Host][]]
  environment.shells = with pkgs; [
    dash elvish fish nushell tcsh xonsh zsh
  ];
  # ends here
  # [[file:nixos.org::*Host][]]
  environment.localBinInPath = true;
  # ends here
  # [[file:nixos.org::*Host][]]
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
    waydroid.enable = true;
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  # programs.regreet = {
  # This line installs ReGreet,
  # sets up systemd tmpfiles for it,
  # enables services.greetd and also configures its default session to start ReGreet using cage.
  # enable = true;
  # };
  
  # ends here
  # [[file:nixos.org::*Host][]]
  
  # ends here
  # [[file:nixos.org::*Host][]]
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # enableNvidiaPatches = false; # deprecated
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  programs.wayfire = {
    enable = true;
    package = pkgs.mynur.wayfire;
    plugins = (with pkgs.wayfirePlugins; [
      wcm
      wf-shell
      wayfire-plugins-extra
    ]) ++  [
      pkgs.mynur.swayfire
    ];
  };
  environment.sessionVariables.WAYFIRE_CONFIG_FILE = "$HOME/.config/wayfire/wayfire.ini";
  # ends here
  # [[file:nixos.org::*Host][]]
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  programs.adb.enable = true;
  programs.dconf.enable = true;
  # ends here
  # [[file:nixos.org::*Host][]]
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    roboto roboto-serif
    sarasa-gothic
  ];
  fonts.fontconfig = {
    enable = true;
    includeUserConf = true;
    allowBitmaps = false;
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:escape";
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    # wayland.enable = true;
    theme = "chili";
  };
  # displayManager.lightdm.enable = true;
  # displayManager.lightdm.greeters.slick.enable = true;
  # desktopManager.gnome.enable = true;
  # ends here
  # [[file:nixos.org::*Host][]]
  services.tlp.enable = true;
  services.printing.enable = true;
  services.flatpak.enable = true;
  services.openssh.enable = true;
  # userspace virtual filesystem
  services.gvfs.enable = true;
  # an automatic device mounting daemon
  services.devmon.enable = true;
  # a DBus service that allows applications to query and manipulate storage devices.
  services.udisks2.enable = true;
  # a DBus service that provides power management support to applications.
  services.upower.enable = true;
  # a DBus service for accessing the list of user accounts and information attached to those accounts.
  services.accounts-daemon.enable = true;
  # ends here
  # [[file:nixos.org::*Host][]]
  services.gnome = {
    evolution-data-server.enable = true;
    glib-networking.enable = true;
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
    at-spi2-core.enable = true; # avoid the warning "The name org.a11y.Bus was not provided by any .service files"
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  services.dae = {
    enable = true;
    configFile = "/home/${username}/.config/dae/config.dae";
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # 22000/TCP and 22000/UDP
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
    user = "${username}";
    group = "users";
    # guiAdd.0:8384"; # To be able to access the web GUI
  };
  # ends here
  # [[file:nixos.org::*Host][]]
  security.polkit.enable = true;
  # start polkit on login by creating a systemd user service
  # ends here
}
# Host:1 ends here
