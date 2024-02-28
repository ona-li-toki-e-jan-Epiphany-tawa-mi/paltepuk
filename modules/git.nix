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

# Installs and configures a basic git server and a public web interface to view
# the repos.
# TODO Add web interface.

{ pkgs, lib, ... }:

let gitDirectory = "/srv/git/";

    # A set of bare repositories to create if they don't already exist.
    repositories = [
      "AkashicRecord.git"
      "BASICfuck.git"
      "BitMasher.git"
      "COBOL-DVD-Thingy.git"
      "Conways-Ivory-Tower.git"
      "Explosive-Utilities.git"
      "Explosive-Utilities.wiki.git"
      "Glow-Chickens.git"
      "ISawedThisPlayerInHalf.git"
      "Incendiary-Bees.git"
      "Modular-Backrooms.git"
      "Nitwit-Only-Mode.git"
      "PigsThatGoBoomInTheNight.git"
      "PyMSWPR.git"
      "Survival-Command-Blocks.git"
      "VineBoomErrors-vscode.git"
      "bungusmacs.git"
      "cad-vault.git"
      "cowsAyPL.git"
      "ilo-li-sina.git"
      "netcatchat.git"
      "ona-li-toki-e-jan-Epiphany-tawa-mi.git"
      "paltepuk.git"
      "player-sounder.git"
      "scripts-bucket.git"
    ];
in
{
  programs.git.enable = true;



  # We login as the "git" user via ssh when using git.
  users = {
    users."git" = {
      isSystemUser = true;
      description  = "git user";
      home         = gitDirectory;
      shell        = "${pkgs.git}/bin/git-shell";
      group        = "git";

      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJkLeoiwWFBmLu6j7hIrgPD7csbrWRYYinG2YNFYZx7 epiphany@godsthirdtemple" ];
    };

    groups."git" = {};
  };

  services.openssh.settings."AllowUsers" = [ "git" ];



  # Creates the git directory and any specified repositories if they don't
  # already exist.
  system.activationScripts."activateGit" =
    let doasGit = "sudo -u git";
    in ''
      $DRY_RUN_CMD ${doasGit} mkdir -p ${gitDirectory}

    '' + lib.concatStrings (builtins.map (repository: ''
      if [ ! -d "${gitDirectory}/${repository}" ]; then
        $DRY_RUN_CMD ${doasGit} mkdir -p "${gitDirectory}/${repository}"
        $DRY_RUN_CMD ${doasGit} git -C "${gitDirectory}/${repository}" init --bare
      fi
    '') repositories);
}
