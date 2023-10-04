# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hyprland.nix
    ];
  
  #bootloader
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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
    enableIPv6 = false;
  };

  # nix 
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      substituters = [ 
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        #"https://mirrors.nju.edu.cn/nix-channels/store"
      ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "aaron-nix" ]; # so I can visit custom substituters
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
# services
  services = {
    printing.enable = true;
    flatpak.enable = true;
  };
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:escape";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    desktopManager.gnome.debug = true;
  };

  # Enable the X11 windowing system.


  # sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # asus
  services.asusd.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aaron-nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "adbusers"]; # Enable ‘sudo’ for the user.
    shell = pkgs.elvish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    curl
    git
    stow
    man
    zsh
    elvish
    efibootmgr
    gnumake
    killall
  ];


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
      	fcitx5-configtool
      ];
    };
  };

  programs.adb.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

   
}

