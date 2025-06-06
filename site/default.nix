# This file is part of paltepuk.
#
# Copyright (c) 2024-2025 ona-li-toki-e-jan-Epiphany-tawa-mi
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

# Derivation to build the static website content with Hugo.

{ stdenv, hugo }:

stdenv.mkDerivation {
  name = "paltepuk-site";
  allowSubstitutes = false;

  src = ./.;

  nativeBuildInputs = [ hugo ];

  buildPhase = ''
    hugo --minify --cleanDestinationDir
  '';

  installPhase = ''
    mkdir -p $out/
    cp -r public/* $out/
  '';
}
