{pkgs,...}:
{
  imports = [
    ./webhook.nix
    ./proxmox.nix
    ./sops.nix
    ./caddy
  ];

  environment.systemPackages = [
    pkgs.vim
  ];


  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7irWuDZwx7ZvPSiUwBbxUxKL/7aMQmy/8oxput1bID kybe@knx"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAOf/P3GM9bQA8nbVfoMt5BvIILwLw/f379yNZGeMNey nix-builder -> caddy-public/private"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
