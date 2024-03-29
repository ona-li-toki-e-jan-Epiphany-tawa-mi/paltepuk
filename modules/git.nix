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

# Installs and configures a basic git server and a public web interface to view
# the repos.

{ ports, vlan, ... }:

let # Where to put the files for git on the host and in the container.
    gitHostDirectory      = "/mnt/git/repositories";
    gitContainerDirectory = "/srv/git/";
    # Where to put the files for the git SSH server on the host and in the container.
    sshHostDirectory      = "/mnt/git/ssh";
    sshContainerDirectory = "/etc/ssh";
    # The user and group to use for git.
    gitUser               = "git";

    # The name for cgit and it's related services to be under.
    cgitServiceName  = "cgit";
    # The location of the custom logo for cgit under nginx.
    cgitLogoLocation = "/custom-cgit.png";

    # A set of bare repositories to create if they don't already exist.
    repositories = [
      {
        path        = "AkashicRecord.git";
        description = "The history of my universe, I guess";
        section     = null;
      }
      {
        path        = "BASICfuck.git";
        description = "A brainfuck REPL for the Commodore 64";
        section     = null;
      }
      {
        path        = "BitMasher.git";
        description = "A fast-paced text adventure game inside a ransomware-infected computer";
        section     = null;
      }
      {
        path        = "COBOL-DVD-Thingy.git";
        description = "Terminal screensaver similar to that of DVD players";
        section     = null;
      }
      {
        path        = "Conways-Ivory-Tower.git";
        description = "An infinitely-sized interactive implementation of Conway's Game of Life";
        section     = null;
      }
      {
        path        = "Explosive-Utilities.git";
        description = "Nitroglycerinomancology Reborn";
        section     = "Defunct";
      }
      {
        path        = "Explosive-Utilities.wiki.git";
        description = "Nitroglycerinomancology Reborn - Wiki | Mirror of https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/Explosive-Utilities.wiki.git";
        section     = "Personal mirrors (may contain Clearnet resources)";
      }
      {
        path        = "Glow-Chickens.git";
        description = "Luminescent Fetheared Bipeds";
        section     = "Defunct";
      }
      {
        path        = "ISawedThisPlayerInHalf.git";
        description = "With the power of (brand goes here)!";
        section     = "Defunct";
      }
      {
        path        = "Incendiary-Bees.git";
        description = "High Ordinance Apioforms";
        section     = "Defunct";
      }
      {
        path        = "Modular-Backrooms.git";
        description = "Choose-your-experience-type Backrooms mod for Minecraft";
        section     = "Defunct";
      }
      {
        path        = "Nitwit-Only-Mode.git";
        description = "Makes all Villagers Nitwits... because!";
        section     = "Defunct";
      }
      {
        path        = "PigsThatGoBoomInTheNight.git";
        description = "\"Feed\" TNT to pigs to make them go BOOM!";
        section     = "Defunct";
      }
      {
        path        = "PyMSWPR.git";
        description = "A version of Minesweeper for the CASIO fx-9750GIII (и похожие)";
        section     = null;
      }
      {
        path        = "Survival-Command-Blocks.git";
        description = "Command Blocks now made avalible and usable in a survival world near you!";
        section     = "Defunct";
      }
      {
        path        = "VineBoomErrors-vscode.git";
        description = "Plays the Vine boom sound effect when your badly-written code generates errors";
        section     = "Defunct";
      }
      {
        path        = "bungusmacs.git";
        description = "Mandatory personal emacs configuration to become a LVL 100 wizard of lightning and rocks that think";
        section     = null;
      }
      {
        path        = "cad-vault.git";
        description = "A mirror of my Thingiverse projects";
        section     = null;
      }
      {
        path        = "cowsAyPL.git";
        description = "Cowsay in GnuAPL";
        section     = null;
      }
      {
        path        = "ilo-li-sina.git";
        description = "\"ilo li sina\" li toki pi lawa pi ilo nanpa. taso, sina lawa ala e ona. ona li lawa e sina a!";
        section     = "Defunct";
      }
      {
        path        = "netcatchat.git";
        description = "A simple command-line chat server and client for Linux using netcat";
        section     = null;
      }
      {
        path        = "ona-li-toki-e-jan-Epiphany-tawa-mi.git";
        description = "poki pi nimi sona pi lipu KiApu mi | Mirror of https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/ona-li-toki-e-jan-Epiphany-tawa-mi";
        section     = "Personal mirrors (may contain Clearnet resources)";
      }
      {
        path        = "paltepuk.git";
        description = "Personal website and server wombo-combo";
        section     = null;
      }
      {
        path        = "player-sounder.git";
        description = "Player soundser byer shellinger outer toer oneer ofer theer availableer audioer playerser";
        section     = null;
      }
      {
        path        = "scripts-bucket.git";
        description = "A set of utility scripts and NixOS modules I have created to solve various odds and ends";
        section     = null;
      }
      {
        path        = "epitaphpkgs.git";
        description = "My Nix User Repository | Mirror of https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/epitaphpkgs";
        section     = "Personal mirrors (may contain Clearnet resources)";
      }
    ];
