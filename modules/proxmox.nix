{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];
  # nix.settings.sandbox = false;
  services.fstrim.enable = false;
}
