{ pkgs, ... }:
{
  # Run Minecraft server, BlueMap CLI run as this user without sudo.
  #   sudo -iu minecraft
  #   zellij attach -c mc
  users.groups.minecraft = { };
  users.users.minecraft = {
    isSystemUser = true;
    group = "minecraft";
    home = "/home/minecraft";
    createHome = true;
    # xiej has access to group minecraft, setgid so new files get group minecraft.
    homeMode = "2770";
    shell = pkgs.fish;
  };
}
