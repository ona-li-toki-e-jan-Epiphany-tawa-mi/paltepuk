# This file is part of paltepuk.
#
# Copyright (c) 2024-2025 ona-li-toki-e-jan-Epiphany-tawa-mi
#
# paltepuk is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# paltepuk is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with paltepuk. If not, see <https://www.gnu.org/licenses/>.

{
  description = "NixOS configuration flake for badass reproducable websites";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, nixpkgs-unstable, ... }@inputs:
    let # Extra nixpkgs channels to include.
      extraChannels = { pkgs, ... }: {
        _module.args.pkgs-unstable = import nixpkgs-unstable {
          inherit (pkgs.stdenv.targetPlatform) system;
        };
      };

      # Modules to include in every configuration.
      extraModules = [ extraChannels ./modules ];

      # Arguments to include in every configuration.
      extraSpecialArguments = {
        inherit inputs;

        # Port numbers for networked services.
        ports = {
          i2pdConsole = 7070;
          cgit = 5000;
        };
      } // (import ./config.nix);

      inherit (nixpkgs.lib) genAttrs systems nixosSystem;

      forAllSystems = f:
        genAttrs systems.flakeExposed
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-classic);

      nixosConfigurations = {
        raspberryPi400 = nixosSystem rec {
          specialArgs = extraSpecialArguments // { inherit system; };

          system = "aarch64-linux";
          modules = [ ./hosts/raspberry-pi-400.nix ] ++ extraModules;
        };
      };
    };
}
