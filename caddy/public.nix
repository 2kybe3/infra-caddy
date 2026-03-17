let
  CF-HEADER = "header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}";
  CF-ONLY = "import cloudflare-only";
  MK-PROXY = cf: ip: ''
    encode
    ${if cf then CF-ONLY else ""}
    reverse_proxy ${ip} {
      ${CF-HEADER}
    }
  '';
in {
  services.caddy = {
    extraConfig = builtins.readFile ./config/public.txt;
    virtualHosts = {
      "kybe.xyz" = {
        serverAliases = [ "www.kybe.xyz" ];
        extraConfig = builtins.readFile ./config/kybe.xyz;
      };
      "rhp.kybe.xyz".extraConfig = MK-PROXY true "10.0.4.11:8080";
    };
  };
}
