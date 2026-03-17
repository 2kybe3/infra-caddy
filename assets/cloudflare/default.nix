{
  pkgs ? import <nixpkgs>,
  ...
}:
pkgs.writeShellApplication {
  name = "cloudflare-ips";

  derivationArgs = {
    __structuredAttrs = true;
    strictDeps = true;
  };

  runtimeInputs = with pkgs; [
    jq
    curl
  ];

  text = ''
    curl https://api.cloudflare.com/client/v4/ips | jq -r '.result | .ipv4_cidrs + .ipv6_cidrs | sort | join(" ")'
  '';
}
