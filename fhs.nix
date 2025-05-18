{ name ? "regolith-environment", pkgs, runScript ? "${pkgs.fish}/bin/fish" }:

let
  regolith-packages = import ./packages { inherit pkgs; };

  # Get all packages including their dependencies
  regolith-pkgs = [
    regolith-packages.regolith-styles
    regolith-packages.ilia
    regolith-packages.regolith-powerd
    regolith-packages.regolith-displayd
    regolith-packages.regolith-inputd
    regolith-packages.regolith-ftue
    regolith-packages.xrescat
    regolith-packages.rofication
    regolith-packages.remontoire
    regolith-packages.trawl
    regolith-packages.i3xrocks
    regolith-packages.libtrawldb
    regolith-packages.regolith-look-extra
    regolith-packages.i3status-rs
    regolith-packages.sway-regolith
    regolith-packages.regolith-session
    regolith-packages.regolith-look-default
    regolith-packages.regolith-wm-config
    regolith-packages.i3-swap-focus
    regolith-packages.regolith-systemd-units
    regolith-packages.regolith-i3status-config
    # regolith-packages.regolith-xresources
  ];

  # Collect all build inputs recursively
  all-inputs = builtins.concatMap
    (p: if builtins.hasAttr "buildInputs" p then p.buildInputs ++ [ p ] else [ p ])
    regolith-pkgs;
in
pkgs.buildFHSEnv {
  inherit name;

  targetPkgs = pkgs: with pkgs; [
    # Basic system utilities
    mate.mate-polkit
    bash
    coreutils
    gtk3
    glib
    kitty
    alacritty
    pavucontrol
    # icon-themes
    papirus-icon-theme

    gnome-session
    gnome-settings-daemon
    gnome-shell
    gnome-control-center
    # gnome-keyring
    gnome-terminal
    gnome-control-center

    # Add dbus and window manager related packages
    dbus
    xorg.xmodmap
    xorg.xrdb
    wlr-randr

    # Add missing dependencies
    networkmanager
    networkmanagerapplet
    systemd
    # i3
    kanshi
    wl-clipboard
    sway-audio-idle-inhibit
    avizo

    # Add polkit and related packages
    polkit
    polkit_gnome
    mate.mate-polkit

    # Python dependencies
    (python3.withPackages (ps: with ps; [
      i3ipc
    ]))

    # Sway specific tools
    gtklock
    playerctl
    sway-contrib.grimshot

    # System utilities
    xdg-desktop-portal
    xdg-desktop-portal-wlr

    # Media controls
    nautilus
  ];

  multiPkgs = pkgs: all-inputs;

  extraOutputsToInstall = [ "usr" "etc" "lib" "share" ];

  # Add Xresources to the environment
  profile = ''
    export REGOLITH_PATH=/usr/share/regolith
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share/regolith
    export XDG_CONFIG_HOME=$HOME/.config
    export GNOME_SHELL_SESSION_MODE=regolith
    alias mate-polkit="${pkgs.mate.mate-polkit}/bin/mate-polkit"

    # Create systemd user directory if it doesn't exist
    mkdir -p $HOME/.config/systemd/user

    # Copy systemd user service files
    if [ -d "/usr/lib/systemd/user" ]; then
      cp -rf /usr/lib/systemd/user/* $HOME/.config/systemd/user/ > /dev/null 2>&1
    fi

    # # Reload systemd user services
    # ${pkgs.systemd}/bin/systemctl --user daemon-reload
    # echo "Reloaded systemd user services"
    # ${pkgs.systemd}/bin/systemctl --user enable regolith-wayland.target
    # echo "Enabled regolith-wayland.target"
    # ${pkgs.systemd}/bin/systemctl --user enable regolith-init-kanshi.service
    # echo "Enabled regolith-init-kanshi.service"
    # ${pkgs.systemd}/bin/systemctl --user enable regolith-init-displayd.service
    # echo "Enabled regolith-init-displayd.service"
    # ${pkgs.systemd}/bin/systemctl --user enable regolith-init-powerd.service
    # echo "Enabled regolith-init-powerd.service"
    # ${pkgs.systemd}/bin/systemctl --user enable regolith-init-inputd.service
    # echo "Enabled regolith-init-inputd.service"

    # Ensure XDG_RUNTIME_DIR exists
    if [ -z "$XDG_RUNTIME_DIR" ]; then
      export XDG_RUNTIME_DIR=/run/user/$(id -u)
      mkdir -p $XDG_RUNTIME_DIR
      chmod 700 $XDG_RUNTIME_DIR
    fi

    # Load Xresources
    if [ -f $HOME/.config/regolith3/Xresources ]; then
      echo -e "\033[32mXresources file exists.\033[0m"
    else
      echo "Xresources file does not exist."
      # Load Xresources
      mkdir -p $HOME/.config/regolith3
      echo "Copied Xresources to home directory."
    fi
    
    xrdb -merge $HOME/.config/regolith3/Xresources

    echo "Regolith is ready :)"
  '';

  # runScript = "${pkgs.fish}/bin/fish";
  inherit runScript;
}

# Enabled regolith-init-kanshi.service
# Enabled regolith-init-displayd.service
# Failed to enable unit: Unit regolith-init-powerd.service does not exist
# Enabled regolith-init-powerd.service
# Failed to enable unit: Unit regolith-init-inputd.service does not exist
# Enabled regolith-init-inputd.service
