{
  services.caddy = {
    extraConfig = builtins.readFile ./config/public.txt;
  };
}
