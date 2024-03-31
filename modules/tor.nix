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

{ ports, vlan, config, lib, pkgs-unstable, serviceNames, ... }:

let cfg = config.services.torContainer;
    # Where to put the files for Tor on the host and in the container.
    torHostDirectory      = "/mnt/tor";
    torContainerDirectory = "/var/lib/tor";
    # Name for tor container and related facilities.
    torContainer          = "tor";
    # The UID and GID to use for tor to ensure it owns the bind mounts.
    torUID                = 35;
    torGID                = 35;

    # The netcatchat client ports for the onion service.
    netcatchatClientPorts = builtins.map
      (x: {
        port   = x + ports.netcatchatClientRangeFrom;
        target = {
          addr = vlan.netcatchat;
          port = x + ports.netcatchatClientRangeFrom;
        };
      })
      (builtins.genList (x: x) (ports.netcatchatClientRangeTo - ports.netcatchatClientRangeFrom));
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
      mkdir -p ${torHostDirectory}
    '';

    # Gives the Tor container internet access.
    networking.nat.internalInterfaces = [ "ve-${torContainer}" ];

    # Isolated container for Tor to run in.
    containers."${torContainer}" = {
      ephemeral = true;
      autoStart = true;

      # Mounts persistent directories.
      bindMounts."${torContainerDirectory}" = {
        hostPath   = torHostDirectory;
        isReadOnly = false;
      };

      # Creates isolated network.
      privateNetwork = true;
      hostAddress    = vlan.host;
      localAddress   = vlan.tor;

      config = { pkgs, ... }: {
        users = {
          users.tor.uid  = torUID;
          groups.tor.gid = torGID;
        };

        # Sets permissions for bind mounts.
        systemd.tmpfiles.rules = [ "d ${torContainerDirectory} 700 tor tor" ];

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

            # Tor access for the cgit instance.
            "${serviceNames.cgit}".map = [{
              port  = 80;
              target = {
                addr = vlan.git;
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

        system.stateVersion = "23.11";
      };
    };
  };
}
