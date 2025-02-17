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

# Installs and configures an SSH server.

{ ... }:

{
  services.fail2ban = {
    enable                   = true;
    bantime-increment.enable = true;
  };

  # Enables OpenSSH and forces key-based authentication.
  services.openssh = {
    enable       = true;
    openFirewall = true;

    settings = {
      PermitRootLogin        = "no";
      PasswordAuthentication = false;
      X11Forwarding          = false;
    };

    extraConfig = ''
      KbdInteractiveAuthentication no
      AuthenticationMethods publickey
      StreamLocalBindUnlink no
    '';

    banner = ''
      ACHTUNG!
      ALLES TURISTEN UND NONTEKNISCHEN LOOKENSPEEPERS!
      DAS KOMPUTERMASCHINE IST NICHT FÜR DER GEFINGERPOKEN UND MITTENGRABEN! ODERWISE IST EASY TO SCHNAPPEN DER SPRINGENWERK, BLOWENFUSEN UND POPPENCORKEN MIT SPITZENSPARKEN.
      IST NICHT FÜR GEWERKEN BEI DUMMKOPFEN. DER RUBBERNECKEN SIGHTSEEREN KEEPEN DAS COTTONPICKEN HÄNDER IN DAS POCKETS MUSS.
      ZO RELAXEN UND WATSCHEN DER BLINKENLICHTEN.

    '';
  };
}
