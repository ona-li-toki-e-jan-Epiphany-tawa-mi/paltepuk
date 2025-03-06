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
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with paltepuk. If not, see <https://www.gnu.org/licenses/>.

{ stdenv, fetchgit, lib, typescript, minify }:

stdenv.mkDerivation rec {
  pname = "multiply-by-n";
  version = "0.1.2";
  allowSubstitutes = false;

  src = fetchgit {
    url = "https://paltepuk.xyz/cgit/multiply-by-n.git";
    rev = version;
    hash = "sha256-qLE/ZVlRE4Sa/aRvQCNornhoLPBHFbH0GEdMD8QPVo4=";
  };

  nativeBuildInputs = [ minify ];
  buildPhase = ''
    for file in src/*.css src/*.html src/*.js; do
      minify "$file" > "$file.min"
    done
  '';

  doCheck = true;
  checkInputs = [ typescript ];
  checkPhase = ''
    tsc
  '';

  installPhase = ''
    mkdir -p "$out"

    for minified_file in src/*.min; do
      file_name="''${minified_file%.min}"; file_name="''${file_name##*/}"
      cp "$minified_file" "$out/$file_name"
    done
  '';

  meta = with lib; {
    description =
      "Cool animation made by drawing lines between moving points on a circle";
    homepage = "https://paltepuk.xyz/cgit/multiply-by-n.git/about";
    license = licenses.agpl3Plus;
  };
}
