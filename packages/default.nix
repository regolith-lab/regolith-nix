{ pkgs }:

{
  ilia = pkgs.callPackage ./ilia.nix { };
  regolith-powerd = pkgs.callPackage ./regolith-powerd.nix { };
  regolith-displayd = pkgs.callPackage ./regolith-displayd.nix { };
  regolith-inputd = pkgs.callPackage ./regolith-inputd.nix { };
  regolith-ftue = pkgs.callPackage ./regolith-ftue.nix { };
  xrescat = pkgs.callPackage ./xrescat.nix { };
  rofication = pkgs.callPackage ./rofication.nix { };
  remontoire = pkgs.callPackage ./remontoire.nix { };
  trawl = pkgs.callPackage ./trawl.nix { };
  i3xrocks = pkgs.callPackage ./i3xrocks.nix { };
  libtrawldb = pkgs.callPackage ./libtrawldb.nix { };
  regolith-look-extra = pkgs.callPackage ./regolith-look-extra.nix { };
  i3status-rs = pkgs.callPackage ./i3status-rs.nix { };
  sway-regolith = pkgs.callPackage ../sway-regolith/default.nix { };
  regolith-session = pkgs.callPackage ./regolith-session.nix { };
  regolith-look-default = pkgs.callPackage ./regolith-look-default.nix { };
  regolith-wm-config = pkgs.callPackage ./regolith-wm-config.nix { };
  i3-swap-focus = pkgs.callPackage ./i3-swap-focus.nix { };
  regolith-systemd-units = pkgs.callPackage ./regolith-systemd-units.nix { };
  regolith-i3status-config = pkgs.callPackage ./regolith-i3status-config.nix { };
  regolith-xresources = pkgs.callPackage ./xresources-config.nix { };
  regolith-styles = pkgs.callPackage ./regolith-styles.nix { };
}
