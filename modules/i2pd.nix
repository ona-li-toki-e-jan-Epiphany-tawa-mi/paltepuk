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

# Installs and configures an I2P node for accessing the services via I2P.

# NOTE: Make sure to set services.i2pd.bandwidth.

{ lib
, ports
, pkgs-unstable
, pkgs
, extraPorts
, auth
, ...
}:

let inherit (lib) mkForce getExe;
    inherit (builtins) toString;
in
{
  # Allows conenctions from peers
  networking.firewall = with extraPorts; {
    allowedUDPPorts = [ i2pd ];
    allowedTCPPorts = [ i2pd ];
  };

  # For monitoring the web console.
  environment.shellAliases."i2pd-status" =
    "sudo -u i2pd ${getExe pkgs.lynx} 127.0.0.1:${toString ports.i2pdConsole}";

  services.i2pd = {
    package    = pkgs-unstable.i2pd;
    enable     = true;
    enableIPv6 = true;                            # Based.
    port       = extraPorts.i2pd;

    # Normally this has a couple eepsites to pull domain names from, but we're
    # just using I2P for running "hidden" services.
    addressbook.subscriptions = mkForce [];

    # Web console.
    proto.http = with auth.i2pd; {
      enable = true;
      port   = ports.i2pdConsole;
      auth   = true;
      user   = username;
      pass   = password;
    };

    inTunnels = {
      "nginx" = {
        enable      = true;
        port        = 80;
        destination = "";
      };

      "rsync" = {
        enable      = true;
        port        = ports.rsyncd;
        destination = "";
      };
    };
  };
}
