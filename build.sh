#!/bin/sh

# This file is part of paltepuk.
#
# Copyright (c) 2025 ona-li-toki-e-jan-Epiphany-tawa-mi
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

# Error on unset variables.
set -u

set -x

# We need to remove the result symlink or nixfmt will try to traverse it.
rm result 2> /dev/null
nix fmt || exit 1

nixos-rebuild --flake path:.#raspberryPi400 build || exit 1
