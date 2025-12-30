{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  # Graphics & Hardware
  hardware = {
    graphics.enable32Bit = true;
    bluetooth.enable = true;
  };

  # Desktop Environment (Pantheon)
  services.xserver.enable = true;
  # programs.xwayland.enable = true; # Note: Pantheon often prefers X11, keep eye on this if it bugs out
  services.desktopManager.pantheon.enable = true;
  
  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # User Account
  users.users.z890 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "docker" "libvirtd" ];
    packages = with pkgs; [ tree ];
  };

  # Programs (Modules)
  programs = {
    firefox.enable = true;
    git.enable = true;
    steam = {
      enable = true;
      protontricks.enable = true;
    };
  };
  
  virtualisation.docker.enable = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    curl
    wget
    # Wine 
    wineWowPackages.stagingFull
    winetricks
    # Container helpers
    distrobox
    # platform tools
    android-tools
  ];

  # Allow Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; 
}