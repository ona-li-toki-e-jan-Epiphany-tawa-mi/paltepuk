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

{ serviceNames
, pkgs
, lib
, ports
, ...
}:

let gitDirectory = "/srv/git";

    # The location of the custom logo for cgit under nginx.
    cgitLogoLocation = "/${serviceNames.cgit}/custom-cgit.png";

    # Names for the sections displayed in cgit.
    sections = {
      none           = null;
      # As-in no longer being worked on or supported.
      defunct        = "Defunct";
      # My projects that mainly live on other sites.
      personalMirror = "Personal mirrors (may contain Clearnet resources)";
      # Mirrors of others' projects.
      mirror         = "Mirrors (may contain Clearnet resources)";
    };

    # Declarative repositories for git and cgit.
    repositories = [
      {
        path        = "AkashicRecord.git";
        description = "The history of my universe, I guess";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "BitMasher.git";
        description = "A fast-paced text adventure game inside a ransomware-infected computer";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "COBOL-DVD-Thingy.git";
        description = "Terminal screensaver similar to that of DVD players";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "Conways-Ivory-Tower.git";
        description = "An infinitely-sized interactive implementation of Conway's Game of Life";
        section     = sections.defunct;
        autoMirror  = false;
      }
      {
        path        = "PyMSWPR.git";
        description = "A version of Minesweeper for the CASIO fx-9750GIII (и похожие)";
        section     = sections.defunct;
        autoMirror  = false;
      }
      {
        path        = "VineBoomErrors-vscode.git";
        description = "Plays the Vine boom sound effect when your badly-written code generates errors";
        section     = sections.defunct;
        autoMirror  = false;
      }
      {
        path        = "cad-vault.git";
        description = "A mirror of my Thingiverse projects";
        section     = sections.personalMirror;
        autoMirror  = false;
      }
      {
        path        = "cowsAyPL.git";
        description = "Cowsay in GnuAPL";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "ilo-li-sina.git";
        description = "\"ilo li sina\" li toki pi lawa pi ilo nanpa. taso, sina lawa ala e ona. ona li lawa e sina a!";
        section     = sections.defunct;
        autoMirror  = false;
      }
      {
        path        = "netcatchat.git";
        description = "A simple command-line chat server and client for Linux using netcat";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "ona-li-toki-e-jan-Epiphany-tawa-mi.git";
        description = "poki pi nimi sona pi lipu KiApu mi | Mirror of https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/ona-li-toki-e-jan-Epiphany-tawa-mi";
        section     = sections.personalMirror;
        autoMirror  = false;
      }
      {
        path        = "paltepuk.git";
        description = "Personal website and server wombo-combo";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "player-sounder.git";
        description = "Player soundser byer shellinger outer toer oneer ofer theer availableer audioer playerser";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "epitaphpkgs.git";
        description = "My Nix User Repository | Mirror of https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/epitaphpkgs";
        section     = sections.personalMirror;
        autoMirror  = false;
      }
      {
        path        = "Brainblast-Toolkit.git";
        description = "A brainfuck/BASICfuck REPL for 6502 machines";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "nixpkgs.git";
        description = "Nix Packages collection & NixOS | Mirror of https://github.com/nixos/nixpkgs";
        section     = sections.mirror;
        autoMirror  = true;
        mirrorUrl   = "https://github.com/nixos/nixpkgs";
      }
      {
        path        = "hydra-projects.git";
        description = "Declarative Hydra project specifications";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "AHD.git";
        description = "Hexdump utility";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "Minecraft-Projects-Monorepo.git";
        description = "Monorepo for my old Minecraft projects";
        section     = sections.defunct;
        autoMirror  = false;
      }
      {
        path        = "ap.git";
        description = "A simple NixOS configuration for making wireless access points";
        section     = sections.none;
        autoMirror  = false;
      }
      {
        path        = "TLPIN.git";
        description = "toki lawa pi ilo nanpa sama toki APL";
        section     = sections.none;
        autoMirror  = false;
      }
    ];
in
{
  programs.git = {
    enable                        = true;
    config."init"."defaultBranch" = "master";
  };



  # We login as the "git" user via ssh when using git.
  users = {
    users."${serviceNames.git}" = {
      isSystemUser = true;
      description  = "git user";
      home         = gitDirectory;
      shell        = "${pkgs.git}/bin/git-shell";
      group        = serviceNames.git;

      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJkLeoiwWFBmLu6j7hIrgPD7csbrWRYYinG2YNFYZx7 epiphany@godsthirdtemple" ];
    };

    groups."${serviceNames.git}" = {};
  };

  services.openssh.settings."AllowUsers" = [ serviceNames.git ];



  systemd = {
    services = {
      # Creates any specified repositories if they don't already exist.
      "create-repositories" = {
        description = "git repository creation service";
        wantedBy    = [ "multi-user.target" ];
        path        = [ pkgs.git ];

        script = ''
           # Shows executed commands.
           set -x
        '' + lib.concatStrings (builtins.map ({ path, ... }: ''
            if [ ! -d "${path}" ]; then
              mkdir -p "${path}"
              git -C "${path}" init --bare
            fi
          '')
          (builtins.filter ({ autoMirror, ... }: !autoMirror) repositories)
        );

        serviceConfig = {
          "Type"             = "oneshot";
          "User"             = serviceNames.git;
          "WorkingDirectory" = gitDirectory;
        };
      };

      # Automatically mirrors and updates mirror repositories.
      "auto-mirror" = {
        description = "git repository automirroring service";
        path        = [ pkgs.git ];

        script = ''
           # Shows executed commands.
           set -x
        '' + lib.concatStrings (builtins.map ({ path, mirrorUrl, ... }: ''
            if [ ! -d "${path}" ]; then
              git clone --mirror "${mirrorUrl}" "${path}"
            else
              git -C "${path}" remote update
            fi
          '')
          (builtins.filter ({ autoMirror, ... }: autoMirror) repositories)
        );

        serviceConfig = {
          "Type"             = "oneshot";
          "User"             = serviceNames.git;
          "WorkingDirectory" = gitDirectory;
        };
      };
    };

    # Runs the auto-mirror service once a week.
    timers."auto-mirror" = {
      description = "git repository automirroring service";
      wantedBy    = [ "timers.target" ];

      timerConfig = {
        "OnCalendar" = "weekly";
        "Persistent" = true;
      };
    };
  };



  # cgit for viewing my git repos via the web.
  services.cgit."${serviceNames.cgit}" = {
    enable         = true;
    nginx.location = "/${serviceNames.cgit}";

    repos = builtins.listToAttrs(builtins.map ({path, description, section, ...}: {
        name  = path;
        value = {
          path    = "${gitDirectory}/${path}";
          desc    = description;
          section = lib.mkIf (section != null) section;
        };
      })
      repositories
    );

    settings = {
      # Converts the README files to HTML for display.
      "about-filter"        = "${pkgs.cgit}/lib/cgit/filters/about-formatting.sh";
      # Fixes fetching of cgit CSS under virtual root.
      "css"                 = "/${serviceNames.cgit}/cgit.css";
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

  services.nginx.virtualHosts."${serviceNames.cgit}" = {
    # Changes port of cgit instance.
    listen = [{
      addr = "127.0.0.1";
      port = ports.cgit;
    }];

      # Extra files for cgit to grab.
    locations."= ${cgitLogoLocation}".alias = "${../data/cgit/logo.png}";
  };
}
