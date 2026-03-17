{
  lib,
  self,
  pkgs,
  config,
  ...
}: {
  sops.secrets.caddy = {
    sopsFile = "${self}/secrets/caddy.env.bin";
    format = "binary";
  };
  networking.firewall = {
    allowedTCPPorts = [22 80 443];
    allowedUDPPorts = [443];
  };
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.3"];
      hash = "sha256-bL1cpMvDogD/pdVxGA8CAMEXazWpFDBiGBxG83SmXLA=";
    };

    globalConfig = builtins.readFile ./config/global.txt;
    logFormat = lib.mkForce "level ERROR";
    environmentFile = config.sops.secrets.caddy.path;
  };
}
