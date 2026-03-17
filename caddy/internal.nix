let
  MK-PROXY = ip: extra: ''
    encode
    reverse_proxy ${ip} {
      ${extra}
    }
  '';
  HTTPS-INSECURE = ''
    transport http {
      tls_insecure_skip_verify
    }
  '';
in {
  services.caddy = {
    virtualHosts = {
      "proxmox.kybe.xyz".extraConfig = MK-PROXY "10.0.5.1:8006" HTTPS-INSECURE;
      "translate.kybe.xyz".extraConfig = MK-PROXY "10.0.4.13:5000";
      "search.kybe.xyz".extraConfig = MK-PROXY "10.0.5.7:8080";
      "frss.kybe.xyz".extraConfig = MK-PROXY "10.0.4.18:8080";
      "mailadmin.kybe.xyz".extraConfig = MK-PROXY "10.0.4.3";
      "ppl.kybe.xyz".extraConfig = MK-PROXY "10.0.5.5:8000";
      "opn.kybe.xyz".extraConfig = MK-PROXY "10.0.4.1:8004";

      # taken from public.nix
      "git.kybe.xyz".extraConfig =
        (MK-PROXY "10.0.4.12:3000")
        + ''
          handle_path / {
            redir https://git.kybe.xyz/kybe 302
          }
        '';
      "status.kybe.xyz".extraConfig = MK-PROXY "http://10.0.4.8:3001";
      "gotify.kybe.xyz".extraConfig = MK-PROXY "10.0.4.19:8080";
      "mastodon.kybe.xyz".extraConfig = MK-PROXY "10.0.4.20:80";
      "matrix.kybe.xyz".extraConfig = MK-PROXY "10.0.4.6:6167";
      "rhp.kybe.xyz".extraConfig = MK-PROXY "10.0.4.11:8080";
      "reg.kybe.xyz".extraConfig = MK-PROXY "10.0.4.10:5000";
      "uma.kybe.xyz".extraConfig = MK-PROXY "10.0.4.15:3000";
      "i.kybe.xyz".extraConfig = MK-PROXY "10.0.4.16:80";
    };
  };
}
