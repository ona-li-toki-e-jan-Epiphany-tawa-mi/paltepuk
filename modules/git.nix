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

{ pkgs, lib, ... }:

let gitDirectory = "/srv/git/";

    # A set of bare repositories to create if they don't already exist.
    repositories = [
      {
        path        = "AkashicRecord.git";
        description = "The history of my universe, I guess";
      }
      {
        path        = "BASICfuck.git";
        description = "A brainfuck REPL for the Commodore 64";
      }
      {
        path        = "BitMasher.git";
        description = "A fast-paced text adventure game inside a ransomware-infected computer";
      }
      {
        path        = "COBOL-DVD-Thingy.git";
        description = "Terminal screensaver similar to that of DVD players";
      }
      {
        path        = "Conways-Ivory-Tower.git";
        description = "An infinitely-sized interactive implementation of Conway's Game of Life";
      }
      {
        path        = "Explosive-Utilities.git";
        description = "Nitroglycerinomancology Reborn";
      }
      {
        path        = "Explosive-Utilities.wiki.git";
        description = "Nitroglycerinomancology Reborn - Wiki";
      }
      {
        path        = "Glow-Chickens.git";
        description = "Luminescent Fetheared Bipeds";
      }
      {
        path        = "ISawedThisPlayerInHalf.git";
        description = "With the power of (brand goes here)!";
      }
      {
        path        = "Incendiary-Bees.git";
        description = "High Ordinance Apioforms";
      }
      {
        path        = "Modular-Backrooms.git";
        description = "Choose-your-experience-type Backrooms mod for Minecraft";
      }
      {
        path        = "Nitwit-Only-Mode.git";
        description = "Makes all Villagers Nitwits... because!";
      }
      {
        path        = "PigsThatGoBoomInTheNight.git";
        description = "\"Feed\" TNT to pigs to make them go BOOM!";
      }
      {
        path        = "PyMSWPR.git";
        description = "A version of Minesweeper for the CASIO fx-9750GIII (и похожие)";
      }
      {
        path        = "Survival-Command-Blocks.git";
        description = "Command Blocks now made avalible and usable in a survival world near you!";
      }
      {
        path        = "VineBoomErrors-vscode.git";
        description = "Plays the Vine boom sound effect when your badly-written code generates errors";
      }
      {
        path        = "bungusmacs.git";
        description = "Mandatory personal emacs configuration to become a LVL 100 wizard of lightning and rocks that think";
      }
      {
        path        = "cad-vault.git";
        description = "A mirror of my Thingiverse projects";
      }
      {
        path        = "cowsAyPL.git";
        description = "Cowsay in GnuAPL";
      }
      {
        path        = "ilo-li-sina.git";
        description = "\"ilo li sina\" li toki pi lawa pi ilo nanpa. taso, sina lawa ala e ona. ona li lawa e sina a!";
      }
      {
        path        = "netcatchat.git";
        description = "A simple command-line chat server and client for Linux using netcat";
      }
      {
        path        = "ona-li-toki-e-jan-Epiphany-tawa-mi.git";
        description = "poki pi nimi sona pi lipu KiApu mi";
      }
      {
        path        = "paltepuk.git";
        description = "Personal website and server wombo-combo";
      }
      {
        path        = "player-sounder.git";
        description = "Player soundser byer shellinger outer toer oneer ofer theer availableer audioer playerser";
      }
      {
        path        = "scripts-bucket.git";
        description = "A set of utility scripts and NixOS modules I have created to solve various odds and ends";
      }
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
    let doasGit = "${lib.getExe pkgs.sudo} -u git";
    in ''
      $DRY_RUN_CMD ${doasGit} mkdir -p ${gitDirectory}

    '' + lib.concatStrings (builtins.map ({path, description}: ''
      if [ ! -d "${gitDirectory}/${path}" ]; then
        $DRY_RUN_CMD ${doasGit} mkdir -p "${gitDirectory}/${path}"
        $DRY_RUN_CMD ${doasGit} git -C "${gitDirectory}/${path}" init --bare
        $DRY_RUN_CMD ${doasGit} echo '${description}' >> "${gitDirectory}/${path}/description"
      fi
    '') repositories);



  # cgit for viewing my git repos via the web.
  services.cgit."git" = {
    enable   = true;
    scanPath = gitDirectory;
  };

  # Tor access for the cgit instance.
  # Normally running the onion service on the same tor daemon as a relay is a
  # no-no, but it's tied to my real identity anyways, so who cares.
  services.tor.relay.onionServices."cgit".map = [ 80 ];

  # I2P access for the cgit instance.
  services.i2pd.inTunnels."cgit" = {
    enable      = true;
    port        = 80;
    destination = "";
  };
}
