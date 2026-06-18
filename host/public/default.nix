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
      cloudflare-only ? true,
      ...
    }:
    ''
      encode
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }
      import common_headers
      ${if cloudflare-only then "import cloudflare-only" else ""}

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

  public = {
    "http://[2a01:4f9:6b:1f05::b00b]" = {
      cloudflare-only = false;
      extra = "respond \"hi\"";
    };
  };

  shared = import "${self}/modules/caddy/shared.nix" { inherit assets; };

  hosts = lib.filterAttrs (k: v: lib.isAttrs v) (shared // public);
in
{
  services.caddy = {
    # provides cloudflare-only
    extraConfig =
      builtins.replaceStrings [ "@@cf_ips@@" ] [ (builtins.readFile "${assets}/cloudflare/ips.txt") ]
        (builtins.readFile "${assets}/cloudflare/only.caddy");

    virtualHosts = lib.mapAttrs (_domain: cfg: {
      extraConfig = mkProxy cfg;
    }) hosts;
  };
}
