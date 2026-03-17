{lib, ...}: let
  mkProxy = {
    ip,
    extra ? "",
    proxy_extra ? "",
  }: ''
    encode
    import cloudflare-only
    reverse_proxy ${ip} {
      header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
      ${proxy_extra}
    }
    ${extra}
  '';
in {
  services.caddy = {
    # provides cloudflare-only
    extraConfig = builtins.readFile ./config/cf-only.txt;

    virtualHosts =
      lib.mapAttrs (_domain: cfg: {
        extraConfig = mkProxy cfg;
      })
      (import ./shared.nix);
  };
}
