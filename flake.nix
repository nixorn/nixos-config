{
  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.nixos-flake.flakeModule
      ];

      flake.nixosConfigurations.nixorn = self.nixos-flake.lib.mkLinuxSystem {
        imports = [ 
          inputs.home-manager.nixosModules.home-manager
          ./nixos/configuration.nix
        ];
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}