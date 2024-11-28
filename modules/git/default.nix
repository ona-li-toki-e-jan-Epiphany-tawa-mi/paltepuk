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

{ pkgs
, lib
, ports
, gitSSHKeys
, ...
}:

let inherit (lib) concatStrings mkIf escapeShellArg;
    inherit (builtins) filter listToAttrs;
    inherit (pkgs) callPackage;

    gitDirectory  = "/srv/git";
    cgitResources = callPackage ./cgit {};

    # Names for the sections displayed in cgit.
    sections = {
      none           = null;
      # As-in no longer being worked on or supported. Eventually will be merged
      # into the AkashicRecord.
      defunct        = "Defunct";
      # My projects that mainly live on other sites.
      personalMirror = "Personal mirrors (may contain Clearnet resources)";
      # Mirrors of others' projects.
      mirror         = "Mirrors (may contain Clearnet resources)";
    };

    # Declarative repositories for git and cgit.
    repositories =
      let standard = path: description: {
            inherit path;
            inherit description;
            section    = sections.none;
            autoMirror = false;
          };

          personalMirror = path: description: {
            inherit path;
            inherit description;
            section    = sections.personalMirror;
            autoMirror = false;
          };

          mirror = path: mirrorUrl: description: {
            inherit path;
            inherit description;
            section    = sections.mirror;
            autoMirror = true;
            inherit mirrorUrl;
          };
      in [
        (standard "AkashicRecord.git"
          "The history of my universe, I guess")
        (standard "BitMasher.git"
          "A fast-paced text adventure game inside a ransomware-infected computer")
        (standard "COBOL-DVD-Thingy.git"
          "Terminal screensaver similar to that of DVD players")
        (standard "PyMSWPR.git"
          "A version of Minesweeper for the CASIO fx-9750GIII (и похожие)")
        (standard "cowsAyPL.git"
          "Cowsay in GNU APL")
        (standard "netcatchat.git"
          "A simple command-line chat server and client using netcat")
        (standard "paltepuk.git"
          "Personal website and server wombo-combo")
        (standard "Brainblast-Toolkit.git"
          "A brainfuck/BASICfuck REPL for 6502 machines")
        (standard "AHD.git"
          "Hexdump utility")
        (standard "ap.git"
          "A simple NixOS configuration for making wireless access points")
        (standard "elephant_veins.git"
          "Luanti mod that replaces small sporadic ore pockets with sparse, gigantic ore veins")
        (standard "fio.apl.git"
          "GNU APL ⎕FIO abstraction library")
        (standard "love-you-mom.git"
          "Tells your mom (or dad) that you love them")
        (standard "aplwiz.git"
          "GNU APL automated testing script templates")

        (personalMirror "epitaphpkgs.git"
          "My Nix User Repository | Mirror of https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/epitaphpkgs")
        (personalMirror "ona-li-toki-e-jan-Epiphany-tawa-mi.git"
          "poki pi nimi sona pi lipu KiApu mi | Mirror of https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/ona-li-toki-e-jan-Epiphany-tawa-mi")
      ];
