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

# Hardware config for a Raspberry Pi 3B+

{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix")
            ];



  # Bandwidth limits. Bound mainly by the lack of memory (1 GB,)
  services.i2pdContainer.bandwidth = 1024;        # 1 MB/s
  services.torContainer   = {
    bandwidthRate  = "3 MBytes";
    bandwidthBurst = "4 MBytes";
  };

  # No IPv6 ;(
  services.i2pdContainer.enableIPv6 = false;



  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  # Need a big swapfile for rebuilding (if not done remotely.)
  # Probably overkill.
  swapDevices = [{
    device = "/swapfile";
    size   = 8*1024;                              # 8 GB.
  }];



  boot.initrd.availableKernelModules = [ "usbhid" ];

  boot.loader = {
    # NixOS wants to enable GRUB by default.
    grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf.
    generic-extlinux-compatible.enable = true;
    # Steps up the CPU frequency.
    raspberryPi.firmwareConfig = [ "force_turbo=1" ];
  };

  networking = {
    # Enables networking.
    useDHCP                   = false;
    interfaces.enu1u1.useDHCP = true;
    # Sets interface to use for NAT.
    nat.externalInterface     = "enu1u1";
  };

  nixpkgs.hostPlatform = "aarch64-linux";
}
