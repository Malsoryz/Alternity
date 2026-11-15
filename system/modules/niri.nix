{ pkgs, inputs, ... }:
{
  programs.niri = {
    enable = true;
  };

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  services.displayManager.defaultSession = "gnome";
}