in
{
  programs.git = {
    enable = true;

    config = {
      init.defaultBranch = "master";

      # Globally removes "dubious ownership" check from the git repositories.
      safe.directory = [ "." ] ++ builtins.map ({ path, ... }:
        gitDirectory + "/" + path
      ) repositories;
    };
  };



  # We login as the "git" user via ssh when using git.
  users = {
    users."git" = {
      isSystemUser = true;
      description  = "git user";
      home         = gitDirectory;
      shell        = "${pkgs.git}/bin/git-shell";
      group        = "git";

      openssh.authorizedKeys.keys = gitSSHKeys;
    };

    groups."git" = {};
  };

  services.openssh.settings.AllowUsers = [ "git" ];



  system.activationScripts."create-git-directory" = ''
    mkdir -p ${escapeShellArg gitDirectory}
    chown git:git ${escapeShellArg gitDirectory}
  '';

  systemd = {
    services = {
      # Creates any specified repositories if they don't already exist.
      "create-repositories" = {
        description = "git repository creation service";
        wantedBy    = [ "multi-user.target" ];
        path        = with pkgs; [ git ];

        script = ''
          # Shows executed commands.
          set -x
        '' + concatStrings (builtins.map ({ path, ... }: ''
          if [ ! -d ${escapeShellArg path} ]; then
            mkdir -p ${escapeShellArg path}
            git -C ${escapeShellArg path} init --bare
          fi
        '') (filter ({ autoMirror, ... }: !autoMirror) repositories));

        serviceConfig = {
          Type             = "oneshot";
          User             = "git";
          WorkingDirectory = gitDirectory;

          # systemd-analyze security recommendations.
          PrivateDevices          = true;
          ProtectClock            = true;
          ProtectKernelLogs       = true;
          RemoveIPC               = true;
          NoNewPrivileges         = true;
          ProtectControlGroups    = true;
          ProtectKernelModules    = true;
          MemoryDenyWriteExecute  = true;
          SystemCallArchitectures = [ "native" ];
          ProtectHostname         = true;
          ProtectSystem           = "strict";
          ReadWritePaths          = [ gitDirectory ];
          ProtectProc             = "invisible";
          LockPersonality         = true;
          RestrictRealtime        = true;
          ProcSubset              = "pid";
          ProtectHome             = true;
          PrivateNetwork          = true;
          PrivateUsers            = true;
          PrivateTmp              = true;
          SystemCallFilter        = [ "@system-service" "~@resources" "~@privileged" ];
          SystemCallErrorNumber   = "EPERM";
          RestrictAddressFamilies = "none";
          ProtectKernelTunables   = true;
          RestrictNamespaces      = true;
          RestrictSUIDSGID        = true;
          IPAddressDeny           = "any";
          CapabilityBoundingSet   = "";
        };
      };

      # Automatically mirrors and updates mirror repositories.
      "auto-mirror" = {
        description = "git repository automirroring service";
        wantedBy    = [];
        path        = with pkgs; [ git ];

        script = ''
          # Shows executed commands.
          set -x
        '' + concatStrings (builtins.map ({ path, mirrorUrl, ... }: ''
          if [ ! -d ${escapeShellArg path} ]; then
            git clone --mirror ${escapeShellArg mirrorUrl} ${escapeShellArg path}
          else
            git -C ${escapeShellArg path} remote update
          fi
        '') (filter ({ autoMirror, ... }: autoMirror) repositories));

        serviceConfig = {
          Type             = "oneshot";
          User             = "git";
          WorkingDirectory = gitDirectory;

          # systemd-analyze security recommendations.
          PrivateDevices          = true;
          ProtectClock            = true;
          ProtectKernelLogs       = true;
          RemoveIPC               = true;
          NoNewPrivileges         = true;
          ProtectControlGroups    = true;
          ProtectKernelModules    = true;
          MemoryDenyWriteExecute  = true;
          SystemCallArchitectures = [ "native" ];
          ProtectHostname         = true;
          ProtectSystem           = "strict";
          ReadWritePaths          = [ gitDirectory ];
          ProtectProc             = "invisible";
          LockPersonality         = true;
          RestrictRealtime        = true;
          ProcSubset              = "pid";
          ProtectHome             = true;
          PrivateUsers            = true;
          PrivateTmp              = true;
          SystemCallFilter        = [ "@system-service" "~@resources" "~@privileged" ];
          SystemCallErrorNumber   = "EPERM";
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          ProtectKernelTunables   = true;
          RestrictNamespaces      = true;
          RestrictSUIDSGID        = true;
          CapabilityBoundingSet   = "";
        };
      };
    };

    # Runs the auto-mirror service once a week.
    timers."auto-mirror" = {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
  };



  # cgit for viewing my git repos via the web.
  services.cgit."cgit" = {
    enable         = true;
    nginx.location = "/cgit";

    # See https://discourse.nixos.org/t/security-advisory-local-privilege-escalation-in-the-fcgiwrap-nixos-module-also-affecting-the-cgit-smokeping-and-zoneminder-modules/51419
    user  = "cgit";
    group = "cgit";

    repos = listToAttrs (builtins.map ({ path, description, section, ... }: {
      name  = path;
      value = {
        path    = "${gitDirectory}/${path}";
        desc    = description;
        section = mkIf (null != section) section;
      };
    }) repositories);

    settings = {
      # Converts the README files to HTML for display.
      about-filter = "${pkgs.cgit}/lib/cgit/filters/about-formatting.sh";
      # Fixes fetching of files under virtual root.
      css  = "/cgit/cgit-custom.css";
      logo = "/cgit/cgit.jpg";
      # Makes logo point to site homepage.
      logo-link = "/";
      # Cool commit graph.
      enable-commit-graph = 1;
      # Enables extra links in the index view to different parts of the repo.
      enable-index-links = 1;
      # Hides the "owner" of the repos since it's all just the git user.
      enable-index-owner = 0;
      # Custom footer.
      footer = "${cgitResources}/footer.html";
      # Hides email addresses, they can be annoying.
      noplainemail = 1;
      # Sets the README of the repos to the README.md of the default branch.
      readme = ":README.md";
      # Stuff that appears in the index page.
      root-desc   = "Do you have YOUR OWN git server? Didn't think so"; # lmao.
      root-readme = "${cgitResources}/README.md";
      root-title  = "cgit | paltepuk";
      # I like side-by-side diffs.
      side-by-side-diffs = 1;
      # Nice syntax highlighting.
      source-filter = "${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
      # No bots!
      robots = "none";
    };
  };

  services.nginx.virtualHosts."cgit" = {
    # Changes port of cgit instance.
    listen = [{
      addr = "127.0.0.1";
      port = ports.cgit;
    }];

    # Custom resources.
    locations = {
      "= /cgit/cgit.jpg".alias        = "${cgitResources}/logo.jpg";
      "= /cgit/cgit-custom.css".alias = "${cgitResources}/style.css";
    };
  };
}
