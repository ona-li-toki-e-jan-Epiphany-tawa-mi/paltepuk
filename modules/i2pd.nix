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

# Installs and configures an I2P node for accessing the services via I2P.
# NOTE: you will have to create a file called "i2pd-port.nix" in the base of
# this project with the port for i2pd to use.

{ lib, ports, config, vlan, ... }:

let cfg = config.services.i2pdContainer;

    # Port to accept incoming connections from peers with.
    i2pdPort = (import ../i2pd-port.nix);

    # Where to put the files for Tor on the host and in the container.
    i2pdHostDirectory      = "/mnt/i2pd";
    i2pdContainerDirectory = "/var/lib/i2pd";
    # Name for i2pd container and related facilities.
    i2pdContainer = "i2pd";

    # The name for the main administrative SSH service.
    sshServiceName  = "OpenSSH";
    # The name for git and it's related services to be under.
    gitServiceName  = "git";
    # The name for cgit and it's related services to be under.
    cgitServiceName = "cgit";
in
{
  options.services.i2pdContainer = with lib; with types; {
    bandwidth = mkOption {
      description = "The router bandwidth limit in KB/s.";
      type        = int;
    };

    enableIPv6 = mkOption {
      default     = true;                         # Based.
      description = "Whether to enable IPv6 connectivity.";
      type        = bool;
    };
  };



  config = {
    # Creates persistent directories for i2pd if they don't already exist.
    system.activationScripts."activateI2pd" = ''
      mkdir -m 700 -p ${i2pdHostDirectory}
    '';

    networking.nat = {
      # Gives the i2pd container internet access.
      internalInterfaces = [ "ve-${i2pdContainer}" ];

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
      ];
    };

    # Isolated container for i2pd to run in.
    containers."${i2pdContainer}" = {
      ephemeral = true;
      autoStart = true;

      # Mounts persistent directories.
      bindMounts."${i2pdContainerDirectory}" = {
        hostPath   = i2pdHostDirectory;
        isReadOnly = false;
      };

      # Creates isolated network.
      privateNetwork = true;
      hostAddress    = vlan.host;
      localAddress   = vlan.i2pd;

      config = { ... }: {
        # Sets permissions for bind mounts.
        systemd.tmpfiles.rules = [ "d ${i2pdContainerDirectory} 700 i2pd i2pd" ];

        # Lets incoming connections to i2pd through the container firewall.
        networking.firewall = {
          allowedUDPPorts = [ i2pdPort ];
          allowedTCPPorts = [ i2pdPort ];
        };

        services.i2pd = {
          enable     = true;
          enableIPv6 = cfg.enableIPv6;
          port       = i2pdPort;
          bandwidth  = cfg.bandwidth;

          # Normally this has a couple eepsites to pull domain names from, but we're
          # just using I2P for running "hidden" services.
          addressbook.subscriptions = lib.mkForce [];

          # Web console.
          proto.http = {
            enable = true;
            port   = ports.i2pdWebConsole;
          };

          inTunnels = {
            # I2P access for remote administration.
            "${sshServiceName}" = {
              enable      = true;
              address     = vlan.host;
              port        = 22;
              destination = "";
            };

            # I2P access for the git SSH server.
            "${gitServiceName}" = {
              enable      = true;
              address     = vlan.cgit;
              port        = 22;
              destination = "";
            };

            # I2P access for the cgit instance.
            "${cgitServiceName}" = {
              enable      = true;
              address     = vlan.cgit;
              port        = 80;
              destination = "";
            };
          };
        };

        system.stateVersion = "23.11";
      };
    };
  };
}
