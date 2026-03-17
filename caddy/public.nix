let
  CF-HEADER = "header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}";
  CF-ONLY = "import cloudflare-only";
  MK-PROXY = ip: ''
    encode
    ${CF-ONLY}
    reverse_proxy ${ip} {
      ${CF-HEADER}
    }
  '';
in {
  services.caddy = {
    # provides cloudflare-only
    extraConfig = builtins.readFile ./config/cf-only.txt;

    virtualHosts = {
      "kybe.xyz" = {
        serverAliases = ["www.kybe.xyz"];
        extraConfig = builtins.readFile ./config/kybe.xyz;
      };
      "autodiscover.kybe.xyz" = {
        serverAliases = ["autoconfig.kybe.xyz"];
        extraConfig = MK-PROXY "10.0.4.3:80";
      };
      "git.kybe.xyz".extraConfig =
        (MK-PROXY "10.0.4.12:3000")
        + ''
          handle_path / {
            redir https://git.kybe.xyz/2kybe3 302
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
