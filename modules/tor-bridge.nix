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

# Installs and configures an Tor bridge with Nyx to monitor it.
# TODO fix Nyx

{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.nyx ];

  services.tor = {
    enable       = true;
    openFirewall = true;

    relay = {
      enable = true;
      role   = "bridge";
    };

    settings = {
      # Tries to use hardware acceleration when possible.
      "HardwareAccel" = 1;
      # Wuh-woh, self-doxxing???!?!?!?!?!??
      "ContactInfo" = "email:epiphany-tor[]protonmail.ch ciissversion:2 pgp:4AE98E88022C1C694B72516BFE18D6FDBB07BA3A";

      # Sets up control port for tor to access with nyx.
      "ControlPort" = 9051;
    };
  };
}
