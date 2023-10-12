{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.ags
  ];

  # xdg.configFile.ags.source = ../ags;
}
