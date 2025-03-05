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

# Sets up nginx to serve the main site and also route to other webservers.
# Sets up PHPFPM for the site's API.

{ ports
, pkgs
, config
, lib
, ...
}:

let inherit (builtins) toString;
    inherit (lib) makeBinPath;
    inherit (pkgs) callPackage;

    inherit (config.services) nginx phpfpm;

    site                = "paltepuk";
    apiStorageDirectory = "/var/lib/paltepuk-api";
in
{
  ##############################################################################
  # nginx                                                                      #
  ##############################################################################

  # Lets connections to the reverse proxy through the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings  = true;
    recommendedOptimisation  = true;
    recommendedProxySettings = true;

    # Creates the ".onion available" button for Tor users.
    appendHttpConfig = ''
       add_header Onion-Location http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion$request_uri;
    '';

    virtualHosts."${site}" = {
      # ;).
      extraConfig = ''
        error_page 404 /404.html;
      '';

      locations = {
        "/".root = callPackage ../site {};

        # cgit instance path.
        "/cgit".return = "302 $scheme://$host/cgit/";
        "/cgit/"       = {
          proxyPass       = "http://127.0.0.1:${toString ports.cgit}/cgit/";
          proxyWebsockets = true;
        };

        # API path.
        "/api".return = "302 $scheme://$host/api/";
        "/api/"       = {
          root     = callPackage ../api {};

          extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass            unix:${phpfpm.pools."${site}".socket};
            include                 ${pkgs.nginx}/conf/fastcgi.conf;
          '';
        };

        # Browser games and simulations.
        "/game-and-simulations/multiply-by-n".return =
          "302 $scheme://$host/game-and-simulations/multiply-by-n/";
        "/game-and-simulations/multiply-by-n/".alias =
          "${callPackage ../packages/multiply-by-n.nix {}}/";

        # Programming resources.
        "/programming-resources-directory/gnucobol/documentation".return =
          "302 $scheme://$host/programming-resources-directory/gnucobol/documentation/";
        "/programming-resources-directory/gnucobol/documentation/".alias =
          "${pkgs.gnucobol.out}/share/doc/gnucobol/";
      };
    };
  };

  ##############################################################################
  # PHPFPM                                                                     #
  ##############################################################################

  users.users."phpfpm" = {
    isSystemUser = true;
    createHome   = true;
    home         = apiStorageDirectory;
    group        = "phpfpm";
  };
  users.groups."phpfpm" = {};

  # PHP (eww) CGI stuff for website API.
  services.phpfpm.pools."${site}" = {
    user  = "phpfpm";
    group = "phpfpm";

    phpEnv.PATH = with pkgs; makeBinPath [ php ];

    settings = {
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output"       = true;

      "listen.owner" = nginx.user;

      "pm"                   = "dynamic";
      "pm.max_children"      = 32;
      "pm.max_requests"      = 500;
      "pm.start_servers"     = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
    };
  };
}
