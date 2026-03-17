{
  services.caddy = {
    extraConfig = builtins.readFile ./config/internal.txt;
  };
}
