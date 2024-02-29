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

# Installs and configures an I2P node for accessing the services via I2P.
# NOTE: you will have to create a file called "i2pd-port.nix" in the base of
# this project with the port for i2pd to use.

{ lib, ... }:

let i2pdPort = (import ../i2pd-port.nix);
in
{
  networking.firewall = {
    allowedUDPPorts = [ i2pdPort ];
    allowedTCPPorts = [ i2pdPort ];
  };

  services.i2pd = {
    enable     = true;
    enableIPv6 = true;                            # Based.
    port       = i2pdPort;

    # Normally this has a couple eepsites to pull domain names from, but we're
    # just using I2P for running the hidden service.
    addressbook.subscriptions = lib.mkForce [];

    # Web console, port 7070.
    proto.http.enable = true;
  };
}
