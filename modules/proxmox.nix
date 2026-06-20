{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];
  services.fstrim.enable = false;
}
