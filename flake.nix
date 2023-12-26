{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    helix.url = "github:helix-editor/helix";

    catppuccin-hyprland = {
      url = "github:catppuccin/hyprland";
      flake = false;
    };

    catppuccin-foot.url = "github:Cowboylaserkittenjetshark/catppuccin-foot-nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    ...
  }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      lap = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/lap
          ./users/cblkjs
        ];
      };
      tower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/tower
          ./users/cblkjs
        ];
      };
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://helix.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };
}
