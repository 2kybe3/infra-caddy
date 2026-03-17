{
  description = "caddy-public";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      treefmt,
      nixpkgs,
      sops-nix,
      flake-utils,
    }:
    let
      system = "x86_64-linux";
      assets = "${self}/assets";
      pkgs = nixpkgs.legacyPackages.${system};

      makeHost =
        module:
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {
            inherit self system assets;
          };

          modules = [
            ./modules/default.nix

            module
            sops-nix.nixosModules.sops
          ];
        };
    in
    {
      nixosConfigurations = {
        "caddy-public" = makeHost ./host/public;
        "caddy-internal" = makeHost ./host/internal;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        treefmt-eval = treefmt.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        checks.formatting = treefmt-eval.config.build.check self;
        formatter = treefmt-eval.config.build.wrapper;
        packages.cloudflare-ips = pkgs.callPackage ./assets/cloudflare { };
      }
    );
}
