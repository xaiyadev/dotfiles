# Xaiya's Configuration (v4)
My completely new and rewritten NixOS! [Nix Flakes](https://nixos.wiki/wiki/Flakes) are required

This configuration uses the [snowflake lib](https://github.com/snowfallorg/lib) for the file structure and flake usage

# Overview
## Structure
This Configuration is based on the snowflake lib folder structure, so its easy replicable

- `flake.nix` is the base file for everything. All things start and are managed from here
- `homes` is the folder where all home manager related, user content, is found. All users that are created will be found here
- `systems` all systems that this configuration has to offer can be found here
- `overlays` for tools that need other packages or build changes.

### Modules
- `modules/nixos` all nix configuration files can be found here
- `modules/home` all home manager configuration files can be found here

#### When should I use home/nixos
It is important to differentiate between home manager modules and nixos modules-
- Home Manager modules are for packages that are highly configurable  and user specific. All packages and modules that is software, like an IDE or a social platform should all be installed with home manager
- NixOS should contain all system relevant changes. Networking, locale and many other things should be managed via NixOS.
> [!WARNING]
> sometimes packages don't exist for home-manager, in that case software packages sadly need to be installed via the NixOS module

## Users and Systems
This configuration has different users and systems that could change from time to time.

### Users
- Xaiya
  - My account! I do the most part on that; Development; Streaming; School; etc.
- Workaholic (Name will probably be changed)
  - This account is used for all Work related stuff. I like to differentiate between work and private life so this is a perfect way to do it
- Semiko
  - Semiko is the user who controls and maintains the server and its configuration
  - The name comes from the russian word "family" and "co", meaning that some family members have access to this account

### Systems

> [!NOTE]
> This config is written in mind of the removal of Huckleberry!

- Pineapple
  - Laptop. This is mostly used for programming, school and work.
- Apricot
  - Server. This System is simply my Server, important day-to-day services like vault warden and firefly are hosted on here

## Security
All environment files are be managed via [agenix](https://github.com/ryantm/agenix)

> [!Note]
> If you would like to build this system yourself you simply can re-key the files and use your own content.
>
> Simply remove all .age files and execute `nix run github:ryantm/agenix -- --rekey`

# Install Instructions
Some modules need manual changes before they can be used, otherwise they cant work.

## ``modules/nixos/hardware/yubikey``
> [!Note]
> If you already have a generated key you should add it in the configuration instead of creating a new one

if you want to add your yubikey as a secure way to login and use sudo, you should look at the [Yubikey Nixos Wiki](https://nixos.wiki/wiki/Yubikey#pam_u2f)

There is described how you can do that with the "pam_u2f" method.

This method of encryption implements "U2F" (Universal Second Factor) protocol for encrypting your login.

If you want to add your own key, you should remove the ``~/.config/Yubico/u2f_keys`` file and then add your 

---
## Credits
- [Jo](https://github.com/Jokiller230) Introduced me to NixOS and helped me out on the starting stages of the Nix Language!
