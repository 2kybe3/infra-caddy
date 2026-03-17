{
  lib,
  self,
  pkgs,
  config,
  assets,
  ...
}:
{
  sops.secrets.caddy = {
    sopsFile = "${self}/secrets/caddy.env.bin";
    format = "binary";
  };
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      2019 # metrics
    ];
    allowedUDPPorts = [ 443 ];
  };
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.3" ];
      hash = "sha256-M1vg27XU0y54DBffviY5fMkLorF7sKsrZP3Yiwq8sZ0=";
    };

    globalConfig = builtins.readFile "${assets}/global.caddy";
    logFormat = lib.mkForce "level ERROR";
    environmentFile = config.sops.secrets.caddy.path;
  };
}
