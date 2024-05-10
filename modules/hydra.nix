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

# Sets up the Hydra continuous build system.
# TODO Create bind mounts.

{ serviceNames, vlan, vlan6, ports, ... }:

{
  # Isolated container for Hydra to run in.
  containers."${serviceNames.hydra}" = (import ./lib/default-container.nix {inherit vlan; inherit vlan6;}) // {
    localAddress  = vlan.hydra;
    localAddress6 = vlan6.hydra;

    config = { ... }: {
      imports = [ ./lib/container-common.nix
                ];



      # Lets connections to the Hydra web GUI through the container firewall.
      networking.firewall.allowedTCPPorts = [ ports.hydraGUI ];

      services.hydra = {
        enable             = true;
        hydraURL           = "http://127.0.0.1:${builtins.toString ports.hydraGUI}";
        notificationSender = "hydra@localhost";
        # Allows leveraging binary cache, else we'd have to build everything
        # from scratch.
        useSubstitutes     = true;

        # Forcefully set this to empty so it doesn't try to read from
        # /etc/nix/machines.
        buildMachinesFiles = [];
      };
    };
  };
}
