{
  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.nixos-unified.flakeModule
      ];

      flake.nixosConfigurations.nixorn-legion =
        self.nixos-unified.lib.mkLinuxSystem {
          home-manager = true;
        } {
          imports = [
            inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05h
            inputs.home-manager.nixosModules.home-manager
            {programs.nh.package = inputs.nh.packages.x86_64-linux.default;}
            ./nixos/configuration.nix
          ];
        };
    };

  inputs = {
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
