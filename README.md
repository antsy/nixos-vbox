# nixos-vbox

NixOS configuration that should work with VirtualBox, configuration enables dynamic resizing of vbox window and bi-directional copy+paste.

Useful for trying out NixOS, should save some googling time.

## How to use

* Install NixOS in VirtualBox, [download .iso](https://nixos.org/download#nixos-iso)
* Replace the `/etc/nixos/configuration.nix` with the [configuration.nix](configuration.nix)
* Edit the `/etc/nixos/configuration.nix` file
  * renaming user account with the one you created during installation should be enough
* [Rebuild Nixos](https://nixos.wiki/wiki/Nixos-rebuild)
* Enjoy your NixOS inside VirtualBox!

## Help!

Q: I see desktop background but there is no user interface

A: That's Xmonad, press <kbd>super</kbd> + <kbd>shift</kbd> + <kbd>enter</kbd> to open terminal or <kbd>super</kbd> +<kbd>p</kbd> to run any program.

## Hindsight

I just noticed there is official image to run NixOS inside VirtualBox: https://nixos.org/download#nixos-virtualbox
