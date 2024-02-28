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

# Hardware config for a Raspberry Pi 3B+

{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix")
            ];



  # Bandwidth limits for I2P router and Tor relay. CPU bound.
  services.i2pd.bandwidth = 3000;                 # 3 MB/s
  services.tor.settings   = {
    "BandwidthRate"  = "3 MBytes";
    "BandwidthBurst" = "4 MBytes";
  };



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

  # NixOS wants to enable GRUB by default.
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf.
  boot.loader.generic-extlinux-compatible.enable = true;
  # Steps up the CPU frequency.
  boot.loader.raspberryPi.firmwareConfig = [ "force_turbo=1" ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  networking.interfaces.eno0.useDHCP = lib.mkDefault true; # I only use ethernet with this server.
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
