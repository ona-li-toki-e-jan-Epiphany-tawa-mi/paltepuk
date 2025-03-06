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

# Installs and configures an I2P node for accessing the services via I2P.

# NOTE: Make sure to set services.i2pd.bandwidth.

{ lib, ports, pkgs-unstable, pkgs, extraPorts, auth, config, ... }:

let
  inherit (lib) mkForce;
  inherit (builtins) toString;
  inherit (pkgs) writeShellApplication writeText;

  i2pdDirectory = "/var/lib/i2pd";
in {
  # Allows conenctions from peers
  networking.firewall = with extraPorts; {
    allowedUDPPorts = [ i2pd ];
    allowedTCPPorts = [ i2pd ];
  };

  # For monitoring the web console.
  users.users."epiphany".packages = [
    (writeShellApplication {
      name = "i2pd-status";
      runtimeInputs = with pkgs; [ lynx ];
      derivationArgs.allowSubstitutes = false;

      text = ''
        lynx 127.0.0.1:${toString ports.i2pdConsole}
      '';
    })
  ];

  # We do all this stuff instead of using services.i2pd because it doesn't
  # support setting the type of tunnel, only server for in-tunnels and client
  # for out-tunnels.

  users.users.i2pd = {
    group = "i2pd";
    description = "I2Pd User";
    home = i2pdDirectory;
    createHome = true;
    uid = config.ids.uids.i2pd;
  };

  users.groups.i2pd.gid = config.ids.gids.i2pd;

  systemd.services.i2pd = let
    i2pdTunnelsConf = writeText "i2pd-tunnels.conf" ''
      [nginx]
      type = http
      host = 127.0.0.1
      port = 80
      keys = nginx-keys.dat
    '';

    i2pdConf = writeText "i2pd.conf" ''
      ipv4      = true
      ipv6      = true # Based.
      bandwidth = ${toString config.services.i2pd.bandwidth}
      port      = ${toString extraPorts.i2pd}

      # Web console.
      [http]
      address = 127.0.0.1
      port    = ${toString ports.i2pdConsole}
      auth    = true
      user    = ${auth.i2pd.username}
      pass    = ${auth.i2pd.password}

      # Disables HTTP proxy.
      [httpproxy]
      enabled = false
      # Disables SOCKS proxy.
      [socksproxy]
      enabled = false
      # Disables SAM interface.
      [sam]
      enabled = false
      # Disables I2CP interface.
      [i2cp]
      enabled = false

      # Enables more caching.
      [precomputation]
      elgamal = true

      # Disables addressbook since we just want to run services.
      [addressbook]
      enabled = false
    '';
  in {
    description = "Minimal I2P router";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs-unstable.i2pd ];

    script = ''
      i2pd --service --conf=${i2pdConf} --tunconf=${i2pdTunnelsConf}
    '';

    serviceConfig = {
      User = "i2pd";
      WorkingDirectory = i2pdDirectory;
      Restart = "on-abort";

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
      ReadWritePaths = [ i2pdDirectory ];
      ProtectProc = "invisible";
      LockPersonality = true;
      RestrictRealtime = true;
      ProcSubset = "pid";
      ProtectHome = true;
      PrivateUsers = true;
      PrivateTmp = true;
      SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
      SystemCallErrorNumber = "EPERM";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      ProtectKernelTunables = true;
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      CapabilityBoundingSet = "";
    };
  };
}
