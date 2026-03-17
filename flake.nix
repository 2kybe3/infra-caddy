{
  description = "caddy-public";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    makeHost = module: nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      specialArgs = {
        inherit self system;
      };

      modules = [
        ./configuration.nix
        module
        sops-nix.nixosModules.sops
      ];
    };
  in {
    nixosConfigurations = {
      "caddy-public" = makeHost ./caddy/public.nix; 
      "caddy-internal" = makeHost ./caddy/internal.nix;
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
