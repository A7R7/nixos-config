{ pkgs, ags, ... }:
{
  home.packages = [
    ags
  ];

  # xdg.configFile.ags.source = ../ags;
}
