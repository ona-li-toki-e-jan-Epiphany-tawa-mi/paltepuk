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

# Creates my user account for administration.

{ epiphanyInitialHashedPassword, epiphanySSHKeys, pkgs, ... }:

{
  users.users."epiphany" = {
    isNormalUser = true;
    description = "jan Epiphany";
    initialHashedPassword = epiphanyInitialHashedPassword;
    extraGroups = [ "wheel" ];

    packages = with pkgs; [ htop ];

    openssh.authorizedKeys.keys = epiphanySSHKeys;
  };

  services.openssh.settings."AllowUsers" = [ "epiphany" ];

  # Makes my user a trusted user for remote rebuilding.
  nix.settings.trusted-users = [ "epiphany" ];
}
