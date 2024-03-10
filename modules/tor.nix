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

# Installs and configures the Tor daemon for running onion services with Nyx to
# monitor it.

{ ports, vlan, config, lib, ... }:

let cfg = config.services.torContainer;
    # Where to put the files for Tor on the host and in the container.
    torHostDirectory      = "/mnt/tor";
    torContainerDirectory = "/var/lib/tor";

    # Name for tor container and related facilities.
    torContainer = "tor";

    # The name for cgit and it's related services to be under.
    cgitServiceName  = "cgit";
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
    # Creates persistent directories for Tor if they don't already exist.
    system.activationScripts."activateTor" = ''
      mkdir -m 700 -p ${torHostDirectory}
    '';

    # Gives the Tor container internet access.
    networking.nat.internalInterfaces = [ "ve-${torContainer}" ];

    # Isolated container for the Tor to run in.
    containers."${torContainer}" = {
      ephemeral      = true;
      autoStart      = true;

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
        # Sets permissions for bind mounts.
        systemd.tmpfiles.rules = [ "d ${torContainerDirectory} 700 tor tor" ];

        environment.systemPackages = [ pkgs.nyx ];

        services.tor = {
          enable = true;

          settings = {
            "ControlPort"    = ports.torControl;
            # Enables hardware acceleration.
            "HardwareAccel"  = 1;
            # Sets bandwidth limits.
            "BandwidthRate"  = cfg.bandwidthRate;
            "BandwidthBurst" = cfg.bandwidthBurst;
          };

          # Tor access for the cgit instance.
          relay.onionServices."${cgitServiceName}".map = [{
            port  = 80;
            target = {
              addr = vlan.cgit;
              port = 80;
            };
          }];
        };

        system.stateVersion = "23.11";
      };
    };
  };
}
