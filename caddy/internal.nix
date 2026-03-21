{lib, ...}: let
  mkProxy = {
    ip,
    extra ? "",
    proxy_extra ? "",
  }: ''
    encode
    reverse_proxy ${ip} {
      ${proxy_extra}
    }
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
    "attic.kybe.xyz" = {ip = "10.0.5.3:8080";};
    "ppl.kybe.xyz" = {ip = "10.0.5.5:8000";};
    "opn.kybe.xyz" = {ip = "10.0.4.1:8004";};
  };
in {
  services.caddy.virtualHosts = lib.mapAttrs (_: cfg: {
    extraConfig = mkProxy cfg;
  }) ((import ./shared.nix) // internal);
}
