{ inputs, pkgs, system, username, ... }:
let
  nbfc = inputs.packages.${system}.nbfc;
in
{
  systemd.services.nbfc_service = {
    enable = true;
    description = "NoteBook FanControl service";
    serviceConfig.Type = "simple";
    path = [ pkgs.kmod ];
    script = "${nbfc}/bin/nbfc_service --config-file '/home/${username}/.config/nbfc.json'";
    wantedBy = [ "multi-user.target" ];
  };
}
