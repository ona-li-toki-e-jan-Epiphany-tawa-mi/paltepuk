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

# Installs and configures a netcatchat server.

{ lib
, vlan
, vlan6
, ports
, config
, serviceNames
, ...
}:

let # The ports clients can connect on, concatenated into a string for netcatchat.
    clientPorts = lib.concatStringsSep " " (builtins.genList
      (x: builtins.toString (x + ports.netcatchatClient.from))
      (ports.netcatchatClient.to - ports.netcatchatClient.from));
in
{
  # Isolated container for netcatchat to run in.
  containers."${serviceNames.netcatchat}" = (import ./lib/default-container.nix {inherit vlan; inherit vlan6;}) // {
    localAddress = vlan.netcatchat;

    config = { ... }: {
      imports = [ ./lib/container-common.nix
                ];



      # Opens the server and client ports.
      networking.firewall = {
        allowedTCPPorts      = [ ports.netcatchatServer ];
        allowedTCPPortRanges = [{
          inherit (ports.netcatchatClient) from;
          inherit (ports.netcatchatClient) to;
        }];
      };

      # Special user for operating netcatchat.
      users = {
        users."${serviceNames.netcatchat}" = {
          isSystemUser = true;
          description  = "netcatchat user";
          group        = serviceNames.netcatchat;
        };

        groups."${serviceNames.netcatchat}" = {};
      };

      # Service to run a netcatchat server.
      systemd.services."${serviceNames.netcatchat}" = {
        description = "netcatchat server daemon";
        wantedBy    = [ "multi-user.target" ];
        path        = [ config.nur.repos.ona-li-toki-e-jan-Epiphany-tawa-mi.netcatchat ];

        script = ''
          netcatchat -s -p ${builtins.toString ports.netcatchatServer} -c "${clientPorts}"
        '';

        serviceConfig = {
          "User"          = serviceNames.netcatchat;
          # Restarts every 4 hours.
          "Restart"       = "always";
          "RuntimeMaxSec" = "4h";
        };
      };
    };
  };
}
