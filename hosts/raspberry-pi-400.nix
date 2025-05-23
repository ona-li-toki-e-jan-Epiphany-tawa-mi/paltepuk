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

# Hardware config for a Raspberry Pi 400.

{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "usbhid" ];

  ##############################################################################
  # Networking                                                                 #
  ##############################################################################

  # Bandwidth limits.
  services.i2pd.bandwidth = 1000; # 1 MB/s
  services.tor.settings = {
    BandwidthRate = "3 MBytes";
    BandwidthBurst = "4 MBytes";
  };

  # Enables networking.
  networking = {
    useDHCP = false;
    interfaces.end0.useDHCP = true;
  };

  ##############################################################################
  # File System                                                                #
  ##############################################################################

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024; # 8 GB.
  }];

  boot.loader = {
    # NixOS wants to enable GRUB by default.
    grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf.
    generic-extlinux-compatible.enable = true;
  };
}
