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

# Sets up the Hydra continuous integration system.

# NOTE: You'll need to add an admin user via command line before anything else,
# which can be done by running the following command:
#     sudo -u hydra hydra-create-user <name> --full-name <full name> --email-address '<email address>' --password-prompt --role admin
# Once you have the admin user you can use them in the GUI to make more users.

{ ports
, system
, config
, lib
, ...
}:

let inherit (lib) remove;
    inherit (builtins) toString;

    inherit (config.boot) binfmt;

    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
in
{
  services.hydra = {
    enable             = true;
    hydraURL           = "http://127.0.0.1:${toString ports.hydraGUI}";
    notificationSender = "hydra@localhost";
    logo               = ./logo.jpg;

    # Allows leveraging binary cache, else we'd have to build everything
    # from scratch.
    useSubstitutes = true;

    extraConfig = ''
      <git-input>
        timeout = 3600
      </git-input>
    '';
  };

  # Allows cross-compilation to other architectures.
  boot.binfmt.emulatedSystems  = remove system supportedSystems;
  nix.settings.extra-platforms = binfmt.emulatedSystems;
  nix.buildMachines            = [{
    hostName = "localhost";
    systems  = supportedSystems;
  }];
}
