{
  description = "A7R7's NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    # substituters = [
    #   "https://mirror.sjtu.edu.cn/nix-channels/store"
    #   "https://mirrors.nju.edu.cn/nix-channels/store"
    #   "https://mirrors.bfsu.edu.cn/nix-channels/store"
    #   # "https://mirrors.ustc.edu.cn/nix-channels/store"
    #   "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    #   "https://cache.nixos.org/"
    # ];

    # nix community's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    ## nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # nix-colors.url = "github:misterio77/nix-colors";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nur.url = "github:nix-community/NUR";
    # hyprland wm
    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.url = "github:hyprwm/Hyprland/v0.29.0";
    ags.url = "github:Aylur/ags";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    hyprland,
    ... }: 
  let 
    username = "aaron-nix";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
    {
    nixosConfigurations = {
      Nixtop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs username system; };
        modules = [
          ./host/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs pkgs pkgs-stable; };
              users.${username} = import ./home/home.nix;
            };
          }
        ];
      };
    };
  };
}
