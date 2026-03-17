{
  pkgs,
  config,
  ...
}: let
  repoDir = "/var/lib/infra-caddy";

  redeploy = pkgs.writeShellApplication {
    name = "redeploy";
    runtimeInputs = [
      pkgs.git
      pkgs.nixos-rebuild
    ];
    text = ''
      set -e

      REPO="${repoDir}"

      if [ ! -d "$REPO/.git" ]; then
        ${pkgs.git}/bin/git clone \
          https://git.kybe.xyz/2kybe3/infra-caddy.git \
          "$REPO"
      fi

      ${pkgs.git}/bin/git -C "$REPO" pull --ff-only

      ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake $REPO#${config.networking.hostName} -v
    '';
  };
in {
  systemd.tmpfiles.rules = [
    "d /var/lib/infra-caddy 0755 root root -"
  ];
  environment.systemPackages = [redeploy];

  users = {
    groups.webhook = {};
    users.webhook = {
      isSystemUser = true;
      group = "webhook";
    };
  };

  security.sudo.extraRules = [
    {
      users = ["webhook"];
      commands = [
        {
          command = "${redeploy}/bin/redeploy";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  systemd.services.webhook = {
    restartIfChanged = false;
  };
  services.webhook = {
    enable = true;
    user = "webhook";
    group = "webhook";
    port = 9999;

    hooks.redeploy = {
      execute-command = "/run/wrappers/bin/sudo";
      pass-arguments-to-command = [
        {
          source = "string";
          name = "${redeploy}/bin/redeploy";
        }
      ];
      include-command-output-in-response = true;
      include-command-output-in-response-on-error = true;
    };

    openFirewall = true;
  };
}
