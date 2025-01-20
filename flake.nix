{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    catppuccin-hyprland = {
      url = "github:catppuccin/hyprland";
      flake = false;
    };

    custom-caddy = {
      url = "github:Cowboylaserkittenjetshark/nixcaddy/my-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    cura = {
      url = "https://github.com/Ultimaker/Cura/releases/download/5.9.0/UltiMaker-Cura-5.9.0-linux-X64.AppImage";
      flake = false;
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    waveforms.url = "github:liff/waveforms-flake";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./hosts
      ];
      systems = ["x86_64-linux"];
      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            just
          ];
        };
        formatter = pkgs.alejandra;
      };
    };
}
