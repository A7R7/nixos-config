# [[file:nixos.org::*Flake][Flake:1]]
{
  description = "A7R7's NixOS Flake";
  nixConfig = {
    # [[file:nixos.org::*Flake][]]
    experimental-features = [ "nix-command" "flakes" ];
    # nix community's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://anyrun.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    
    # ends here
  };
  inputs = {
    # [[file:nixos.org::*Flake][]]
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
    musnix.url = "github:musnix/musnix";
    pip2nix.url = "github:nix-community/pip2nix";
    emacs.url = "github:nix-community/emacs-overlay";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    nbfc.url = "github:nbfc-linux/nbfc-linux";
    nbfc.inputs.nixpkgs.follows = "nixpkgs";
    # ends here
  };
  outputs =
    # [[file:nixos.org::*Flake][]]
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
