{
  description = "caddy-public";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    kystash.url = "git+https://git.kybe.xyz/2kybe3/kystash";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    kystash,
    sops-nix,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    kystash-docs = kystash.packages.${system}.docs;

    makeHost = module:
      nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        specialArgs = {
          inherit self system kystash-docs;
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
