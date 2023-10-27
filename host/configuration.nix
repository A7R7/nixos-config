# [[file:../nixos.org::*Host][Host:1]]
{ config, pkgs, lib, inputs, username, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      inputs.musnix.nixosModules.musnix
      # ./hyprland.nix
    ];
  
  #bootloader
  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "amdgpu" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 10;
    };
  };
  
  # networking
  networking = {
    hostName = "Nixtop"; # Define your hostname.
    networkmanager.enable = true;
  };
  
  # nix
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

  # locale
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

  # Enable the X11 windowing system.


  # sound.
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "adbusers" "audio"];
    shell = pkgs.dash;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim neovim
    wget
    curl
    git
    stow
    man
    dash zsh fish elvish nushell
    efibootmgr
    gnumake
    killall
    home-manager
  ];
  
  # hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-rime
        fcitx5-chinese-addons
      ];
    };
  };

  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
    waydroid.enable = true;
  };

  programs = {
    # regreet.enable = true; 
    # This line installs ReGreet, 
    # sets up systemd tmpfiles for it, 
    # enables services.greetd and also configures its default session to start ReGreet using cage.
    hyprland = {
      enable = true;
      xwayland.enable = true;
      enableNvidiaPatches = false;
    #  package = (inputs.hyprland.packages.${pkgs.system}.hyprland.override {
    #    enableXWayland = true;
    #    enableNvidiaPatches = false;
    #  })
    };
    adb.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    dconf.enable = true;
  };

  xdg.portal = {
   enable = true;
   wlr.enable = true;
   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    roboto
    nerdfonts
    sarasa-gothic 
  ];
# services
  services = {
    printing.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
    # asusd.enable = true; # for ASUS ROG laptops
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      layout = "us";
      xkbOptions = "caps:escape";
      displayManager.gdm.enable = true;
      # desktopManager.gnome.enable = true;
    };

    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
  };

  system.stateVersion = "23.05";
   
}
# Host:1 ends here
