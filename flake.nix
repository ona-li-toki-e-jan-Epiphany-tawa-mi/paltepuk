# This file is part of paltepuk.
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

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;

  outputs = { nixpkgs, ... } @ inputs:
    let extraSpecialArguments = {
          # IP addresses for container networking.
          vlan = {
            host       = "192.168.100.1";
            cgit       = "192.168.100.3";
            tor        = "192.168.100.5";
            i2pd       = "192.168.100.7";
            netcatchat = "192.168.100.9";
          };

          # Common area for port numbers.
          ports = {
            i2pdWebConsole            = 7070;
            torControl                = 9051;
            gitSSHServer              = 5000;
            netcatchatServer          = 2000;
            netcatchatClientRangeFrom = 2001;
            netcatchatClientRangeTo   = 2026;
          };
        };
    in {
      nixosConfigurations = {
        "raspberryPi3BPlus" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; } // extraSpecialArguments;

          system  = "aarch64-linux";
          modules = [ ./hosts/raspberry-pi-3-b-plus.nix
                      ./modules/default.nix
                    ];
        };
      };
    };
}
