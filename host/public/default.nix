{
  lib,
  self,
  assets,
  ...
}:
let
  mkProxy =
    {
      ip ? null,
      extra ? "",
      proxy_extra ? "",
      root_path ? null,
      ...
    }:
    ''
      encode
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }
      import cloudflare-only

      ${
        if ip != null then
          ''
            reverse_proxy ${ip} {
              header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
              ${proxy_extra}
            }
          ''
        else
          ""
      }

      ${
        if root_path != null then
          ''
            root * ${root_path}
            file_server
          ''
        else
          ""
      }
      ${extra}
    '';

  shared = import "${self}/modules/caddy/shared.nix" { inherit assets; };
in
{
  services.caddy = {
    # provides cloudflare-only
    extraConfig =
      builtins.replaceStrings [ "@@cf_ips@@" ] [ (builtins.readFile "${assets}/cloudflare/ips.txt") ]
        (builtins.readFile "${assets}/cloudflare/only.caddy");

    virtualHosts = lib.mapAttrs (_domain: cfg: {
      extraConfig = mkProxy cfg;
    }) shared;
  };
}
