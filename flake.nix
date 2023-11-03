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
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    
    # ends here
  };
  inputs = {
    # [[file:nixos.org::*Flake][]]
    ## nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nur.url = "github:nix-community/NUR";
    mynur.url = "git+file:///./nurpkgs";
    # hyprland wm
    hyprland.url = "github:hyprwm/Hyprland";
    pyprland.url = "github:hyprland-community/pyprland";
    ags.url = "github:Aylur/ags";
    musnix.url = "github:musnix/musnix";    
    # ends here
  };
  outputs = 
    # [[file:nixos.org::*Flake][]]
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      nur, mynur,
      home-manager,
      hyprland,
      ... }: 
    let 
      username = "aaron-nix";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [nur.overlay mynur.overlay];
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
          specialArgs = { inherit inputs username system pkgs pkgs-stable; };
          modules = [ ./host/configuration.nix ];
        };
      };
    	homeConfigurations = {
        aaron-nix = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs username pkgs pkgs-stable; };
          modules = [ ./home/home.nix ];
        };
      };
    };
    
    # ends here
}
# Flake:1 ends here
