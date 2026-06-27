{
  nix = {
    enable = true;
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "pipe-operators"
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = true;
    };

  };
}
