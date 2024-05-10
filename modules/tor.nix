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

# Installs and configures the Tor daemon for running onion services with Nyx to
# monitor it.

{ ports
, vlan
, vlan6
, config
, lib
, pkgs-unstable
, serviceNames
, directories
, ...
}:

let cfg = config.services.torContainer;

    # The UID and GID to use for tor to ensure it owns the bind mounts.
    torUID                = 35;
    torGID                = 35;

    # The netcatchat client ports for the onion service.
    netcatchatClientPorts = builtins.map
      (port: {
        inherit port;
        target = {
          addr = vlan.netcatchat;
          inherit port;
        };
      })
      (builtins.genList
        (x: x + ports.netcatchatClient.from)
        (ports.netcatchatClient.to - ports.netcatchatClient.from));
in
{
  options.services.torContainer = with lib; with types; {
    bandwidthRate = mkOption {
      description = "Average maximum bandwidth for Tor. See BandwitdthRate in the man tor for details.";
      type        = str;
    };

    bandwidthBurst = mkOption {
      description = "Absolute maximum bandwidth for Tor. See BandwitdthBurst in the man tor for details.";
      type        = str;
    };
  };



  config = {
    # Dummy user to ensure the tor user are the same inside and out of the
    # container.
    users = {
      users.tor = {
        isSystemUser = true;
        description  = "Tor Daemon User";
        group        = "tor";
        uid          = torUID;
      };

      groups.tor.gid = torGID;
    };

    # Creates persistent directories for Tor if they don't already exist.
    system.activationScripts."create-tor-bind-mounts" = ''
      mkdir -p ${directories.tor}
    '';

    # Gives the Tor container internet access.
    networking.nat.internalInterfaces = [ "ve-${serviceNames.tor}" ];

    # Isolated container for Tor to run in.
    containers."${serviceNames.tor}" = (import ./lib/default-container.nix {inherit vlan; inherit vlan6;}) // {
      localAddress = vlan.tor;

      # Mounts persistent directories.
      bindMounts."/var/lib/tor" = {
        hostPath   = directories.tor;
        isReadOnly = false;
      };

      config = { pkgs, ... }: {
        imports = [ ./lib/container-common.nix
                  ];



        users = {
          users.tor.uid  = torUID;
          groups.tor.gid = torGID;
        };

        # Sets permissions for bind mounts.
        systemd.tmpfiles.rules = [ "d /var/lib/tor 700 tor tor" ];

        environment.shellAliases."status" = "sudo -u tor ${lib.getExe' pkgs.nyx "nyx"}";

        services.tor = {
          package = pkgs-unstable.tor;
          enable  = true;

          settings = {
            "ControlPort"    = ports.torControl;
            # Enables hardware acceleration.
            "HardwareAccel"  = 1;
            # Sets bandwidth limits.
            "BandwidthRate"  = cfg.bandwidthRate;
            "BandwidthBurst" = cfg.bandwidthBurst;
          };

          relay.onionServices = {
            # Tor access for remote administration.
            "${serviceNames.ssh}".map = [{
              port  = 22;
              target = {
                addr = vlan.host;
                port = 22;
              };
            }];

            # Tor access for the reverse proxy.
            "${serviceNames.reverseProxy}".map = [{
              port  = 80;
              target = {
                addr = vlan.reverseProxy;
                port = 80;
              };
            }];

            # Tor access for the netcatchat instance.
            "${serviceNames.netcatchat}".map = [{
              port  = ports.netcatchatServer;
              target = {
                addr = vlan.netcatchat;
                port = ports.netcatchatServer;
              };
            }] ++ netcatchatClientPorts;
          };
        };
      };
    };
  };
}
