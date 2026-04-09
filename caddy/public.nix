{lib, kystash-docs, ...}: let
  mkProxy = {
    ip ? null,
    extra ? "",
    proxy_extra ? "",
    root_path ? null,
  }: ''
    encode
    tls {
      dns cloudflare {env.CF_API_TOKEN}
      resolvers 1.1.1.1
    }
    import cloudflare-only
    log {
      level INFO
    }

    ${if ip != null then ''
    reverse_proxy ${ip} {
      header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
      ${proxy_extra}
    }
    '' else ""}

    ${if root_path != null then ''
    root * ${root_path}
    file_server
    '' else ""}
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
      (import ./shared.nix {inherit kystash-docs;});
  };
}
