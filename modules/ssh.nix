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

# Installs and configures an SSH server.

{
  imports = [ ./lib/ssh-common.nix
            ];



  services.openssh.openFirewall = true;

  # I2P in-tunnel for remote access. Adding a Tor service would be overkill.
  services.i2pd.inTunnels."OpenSSH" = {
    enable      = true;
    port        = 22;
    destination = "";
  };
}
