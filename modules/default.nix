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

# The default nix module that includes all parts of my website and server.

{ inputs
, lib
, system
, timeZone
, ...
}:

let inherit (lib) mkForce;
in
{
  imports = [ ./i2pd.nix
              ./tor.nix
              ./ssh.nix
              ./git
              ./epiphany.nix
              ./nginx.nix
              ./secrets
              ./cloudflared.nix
            ];



  security.sudo.execWheelOnly = true;



  nixpkgs.hostPlatform = system;

  # Enables flakes for truly reproduceable builds.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Adds the nixpkgs channel from the flake to the NIX_PATH, so one doesn't need
  # to be added manually.
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Automatically cleans up old snapshots and unneeded stuff in the nix store.
  nix = {
    optimise = {
      automatic = true;
      dates     = [ "weekly" ];
    };

    gc = {
      automatic  = true;
      dates      = "weekly";
      options    = "--delete-older-than 15d";
      persistent = true;
    };
  };



  networking.hostName = "paltepuk";

  time.timeZone = timeZone;

  # Selects internationalisation properties.
  i18n =
    let locale = "en_US.UTF-8";
    in {
      defaultLocale = locale;

      extraLocaleSettings = {
        LC_ADDRESS        = locale;
        LC_IDENTIFICATION = locale;
        LC_MEASUREMENT    = locale;
        LC_MONETARY       = locale;
        LC_NAME           = locale;
        LC_NUMERIC        = locale;
        LC_PAPER          = locale;
        LC_TELEPHONE      = locale;
        LC_TIME           = locale;
      };
    };



  # Baller CPU scheduler.
  services.system76-scheduler.enable = true;

  # Removes default packages.
  environment.defaultPackages = mkForce [];



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment? Yes, yes I did.
}
