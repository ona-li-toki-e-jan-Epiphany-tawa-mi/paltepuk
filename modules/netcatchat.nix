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
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with paltepuk. If not, see <https://www.gnu.org/licenses/>.

# Installs and configures a netcatchat server.

{ lib
, ports
, pkgs
, ...
}:

let inherit (lib) concatStringsSep escapeShellArg;
    inherit (builtins) genList toString;

    # The ports clients can connect on, concatenated into a string for
    # netcatchat.
    clientPorts = with ports.netcatchatClient; concatStringsSep " " (genList
      (x: toString (x + from))
      (to - from + 1));
in
{
  # Service to run a netcatchat server.
  systemd.services."netcatchat" = {
    description = "netcatchat server daemon";
    wantedBy    = [ "multi-user.target" ];
    path        = with pkgs.epitaphpkgs; [ netcatchat cowsaypl ];

    script = ''
      netcatchat -s -p ${toString ports.netcatchatServer} \
                 -c ${escapeShellArg clientPorts}         \
                 -m "\n$(cowsaypl -- +p 'Welcome %d, to netcatchat@paltepuk')\n"
    '';

    serviceConfig = {
      User        = "netcatchat";
      Group       = "netcatchat";
      DynamicUser = true;

      # Restarts every 4 hours.
      Restart       = "always";
      RuntimeMaxSec = "4h";

      # systemd-analyze security recommendations.
      PrivateDevices          = true;
      ProtectClock            = true;
      ProtectKernelLogs       = true;
      ProtectControlGroups    = true;
      ProtectKernelModules    = true;
      MemoryDenyWriteExecute  = true;
      SystemCallArchitectures = [ "native" ];
      ProtectHostname         = true;
      ProtectProc             = "invisible";
      LockPersonality         = true;
      RestrictRealtime        = true;
      ProcSubset              = "pid";
      ProtectHome             = true;
      PrivateUsers            = true;
      SystemCallFilter        = [
        "@system-service"
        "~@resources"
        "~@privileged"
      ];
      SystemCallErrorNumber   = "EPERM";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      ProtectKernelTunables   = true;
      RestrictNamespaces      = true;
      IPAddressDeny           = "any";
      IPAddressAllow          = [ "localhost" ];
      CapabilityBoundingSet   = "";
    };
  };
}
