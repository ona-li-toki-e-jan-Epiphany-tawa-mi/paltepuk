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

{ lib, ... }:

{
  services.i2pd = {
    enable     = true;
    enableIPv6 = true;                            # Based.

    # Normally this has a couple eepsites to pull domain names from, but we're
    # just using I2P for running the hidden service.
    addressbook.subscriptions = lib.mkForce [];

    # Web console, port 7070.
    proto.http.enable = true;
  };
}
