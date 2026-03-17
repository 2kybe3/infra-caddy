{
  "git.kybe.xyz" = {
    ip = "10.0.4.12:3000";
    extra = ''
      handle_path / {
        redir https://git.kybe.xyz/2kybe3 302
      }
    '';
  };
  "autodiscover.kybe.xyz" = {ip = "10.0.4.3:80";};
  "autoconfig.kybe.xyz" = {ip = "10.0.4.3:80";};
  "status.kybe.xyz" = {ip = "10.0.4.8:3001";};
  "gotify.kybe.xyz" = {ip = "10.0.4.19:8080";};
  "mastodon.kybe.xyz" = {ip = "10.0.4.20:80";};
  "matrix.kybe.xyz" = {ip = "10.0.4.6:6167";};
  "rhp.kybe.xyz" = {ip = "10.0.4.11:8080";};
  "reg.kybe.xyz" = {ip = "10.0.4.10:5000";}; # maybe make this private?
  "uma.kybe.xyz" = {ip = "10.0.4.15:3000";};
  "i.kybe.xyz" = {ip = "10.0.4.16:80";};
  "kybe.xyz" = {
    ip = "10.0.4.4:3000";
    extra = builtins.readFile ./config/kybe.xyz;
  };
}
