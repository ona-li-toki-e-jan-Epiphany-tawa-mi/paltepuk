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

# Installs and configures a netcatchat server.

{ lib, pkgs, vlan, ports, ... }:

let netcatchatPackage = pkgs.callPackage ../packages/netcatchat.nix {};

    # Name for netcatchat and related services.
    netcatchatName = "netcatchat";

    # The ports clients can connect on, concatenated into a string for netcatchat.
    clientPorts = lib.concatMapStringsSep
      " "
      (x: builtins.toString (x + ports.netcatchatClientRangeFrom))
      (builtins.genList (x: x) (ports.netcatchatClientRangeTo - ports.netcatchatClientRangeFrom));
in
{
  # Isolated container for netcatchat to run in.
  containers."${netcatchatName}" = {
    ephemeral = true;
    autoStart = true;

    # Creates isolated network.
    privateNetwork = true;
    hostAddress    = vlan.host;
    localAddress   = vlan.netcatchat;

    config = { ... }: {
      # Opens the server and client ports.
      networking.firewall = {
        allowedTCPPorts      = [ ports.netcatchatServer ];
        allowedTCPPortRanges = [{
          from = ports.netcatchatClientRangeFrom;
          to   = ports.netcatchatClientRangeTo;
        }];
      };

      # Special user for operating netcatchat.
      users = {
        users."${netcatchatName}" = {
          isSystemUser = true;
          description  = "netcatchat user";
          group        = netcatchatName;
        };

        groups."${netcatchatName}" = {};
      };

      # Service to run a netcatchat server.
      systemd.services."${netcatchatName}" = {
        description = "netcatchat daemon";
        wantedBy    = [ "multi-user.target" ];

        script = "${lib.getExe' netcatchatPackage "netcatchat"} -s -p ${builtins.toString ports.netcatchatServer} -c \"${clientPorts}\"";

        serviceConfig = {
          "User"          = "${netcatchatName}";
          # Restarts every 4 hours.
          "Restart"       = "always";
          "RuntimeMaxSec" = "4h";
        };
      };

      system.stateVersion = "23.11";
    };
  };
}
