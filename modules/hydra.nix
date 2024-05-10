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

# Sets up the Hydra continuous build system.

{ serviceNames
, vlan
, vlan6
, ports
, directories
, gids
, uids
, ...
}:

let # Where to mount the git repositories directory to in the container.
    gitDirectory = "/srv/git";
in
{
  # Dummy users to ensure they are the same inside and out of the container.
  users = {
    users = {
      hydra = {
        isSystemUser = true;
        description  = "Hydra";
        group        = "hydra";
        uid          = uids.hydra;
      };

      postgres = {
        isSystemUser = true;
        description  = "PostgreSQL server user";
        group        = "postgres";
        uid          = uids.postgres;
      };
    };

    groups = {
      hydra.gid    = gids.hydra;
      postgres.gid = gids.postgres;
    };
  };

  # Creates persistent directories for Hydra if they don't already exist.
  system.activationScripts."create-hydra-bind-mounts" = ''
    mkdir -p ${directories.hydraDatabase} ${directories.hydraState}
  '';

  # Isolated container for Hydra to run in.
  containers."${serviceNames.hydra}" = (import ./lib/default-container.nix {inherit vlan; inherit vlan6;}) // {
    localAddress  = vlan.hydra;
    localAddress6 = vlan6.hydra;

    bindMounts = {
      # Mounts the git repositories so Hydra can fetch and build them.
      "${gitDirectory}".hostPath = directories.gitRepositories;

      # Mounts persistent directories.
      "/var/lib/hydra" = {
        hostPath   = directories.hydraState;
        isReadOnly = false;
      };
      "/var/lib/postgresql" = {
        hostPath   = directories.hydraDatabase;
        isReadOnly = false;
      };
    };

    config = { ... }: {
      imports = [ ./lib/container-common.nix
                ];



      users = {
        users = {
          # Dummy user to have the bind-mounted git stuff show the correct user
          # and group. Not strictly neccessary.
          "${serviceNames.git}" = {
            isSystemUser = true;
            description  = "git user";
            group        = serviceNames.git;
            uid          = uids.git;
          };

          hydra.uid    = uids.hydra;
          postgres.uid = uids.postgres;
        };

        groups = {
          "${serviceNames.git}".gid = gids.git;
          hydra.gid                 = gids.hydra;
          postgres.gid              = gids.postgres;
        };
      };

      # Sets permissions for bind mounts.
      systemd.tmpfiles.rules = [ "d /var/lib/hydra      750 hydra    hydra"
                                 "d /var/lib/postgresql 750 postgres postgres"
                               ];

      # Lets connections to the Hydra web GUI through the container firewall.
      networking.firewall.allowedTCPPorts = [ ports.hydraGUI ];

      services.hydra = {
        enable             = true;
        hydraURL           = "http://127.0.0.1:${builtins.toString ports.hydraGUI}";
        notificationSender = "hydra@localhost";
        # Allows leveraging binary cache, else we'd have to build everything
        # from scratch.
        useSubstitutes     = true;

        # Forcefully set this to empty so it doesn't try to read from
        # /etc/nix/machines.
        buildMachinesFiles = [];
      };

      # Make the Hydra daemon download stuff over Tor for funsies.
      systemd.services."hydra-server".environment = {
        "http_proxy"  = "socks5h://${vlan.tor}:${builtins.toString ports.torSOCKS}";
        "https_proxy" = "socks5h://${vlan.tor}:${builtins.toString ports.torSOCKS}";
      };
    };
  };
}
