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

# Luanti server.

{ ports
, pkgs
, lib
, ...
}:

let inherit (lib) escapeShellArg concatStrings;

    game = {
      id     = "mineclonia";
      name   = "mineclonia";
      gitUrl = "https://codeberg.org/mineclonia/mineclonia";
    };

    # Mods to be fetched from /srv/git.
    mods = [
      "gigatools"
      "slapperfishy"
    ];
in
{
  networking.firewall.allowedUDPPorts = [ ports.luanti ];

  services.minetest-server = {
    enable = true;
    port   = ports.luanti;
    gameId = game.id;

    config = {
      # Administrator account.
      name = "epiphany";

      max_users = 5;

      server_name = "paltepuk Luanti Development Server";
      motd        = ''
        Server Rules:
        1. Keep the spam to a minimum.
        2. Try to not be too much of an asshole.
        3. I am not responsible for your actions.
      '';
    };
  };

  # Automatically installs and updates games and mods.
  systemd = {
    timers."update-luanti" = {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };

    services."update-luanti" =
      let minetestDirectory = "/var/lib/minetest/.minetest";
          gitDirectory      = "/srv/git";

          gamesDirectory = escapeShellArg "games";
          modsDirectory  = escapeShellArg "worlds/world/worldmods";
      in {
        description = "Luanti update service";
        wantedBy    = [];
        after       = [ "network.target" ];
        conflicts   = [ "minetest-server.service" ];
        path        = with pkgs; [ sudo git ];

        script =
          let worldInstallPath =
                "${gamesDirectory}/${escapeShellArg game.name}";
          in ''
            # Shows executed commands.
            set -x

            # Game.
            sudo -u minetest mkdir -p ${gamesDirectory}
            if [ ! -d ${worldInstallPath} ]; then
              sudo -u minetest git clone ${escapeShellArg game.gitUrl} \
                                         ${worldInstallPath}
            else
              sudo -u minetest git -C ${worldInstallPath} pull -r
            fi

            # Mods.
            sudo -u minetest mkdir -p ${modsDirectory}
          '' + concatStrings (builtins.map (mod:
            let sourcePath  = "${gitDirectory}/${escapeShellArg mod}.git";
                installPath = "${modsDirectory}/${escapeShellArg mod}";
            in ''
              if [ ! -d ${installPath} ]; then
                sudo -u minetest git clone ${sourcePath} ${installPath}
              else
                sudo -u minetest git -C ${installPath} remote update
              fi
            ''
          ) mods);

        serviceConfig = {
          ExecStopPost = "systemctl restart minetest-server.service";

          Type             = "oneshot";
          WorkingDirectory = minetestDirectory;

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
          ReadWritePaths          = [ minetestDirectory gitDirectory ];
          ProtectProc             = "invisible";
          LockPersonality         = true;
          RestrictRealtime        = true;
          ProcSubset              = "pid";
          ProtectHome             = true;
          PrivateTmp              = true;
          SystemCallFilter        =
            [ "@system-service" "~@resources" ];
          SystemCallErrorNumber   = "EPERM";
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
          ProtectKernelTunables   = true;
          RestrictNamespaces      = true;
          RestrictSUIDSGID        = true;
          CapabilityBoundingSet   = [ "CAP_SETUID" "CAP_SETGID" ];
        };
      };
  };
}
