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

# Installs and configures a basic git server and a public web interface to view
# the repos.

{ pkgs, lib, ports, gitSSHKeys, ... }:

let
  inherit (lib) concatStrings mkIf escapeShellArg;
  inherit (builtins) listToAttrs;
  inherit (pkgs) callPackage;

  gitDirectory = "/srv/git";
  cgitResources = callPackage ./cgit { };

  # Names for the sections displayed in cgit.
  sections = {
    none = null;
    luanti = "Luanti Mods and Modpacks";
    library = "Libraries and Templates";
    game = "Games";
    terminal = "Terminal Applications";
    simulation = "Simulations";
    programmingLanguage = "Programming Languages";
    # My projects that mainly live on other sites.
    personalMirror = "Personal Mirrors (may contain Clearnet resources)";
  };

  # Declarative repositories for git and cgit.
  repositories = let
    standard = path: section: description: {
      path = "${path}.git";
      inherit description;
      inherit section;
    };

    personalMirror = path: description: {
      path = "${path}.git";
      inherit description;
      section = sections.personalMirror;
    };
  in [
    (standard "AkashicRecord" sections.none "Software graveyard monorepo")
    (standard "paltepuk" sections.none
      "Personal website and server wombo-combo")
    (standard "epitaphpkgs" sections.none "My personal package repository")

    (standard "COBOL-DVD-Thingy" sections.terminal
      "Terminal screensaver similar to that of DVD players")
    (standard "netcatchat" sections.terminal
      "A simple command-line chat server and client using netcat")
    (standard "love-you-mom" sections.terminal
      "Tells your mom (or dad) that you love them")
    (standard "AHD" sections.terminal "Hexdump utility")
    (standard "cowsAyPL" sections.terminal "Cowsay in GNU APL")
    (standard "play-music" sections.terminal "Simple command-line music player")

    (standard "BitMasher" sections.game
      "A fast-paced text adventure game inside a ransomware-infected computer")
    (standard "PyMSWPR" sections.game
      "A version of Minesweeper for the CASIO fx-9750GIII (и похожие)")

    (standard "fio.apl" sections.library "GNU APL ⎕FIO abstraction library")
    (standard "units" sections.library "Unit testing script templates")
    (standard "anal" sections.library "S(a)fety-Ta(n)t(a)mount C (L)ibrary")

    (standard "gigatools" sections.luanti
      "Gigatools for gigachads with gigaworkloads")
    (standard "elephant_veins" sections.luanti
      "Luanti mod that replaces small sporadic ore pockets with sparse, gigantic ore veins")
    (standard "slapperfishy" sections.luanti
      "High ordinance fish slapping. Hilarity ensues")

    (standard "multiply-by-n" sections.simulation
      "Cool animation made by drawing lines between moving points on a circle")
    (standard "hennaen" sections.simulation
      "Simple animation from random randomly colored circles")

    (standard "BASICfuck" sections.programmingLanguage
      "Brainfuck derivative for 6502 machines")

    (personalMirror "ona-li-toki-e-jan-Epiphany-tawa-mi"
      "poki pi nimi sona pi lipu KiApu mi | Mirror of https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/ona-li-toki-e-jan-Epiphany-tawa-mi")
  ];
in {
  ##############################################################################
  # git Server                                                                 #
  ##############################################################################

  programs.git = {
    enable = true;

    config = {
      init.defaultBranch = "master";

      # Globally removes "dubious ownership" check from the git repositories.
      safe.directory = [ "." ]
        ++ builtins.map ({ path, ... }: gitDirectory + "/" + path) repositories;
    };
  };

  # We login as the "git" user via ssh when using git.
  users = {
    users."git" = {
      isSystemUser = true;
      description = "git user";
      home = gitDirectory;
      shell = "${pkgs.git}/bin/git-shell";
      group = "git";

      openssh.authorizedKeys.keys = gitSSHKeys;
    };

    groups."git" = { };
  };

  services.openssh.settings.AllowUsers = [ "git" ];

  system.activationScripts."create-git-directory" = ''
    mkdir -p ${escapeShellArg gitDirectory}
    chown git:git ${escapeShellArg gitDirectory}
  '';

  # Creates any specified repositories if they don't already exist.
  systemd.services."create-repositories" = {
    description = "git repository creation service";
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ git ];

    script = ''
      # Shows executed commands.
      set -x
    '' + concatStrings (builtins.map ({ path, ... }: ''
      if [ ! -d ${escapeShellArg path} ]; then
        mkdir -p ${escapeShellArg path}
        git -C ${escapeShellArg path} init --bare
      fi
    '') repositories);

    serviceConfig = {
      Type = "oneshot";
      User = "git";
      WorkingDirectory = gitDirectory;

      # systemd-analyze security recommendations.
      PrivateDevices = true;
      ProtectClock = true;
      ProtectKernelLogs = true;
      RemoveIPC = true;
      NoNewPrivileges = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      MemoryDenyWriteExecute = true;
      SystemCallArchitectures = [ "native" ];
      ProtectHostname = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ gitDirectory ];
      ProtectProc = "invisible";
      LockPersonality = true;
      RestrictRealtime = true;
      ProcSubset = "pid";
      ProtectHome = true;
      PrivateNetwork = true;
      PrivateUsers = true;
      PrivateTmp = true;
      SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
      SystemCallErrorNumber = "EPERM";
      RestrictAddressFamilies = "none";
      ProtectKernelTunables = true;
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      IPAddressDeny = "any";
      CapabilityBoundingSet = "";
    };
  };

  ##############################################################################
  # cgit                                                                       #
  ##############################################################################

  services.nginx.virtualHosts."cgit" = {
    # Changes port of cgit instance.
    listen = [{
      addr = "127.0.0.1";
      port = ports.cgit;
    }];

    # Custom resources.
    locations = {
      "= /cgit/cgit.jpg".alias = "${cgitResources}/logo.jpg";
      "= /cgit/cgit-custom.css".alias = "${cgitResources}/style.css";
    };
  };

  services.cgit."cgit" = {
    enable = true;
    nginx.location = "/cgit";

    # See https://discourse.nixos.org/t/security-advisory-local-privilege-escalation-in-the-fcgiwrap-nixos-module-also-affecting-the-cgit-smokeping-and-zoneminder-modules/51419
    user = "cgit";
    group = "cgit";

    repos = listToAttrs (builtins.map ({ path, description, section, ... }: {
      name = path;
      value = {
        path = "${gitDirectory}/${path}";
        desc = description;
        section = mkIf (null != section) section;
      };
    }) repositories);

    settings = {
      # Converts the README files to HTML for display.
      about-filter = "${pkgs.cgit}/lib/cgit/filters/about-formatting.sh";
      # Fixes fetching of files under virtual root.
      css = "/cgit/cgit-custom.css";
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
      root-desc = "Do you have YOUR OWN git server? Didn't think so"; # lmao.
      root-readme = "${cgitResources}/README.md";
      root-title = "cgit | paltepuk";
      # I like side-by-side diffs.
      side-by-side-diffs = 1;
      # Nice syntax highlighting.
      source-filter = "${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
    };
  };
}
