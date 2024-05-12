# This file is part of paltepuk.
#
# Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
#
# paltepuk is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# paltepuk is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along
# with paltepuk. If not, see <https://www.gnu.org/licenses/>.

{
  description = "NixOS configuration flake for badass reproducable websites";

  inputs = {
    nixpkgs.url          = github:NixOS/nixpkgs/nixos-23.11;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nur.url              = github:nix-community/NUR;
  };

  outputs = { nixpkgs, nur, nixpkgs-unstable, ... } @ inputs:
    let # Extra nixpkgs channels to include.
        extraChannels = { pkgs, ... }: {
          _module.args.pkgs-unstable = import nixpkgs-unstable { inherit (pkgs.stdenv.targetPlatform) system; };
        };

        # Modules to include in every configuration.
        extraModules = [
          extraChannels
          nur.nixosModules.nur
          ./modules
        ];

        # Arguments to include in every configuration.
        extraSpecialArguments = {
          inherit inputs;

          # Container network IPv4 addresses.
          vlan = {
            host         = "192.168.100.1";
            git          = "192.168.100.3";
            tor          = "192.168.100.5";
            i2pd         = "192.168.100.7";
            netcatchat   = "192.168.100.9";
            reverseProxy = "192.168.100.11";
          };

          # Container network IPv6 addresses.
          vlan6 = {
            host         = "fc00::1";
            i2pd         = "fc00::3";
            git          = "fc00::5";
            reverseProxy = "fc00::7";
          };

          # Port numbers for networked services.
          ports = {
            i2pdConsole      = 7070;
            torControl       = 9051;
            netcatchatServer = 2000;
            netcatchatClient = {
              from = 2001;
              to   = 2026;
            };
            hydraGUI         = 3000;
            privoxyTor       = 8118;
          };

          # These names are used for systemd services, containers, onion
          # services, I2P tunnels, etc..
          serviceNames = {
            ssh          = "ssh";
            cgit         = "cgit";
            netcatchat   = "netcatchat";
            git          = "git";
            reverseProxy = "rev-proxy";
            hydra        = "hydra";
            i2pd         = "i2pd";
            tor          = "tor";
          };

          # Directory paths, typically for container bind mounts.
          directories = {
            gitRepositories = "/mnt/git/repositories";
            gitSSH          = "/mnt/git/ssh";
            i2pd            = "/mnt/i2pd";
            tor             = "/mnt/tor";
          };

          # User IDs.
          uids = {
            git      = 1002;
            i2pd     = 150;
            tor      = 35;
          };

          # Group IDs.
          gids = {
            git      = 1002;
            i2pd     = 150;
            tor      = 35;
          };
        };
    in {
      nixosConfigurations = {
        "raspberryPi400" = nixpkgs.lib.nixosSystem rec {
          specialArgs = extraSpecialArguments // {
            inherit system;
          };

          system  = "aarch64-linux";
          modules = [ ./hosts/raspberry-pi-400.nix
                    ] ++ extraModules;
        };
      };
    };
}
