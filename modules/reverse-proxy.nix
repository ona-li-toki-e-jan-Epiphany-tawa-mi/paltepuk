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

{ ports
, pkgs
, ...
}:

let inherit (builtins) toString;
    inherit (pkgs) callPackage;
in
{
  # Lets connections to the reverse proxy through the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings  = true;
    recommendedOptimisation  = true;
    recommendedProxySettings = true;

    virtualHosts."paltepuk.xyz" = {
      locations = {
        "/".root = "${callPackage ../site {}}";

        # cgit instance path.
        "/cgit".return = "302 $scheme://$host/cgit/";
        "/cgit/" = {
          proxyPass       = "http://127.0.0.1:${toString ports.cgit}/cgit/";
          proxyWebsockets = true;
        };
      };
    };
  };
}
