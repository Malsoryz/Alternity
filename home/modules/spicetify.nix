{
  pkgs,
  inputs,
  spicetify-pkgs,
  ...
}:
{
  programs.spicetify = {
    enable = true;
    theme = spicetify-pkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicetify-pkgs.extensions; [
      adblock
      shuffle
      beautifulLyrics
    ];

    enabledCustomApps = with spicetify-pkgs.apps; [
      marketplace
      newReleases
    ];
  };
}
