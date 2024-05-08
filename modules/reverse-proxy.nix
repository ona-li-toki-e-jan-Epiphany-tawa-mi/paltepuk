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

# Sets up a reverse proxy to route conneting browsers to the webservers present
# on this system.

{ serviceNames, vlan, vlan6, ... }:

{
  # Forwards HTTP connections to the reverse proxy.
  networking.nat = {
    internalInterfaces = [ "ve-${serviceNames.reverseProxy}" ];

    forwardPorts = [
      {
        destination = "${vlan.reverseProxy}:80";
        proto       = "tcp";
        sourcePort  = 80;
      }
      {
        destination = "[${vlan6.reverseProxy}]:80";
        proto       = "tcp";
        sourcePort  = 80;
      }
    ];
  };

  # Isolated container for the reverse proxy to run in.
  containers."${serviceNames.reverseProxy}" = (import ./lib/default-container.nix {inherit vlan; inherit vlan6;}) // {
    localAddress  = vlan.reverseProxy;
    localAddress6 = vlan6.reverseProxy;

    config = { ... }: {
      imports = [ ./lib/container-common.nix
                ];



      # Lets connections to the reverse proxy through the container firewall.
      networking.firewall.allowedTCPPorts = [ 80 ];

      services.nginx = {
        enable = true;

        virtualHosts."paltepuk.xyz" = {           # Temporary fake domain.
          # Simply redirects to the cgit instance for now.
          locations."/" = {
            return = "307 $scheme://$host/${serviceNames.cgit}";
          };

          # cgit instance path.
          locations."/${serviceNames.cgit}" = {
            proxyPass       = "http://${vlan.git}/${serviceNames.cgit}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
