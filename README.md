# Breaking's Nixos Configuration! (v2)
v2 of my Nixos Configuration. Rewritten and more organized!

## Difference between v1 and v2
- A new and more Organized File Structure
- More automized installation
- Better written nix files

## User and System Information
> [!NOTE]
> Not every System will have the same Users or Setup, because I sometimes don't need to have some accounts on different Systems...

There will be 4 Users:
- Semiko - The Main Account, where most of the coding happens
- Oksana - 2nd Account, for my family members
- Gamerholic (name WIP) - All the Gaming stuff (besides Riot Games...)
- Workaholic - All Work related projects



## Installation

### Rebuild commands
> [!WARNING]
> If you get the error "cant install not pure..." then use the `--impure` argument

This process requirs you to have nixos already installed and flakes supported
- `sudo nixos-rebuild switch --flake .#nixos-laptop` Rebuild configuration for laptop systems
- `sudo nixos-rebuild switch --flake .#nixos-tower` Rebuid configuration for tower
- `sudo nixos-rebuild switch --flake .#nixos-server` Rebuild configuration for Server

### Other ways to install
> [!IMPORTANT]
> In the near future their will be (hopefully) an option to install the entire system with Windows as an ISO file!


## Special Thanks
[Jo](https://github.com/Jokiller230) helped me a lot and introduced me to nixos!
