{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self,nixpkgs }:
      let
        inherit (self) outputs;
        system = "x86_64-linux";
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};
        # Helper to collect all packages
      allPackages = with self.packages.${system}; [
        ilia
        regolith-powerd
        regolith-displayd
        regolith-inputd
        regolith-ftue
        xrescat
        rofication
        remontoire
        trawl
        i3xrocks
        libtrawldb
        regolith-look-extra
        i3status-rs
        sway-regolith
        regolith-session
        i3-swap-focus
        regolith-xresources
        regolith-look-default
        regolith-systemd-units
        regolith-i3status-config
        regolith-session-wayland
      ];
      in
      {
        # regolith-nix module
        # nixosModules.regolith = import ./regolith.nix;

        # this section can be run using nix run .#<package-name>    --> https://nixos.wiki/wiki/Flakes
        # can perform build checks unsing nix build .#<package-name> --> https://nixos.wiki/wiki/Flakes
        packages."x86_64-linux".ilia = pkgs.callPackage ./packages/ilia.nix{}; # todo--> Stablize --> different icon theme crashes ilia
       
        # todo --> Error :-
        #(process:171187): GLib-GIO-ERROR **: 05:32:45.056: Settings schema 'org.gnome.settings-daemon.plugins.power' is not installed
        packages."x86_64-linux".regolith-powerd = pkgs.callPackage ./packages/regolith-powerd.nix{}; 
        
        #works
        packages."x86_64-linux".regolith-displayd = pkgs.callPackage ./packages/regolith-displayd.nix{}; 
        
        #works
        packages."x86_64-linux".regolith-inputd = pkgs.callPackage ./packages/regolith-inputd.nix{}; 
        
        packages."x86_64-linux".regolith-ftue = pkgs.callPackage ./packages/regolith-ftue.nix{}; 
      
        packages."x86_64-linux".xrescat = pkgs.callPackage ./packages/xrescat.nix{}; 
        
        packages."x86_64-linux".rofication = pkgs.callPackage ./packages/rofication.nix{}; 
        
        packages."x86_64-linux".remontoire = pkgs.callPackage ./packages/remontoire.nix{}; 
        
        packages."x86_64-linux".trawl = pkgs.callPackage ./packages/trawl.nix{}; 

        packages."x86_64-linux".i3xrocks = pkgs.callPackage ./packages/i3xrocks.nix{}; 

        packages."x86_64-linux".libtrawldb = pkgs.callPackage ./packages/libtrawldb.nix{}; 
        
        packages."x86_64-linux".regolith-look-extra = pkgs.callPackage ./packages/regolith-look-extra.nix{}; 
        
        packages."x86_64-linux".i3status-rs = pkgs.callPackage ./packages/i3status-rs.nix{}; 

        packages."x86_64-linux".sway-regolith = pkgs.callPackage ./sway-regolith/default.nix{}; 

        packages."x86_64-linux".regolith-session = pkgs.callPackage ./packages/regolith-session.nix{}; 

        packages."x86_64-linux".regolith-wm-config = pkgs.callPackage ./packages/regolith-wm-config.nix{}; 

        packages."x86_64-linux".regolith-look-default = pkgs.callPackage ./packages/regolith-look-default.nix{}; 

        packages."x86_64-linux".i3-swap-focus = pkgs.callPackage ./packages/i3-swap-focus.nix{}; 

        packages."x86_64-linux".regolith-systemd-units = pkgs.callPackage ./packages/regolith-systemd-units.nix{}; 

        packages."x86_64-linux".regolith-i3status-config = pkgs.callPackage ./packages/regolith-i3status-config.nix{}; 

        packages."x86_64-linux".regolith-styles = pkgs.callPackage ./packages/regolith-styles.nix{}; 

        packages."x86_64-linux".regolith-xresources = pkgs.callPackage ./packages/xresources-config.nix{}; 
        # the default runScript is fish and this creates a shell that follows fhs file format -->https://ryantm.github.io/nixpkgs/builders/special/fhs-environments/
        packages."x86_64-linux".fhs = pkgs.callPackage ./fhs.nix {};

        # this runs via --> nix run .#nixosConfigurations.vm.config.system.build.vm
        devShells.${system}.default = let
          fhs = pkgs.callPackage ./fhs.nix {};
        in pkgs.mkShell {
          packages = [ fhs ] ++ allPackages;
          shellHook = ''
            exec ${fhs}/bin/regolith-environment
          '';
        };
        #pass regolith-session-wayland to regolith.nix
        # nixosModules.regolith-session-wayland = { config, pkgs, lib, ... }:
        # let
        #   regolith-session = pkgs.callPackage ./packages/regolith-session.nix {};
        #   regolith-session-wayland = pkgs.callPackage ./fhs.nix {
        #     runScript = "${regolith-session}/bin/regolith-session-wayland";
        #     name = "regolith-nix-session-wayland";
        #   };
        # in {
        #   imports = [ ./modules/regolith.nix ];
          
        #   # Make packages available to the regolith module
        #   _module.args.regolith-session-wayland = regolith-session-wayland;
        # };
        nixosModules.regolith-session-wayland = import ./modules/regolith.nix;
        # here I am trying to set runScript to regolith-session-wayland package 
        #directly runs session-wayland
        # here I am trying to set runScript to regolith-session-wayland package 
        #directly runs session-wayland
        packages."x86_64-linux".regolith-session-wayland = 
        let
          regolith-session = pkgs.callPackage ./packages/regolith-session.nix {};
        in 
          pkgs.callPackage ./fhs.nix {
            runScript = "${regolith-session}/bin/regolith-session-wayland";
            name = "regolith-nix-session-wayland";
          };

        # this also runs via --> nix run .#<package-name>
        packages."x86_64-linux".regolith-session-x11 = 
        let
          regolith-session = pkgs.callPackage ./packages/regolith-session.nix {};
        in 
          pkgs.callPackage ./fhs.nix {
            runScript = "${regolith-session}/bin/regolith-session-x11";
          };
        
        # this is the nixos configuration for the vm !todo
        nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ pkgs, ... }: {
            # Basic system configuration
            fileSystems."/" = {
              device = "none";
              fsType = "tmpfs";
              options = [ "size=2G" "mode=755" ];
            };

            boot.loader.grub.enable = true;
            boot.loader.grub.devices = [ "nodev" ];

            # VM-specific settings
            virtualisation.vmVariant = {
              virtualisation = {
                memorySize = 4096; # MB
                cores = 4;
              };
            };
            imports = [
              ./modules/regolith.nix
            ];
            regolith.enable=true;
            # Basic system services
            # services.xserver = {
            #   enable = true;
            #   # displayManager.gdm.enable = true;
            #   # desktopManager.gnome.enable = true;
            # };
            
            # Packages and user configuration
            environment.systemPackages = allPackages;
            
            users.users.demo = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              initialPassword = "demo";
            };

            system.stateVersion = "23.11";
          })
        ];
      };
      };
}