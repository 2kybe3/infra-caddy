{
  "git.kybe.xyz" = {
    ip = "10.0.4.12:3000";
    extra = ''
      handle_path / {
        redir https://git.kybe.xyz/2kybe3 302
      }
    '';
  };
  "metrics.kybe.xyz" = {
    ip = "http://nix-main.kybe.xyz:2342";
  };
  "webhooks.kybe.xyz" = {
    ip = "http://nix-main.kybe.xyz:3000";
  };
  "mastodon.kybe.xyz" = {
    ip = "http://10.0.4.20";
  };
  "autodiscover.kybe.xyz" = {
    ip = "10.0.4.3:80";
  };
  "gotify.kybe.xyz" = {
    ip = "http://10.0.4.19";
  };
  "autoconfig.kybe.xyz" = {
    ip = "10.0.4.3:80";
  };
  "status.kybe.xyz" = {
    ip = "http://10.0.4.8";
  };
  "matrix.kybe.xyz" = {
    ip = "10.0.4.6:6167";
  };
  "attic.kybe.xyz" = {
    ip = "10.0.5.3:8080";
  };
  "rhp.kybe.xyz" = {
    ip = "10.0.8.3:8080";
  };
  "reg.kybe.xyz" = {
    ip = "10.0.4.10:5000";
  };
  "uma.kybe.xyz" = {
    ip = "10.0.4.15:3000";
  };
  "kybe.xyz" = {
    ip = "10.0.4.4:3000";
    extra = ''
      handle_path /.well-known/matrix/* {
        root ${../../assets/well-known/matrix}
        header Content-Type application
        file_server
      }
    '';
  };
  "www.kybe.xyz" = {
    extra = ''
      redir https://kybe.xyz{uri}
    '';
  };
}
