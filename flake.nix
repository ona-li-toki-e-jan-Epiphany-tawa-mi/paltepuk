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

  inputs = {
    # We like to live life on the wild side.
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  };

  outputs = { nixpkgs, ... } @ inputs:
    let extraSpecialArguments = {
          # Hostname to be used for the server.
          hostName = "paltepuk";
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
