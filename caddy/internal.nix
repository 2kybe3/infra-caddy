{lib, kystash-docs, ...}: let
  mkProxy = {
    ip ? null,
    extra ? "",
    root_path ? null,
    proxy_extra ? "",
  }: ''
    encode
    tls {
      dns cloudflare {env.CF_API_TOKEN}
      resolvers 1.1.1.1
    }

    ${if ip != null then ''
    reverse_proxy ${ip} {
      ${proxy_extra}
    }
    '' else ""}

    ${if root_path != null then ''
    root * ${root_path}
    file_server
    '' else ""}
    ${extra}
  '';

  HTTPS-INSECURE = ''
    transport http {
      tls_insecure_skip_verify
    }
  '';

  internal = {
    "proxmox.kybe.xyz" = {
      ip = "10.0.5.1:8006";
      proxy_extra = HTTPS-INSECURE;
    };
    "translate.kybe.xyz" = {ip = "10.0.4.13:5000";};
    "mailadmin.kybe.xyz" = {ip = "10.0.4.3:80";};
    "search.kybe.xyz" = {ip = "10.0.5.7:8080";};
    "frss.kybe.xyz" = {ip = "10.0.4.18:8080";};
    "ppl.kybe.xyz" = {ip = "10.0.5.5:8000";};
    "opn.kybe.xyz" = {ip = "10.0.4.1:8004";};
  };
in {
  services.caddy.virtualHosts = lib.mapAttrs (_: cfg: {
    extraConfig = mkProxy cfg;
  }) ((import ./shared.nix {inherit kystash-docs;}) // internal);
}
