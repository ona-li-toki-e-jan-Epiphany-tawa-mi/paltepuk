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

# Installs and configures the Tor daemon for running onion services.

# NOTE: Make sure to set
# services.tor.settings.{"BandwidthRate","BandwidthBurst"}.

{ ports
, vlan
, pkgs-unstable
, serviceNames
, ...
}:

let inherit (builtins) genList;

    # The netcatchat client ports for the onion service.
    netcatchatClientPorts = with ports.netcatchatClient; builtins.map (port: {
      inherit port;
      target = {
        addr = vlan.netcatchat;
        inherit port;
      };
    }) (genList (x: x + from) (to - from));
in
{
  services.tor = {
    package = pkgs-unstable.tor;
    enable  = true;

    settings = {
      # Enables hardware acceleration.
      "HardwareAccel"  = 1;
    };

    relay.onionServices = {
      "${serviceNames.ssh}".map = [ 22 ];

      "${serviceNames.reverseProxy}".map = [ 80 ];

      "${serviceNames.netcatchat}".map = [{
        port   = ports.netcatchatServer;
        target = {
          addr = vlan.netcatchat;
          port = ports.netcatchatServer;
        };
      }] ++ netcatchatClientPorts;
    };
  };
}
