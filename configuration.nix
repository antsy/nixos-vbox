# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
 
{ config, pkgs, lib, ... }:
 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
 
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
 
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
 
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
 
  # Enable networking
  networking.networkmanager.enable = true;
 
  # Set your time zone.
  time.timeZone = "Europe/Helsinki";
 
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
 
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };
 
  # Enable the X11 windowing system.
  services.xserver.enable = true;
 
# Enable the XFCE + XMONAD desktop
  services.xserver = {
    displayManager.defaultSession = "xfce+xmonad";
    windowManager.xmonad = {
      enable = true;
      config = ''
        import XMonad
        import XMonad.Util.EZConfig (additionalKeys)
        main :: IO ()
        main = xmonad ''$ def
          ''\{ modMask = mod4Mask
          , terminal = "alacritty" }
          `additionalKeys`
          [ ( (mod4Mask,xK_p), spawn "rofi -show run" )
          ]
      '';
      enableContribAndExtras = true;
      extraPackages = haskellPackages: with haskellPackages; [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
    displayManager.lightdm.enable = true;
  };
 
  # Configure keymap in X11
  services.xserver = {
    layout = "fi";
    xkbVariant = "";
    desktopManager = {
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
      wallpaper = {
        combineScreens = false;
        mode = "fill";
      };
    };
  };
 
  # Configure console keymap
  console.keyMap = "fi";
 
  # Enable CUPS to print documents.
  services.printing.enable = true;
 
  # Enable sound with pulse audio.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  #security.rtkit.enable = true;
  #services.pipewire = {
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.antti = {
    isNormalUser = true;
    description = "antti";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  firefox
    #  thunderbird
    ];
  };
 
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 
  # VirtualBox stuff
  nixpkgs.config.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
 
  systemd.user.services = let
    vbox-client = desc: flags: {
      description = "VirtualBox Guest: ${desc}";
 
      wantedBy = [ "graphical-session.target" ];
      requires = [ "dev-vboxguest.device" ];
      after = [ "dev-vboxguest.device" ];
 
      unitConfig.ConditionVirtualization = "oracle";
 
      serviceConfig.ExecStart = "${config.boot.kernelPackages.virtualboxGuestAdditions}/bin/VBoxClient -fv ${flags}";
      };
  in {
    virtualbox-resize = vbox-client "Resize" "--vmsvga";
    virtualbox-clipboard = vbox-client "Clipboard" "--clipboard";
  };
 
  virtualisation.virtualbox.guest = {
    enable = true;
    x11 = true;
  };
 
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    file
    virtualbox
    alacritty
    git
    chromium
    rofi
  ];
 
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
 
  # List services that you want to enable:
 
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
 
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
 
}
 
