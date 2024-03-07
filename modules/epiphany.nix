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

# Creates my user account for administration.

{ ... }:

{
  users.users."epiphany" = {
    isNormalUser          = true;
    description           = "jan Epiphany";
    initialHashedPassword = "$y$j9T$tPqkwxEzz/qTTg4abhY08.$Zfus24pugl2Th/.EImtasVU51x39TgmSY86uKpTzv2D";
    extraGroups           = [ "wheel" ];

    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsLu3obWEYcXp6xRSSeOstWH7LVl8mCz0diS4IJeqZh epiphany@godsthirdtemple" ];
  };

  services.openssh.settings."AllowUsers" = [ "epiphany" ];
}
