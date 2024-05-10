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

# Installs and configures an I2P node for accessing the services via I2P.
# NOTE: you will have to create a file called "i2pd-port.nix" in the base of
# this project with the port for i2pd to use.

{ lib
, ports
, config
, vlan
, vlan6
, pkgs-unstable
, serviceNames
, directories
, uids
, gids
, ...
}:

let cfg = config.services.i2pdContainer;

    # Port to accept incoming connections from peers with.
    i2pdPort = (import ../i2pd-port.nix);
in
{
  options.services.i2pdContainer = with lib; with types; {
    bandwidth = mkOption {
      description = "The router bandwidth limit in KB/s.";
      type        = int;
    };
  };



  config = {
    # Dummy user to ensure the i2pd user are the same inside and out of the
    # container.
    users = {
      users.i2pd = {
        isSystemUser = true;
        description  = "I2Pd User";
        group        = "i2pd";
        uid          = uids.i2pd;
      };

      groups.i2pd.gid = gids.i2pd;
    };

    # Creates persistent directories for i2pd if they don't already exist.
    system.activationScripts."create-i2pd-bind-mounts" = ''
      mkdir -p ${directories.i2pd}
    '';

    networking.nat = {
      # Gives the i2pd container internet access.
      internalInterfaces = [ "ve-${serviceNames.i2pd}" ];

      # Forwards connections from peers to i2pd.
      forwardPorts = [
        {
          destination = "${vlan.i2pd}:${builtins.toString i2pdPort}";
          proto       = "tcp";
          sourcePort  = i2pdPort;
        }
        {
          destination = "${vlan.i2pd}:${builtins.toString i2pdPort}";
          proto       = "udp";
          sourcePort  = i2pdPort;
        }
        {
          destination = "[${vlan6.i2pd}]:${builtins.toString i2pdPort}";
          proto       = "tcp";
          sourcePort  = i2pdPort;
        }
        {
          destination = "[${vlan6.i2pd}]:${builtins.toString i2pdPort}";
          proto       = "udp";
          sourcePort  = i2pdPort;
        }
      ];
    };

    # Isolated container for i2pd to run in.
    containers."${serviceNames.i2pd}" = (import ./lib/default-container.nix {inherit vlan; inherit vlan6;}) // {
      localAddress  = vlan.i2pd;
      localAddress6 = vlan6.i2pd;

      # Mounts persistent directories.
      bindMounts."/var/lib/i2pd" = {
        hostPath   = directories.i2pd;
        isReadOnly = false;
      };

      config = { pkgs, ... }: {
        imports = [ ./lib/container-common.nix
                  ];



        users = {
          users.i2pd.uid  = uids.i2pd;
          groups.i2pd.gid = gids.i2pd;
        };

        # Sets permissions for bind mounts.
        systemd.tmpfiles.rules = [ "d /var/lib/i2pd 700 i2pd i2pd" ];

        networking.firewall = {
          allowedUDPPorts = [ i2pdPort ];
          allowedTCPPorts = [ i2pdPort ];
        };

        # For monitoring the web console.
        environment.shellAliases."status" = "sudo -u i2pd ${lib.getExe pkgs.lynx} 127.0.0.1:${builtins.toString ports.i2pdConsole}";

        services.i2pd = {
          package    = pkgs-unstable.i2pd;
          enable     = true;
          enableIPv6 = true;                      # Based.
          port       = i2pdPort;
          bandwidth  = cfg.bandwidth;

          # Normally this has a couple eepsites to pull domain names from, but we're
          # just using I2P for running "hidden" services.
          addressbook.subscriptions = lib.mkForce [];

          # Web console.
          proto.http = {
            enable = true;
            port   = ports.i2pdConsole;
          };

          inTunnels = {
            # I2P access for remote administration.
            "${serviceNames.ssh}" = {
              enable      = true;
              address     = vlan.host;
              port        = 22;
              destination = "";
            };

            # I2P access for the git SSH server.
            "${serviceNames.git}" = {
              enable      = true;
              address     = vlan.git;
              port        = 22;
              destination = "";
            };

            # I2P access to the reverse proxy.
            "${serviceNames.reverseProxy}" = {
              enable      = true;
              address     = vlan.reverseProxy;
              port        = 80;
              destination = "";
            };
          };
        };
      };
    };
  };
}