in
{
  programs.git.enable = true;



  # Creates persistent directories for git if they don't already exist.
  system.activationScripts."activateGit" = ''
    mkdir -p ${gitHostDirectory} ${sshHostDirectory}
  '';

  # Forwards connections on the git SSH port the SSH server.
  networking.nat = {
    internalInterfaces = [ "ve-${gitUser}" ];

    forwardPorts = [{
      destination = "${vlan.git}:22";
      proto       = "tcp";
      sourcePort  = ports.gitSSHServer;
    }];
  };

  # Isolated container for the git server and cgit to run in.
  containers."${gitUser}" = {
    ephemeral      = true;
    autoStart      = true;

    # Mounts persistent directories.
    bindMounts = {
      "${gitContainerDirectory}" = {
        hostPath   = gitHostDirectory;
        isReadOnly = false;
      };

      "${sshContainerDirectory}" = {
        hostPath   = sshHostDirectory;
        isReadOnly = false;
      };
    };

    # Creates isolated network.
    privateNetwork = true;
    hostAddress    = vlan.host;
    localAddress   = vlan.git;

    config = { pkgs, lib, ... }: {
      imports = [ ./ssh.nix
                ];



      # Sets permissions for bind mounts.
      systemd.tmpfiles.rules = [ "d ${gitContainerDirectory} 755 ${gitUser} ${gitUser}"
                                 "d ${sshContainerDirectory} 755 root root"
                               ];



      programs.git.enable = true;

      # We login as the "git" user via ssh when using git.
      users = {
        users."${gitUser}" = {
          isSystemUser = true;
          description  = "git user";
          home         = gitContainerDirectory;
          shell        = "${pkgs.git}/bin/git-shell";
          group        = gitUser;

          openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJkLeoiwWFBmLu6j7hIrgPD7csbrWRYYinG2YNFYZx7 epiphany@godsthirdtemple" ];
        };

        groups."${gitUser}" = {};
      };

      services.openssh.settings."AllowUsers" = [ gitUser ];

      # Creates any specified repositories if they don't already exist.
      systemd.services."create-repositories" = {
        description = "git repository creation service";
        wantedBy    = [ "multi-user.target" ];
        path        = [ pkgs.git ];

        script = lib.concatStrings (builtins.map ({path, ...}: ''
            if [ ! -d "${path}" ]; then
              mkdir -p "${path}"
              git -C "${path}" init --bare
            fi
          '')
          repositories
        );

        serviceConfig = {
          "Type"             = "oneshot";
          "User"             = gitUser;
          "WorkingDirectory" = gitContainerDirectory;
        };
      };



      # Lets connections to cgit through the container firewall.
      networking.firewall.allowedTCPPorts = [ 80 ];

      # cgit for viewing my git repos via the web.
      services.cgit."${cgitServiceName}" = {
        enable   = true;

        repos = builtins.listToAttrs(builtins.map ({path, description, section, ...}: {
            name  = path;
            value = {
              path    = "/srv/git/${path}";
              desc    = description;
              section = lib.mkIf (section != null) section;
            };
          })
          repositories
        );

        settings = {
          # Converts the README files to HTML for display.
          "about-filter"        = "${pkgs.cgit}/lib/cgit/filters/about-formatting.sh";
          # Cool commit graph.
          "enable-commit-graph" = 1;
          # Enables extra links in the index view to different parts of the repo.
          "enable-index-links"  = 1;
          # Hides the "owner" of the repos since it's all just the git user.
          "enable-index-owner"  = 0;
          # Removes footer.
          "footer"              = "";
          # Haha funny logo.
          "logo"                = cgitLogoLocation;
          # Hides email addresses, they can be annoying.
          "noplainemail"        = 1;
          # Sets the README of the repos to the README.md of the default branch.
          "readme"              = ":README.md";
          # Stuff that appears in the index page.
          "root-desc"           = "Do you have YOUR OWN git server? Didn't think so"; # lmao.
          "root-readme"         = "${../data/cgit/root-README.md}";
          "root-title"          = "jan Epiphany's Public Git Server";
          # I like side-by-side diffs.
          "side-by-side-diffs"  = 1;
          # Nice syntax highlighting.
          "source-filter"       = "${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
        };
      };

      # Extra files for cgit to grab.
      services.nginx.virtualHosts."${cgitServiceName}".locations = {
        "= ${cgitLogoLocation}".alias = "${../data/cgit/logo.png}";
      };



      system.stateVersion = "23.11";
    };
  };
}
