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
> Some Home-Manager Modules will only be activated if you activate the corresponding NixOS configuration

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
- Huckleberry
  - Tower. Gaming, Programing, Drawing (maybe). All you can think about!

## Security
There are 2 places where the secrets are saved:
- secrets/
  - These are encrypted by my yubikey, if you ever rekey something from a new device these will be used

- systems/../../secrets/
  - These are encrypted by the system itself, there are only keys that are used from the system!

> [!Note]
> If you want to create a new Encryption, please do as follows:
> - Add it to the code (age.secrets)
> - go into a nix-shell (already created when building the system)
>   - edit the encryption (or generate it if it's a script)
>   - rekey that encryption (that way it will end up in the systems/../../secrets/ directory)

# Install Instructions
Some modules need manual changes before they can be used, otherwise they cant work.

---
## Credits
- [Jo](https://github.com/Jokiller230) Introduced me to NixOS and helped me out on the starting stages of the Nix Language!
