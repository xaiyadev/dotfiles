# Xayah's Configuration (v4)
My completly new and rewritten NixOS! [Nix Flakes](https://nixos.wiki/wiki/Flakes) are required

This configuration uses the [snowflake lib](https://github.com/snowfallorg/lib) for the file structure and flake usage

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
- Home Manager modules are for packages that are highly configuratable and user specific. All packages and modules that is software, like an IDE or a social platform should all be installed with home manager
- NixOS should contain all system relevant changes. Networking, locale and many other things should be managed via NixOS.
> [!WARNING]
> sometimes packages dont exist for home-manager, in that case software packages sadly need to be installen via the NixOS module

## Users and Systems
This configuration has different users and systems that could change from time to time.

### Users
- Xayah
  - My account! I do the most part on that; Development; Streaming; School; etc.
- Workaholic (Name will probably be changed)
  - This account is used for all Work related stuff. I like to differentiate between work and private life so this is a perfect way to do it
- Medea
  - Medea is a user that will not be used often, its for a family member so it can use my Computer.
  - **Notice: This account is temporay and will be removed when huckleberry is removed**


### Systems
- Pineapple
  - Laptop. This is mostly used for programming, school and work.
  - **Notice: This system will probably be the main after I get a new laptop**
- Huckleberry (Main)
  - Tower at home. This System is used for gaming and is dual booted with windows. Mostly I game on this System but from time to time I code on it too
- Apricot
  - Server. This System is simply my Server, important day to day services like vaultwarden and firefly are hosted on here

## Security
All environment files are be managed via [agenix](https://github.com/ryantm/agenix)

> [!Important]
> The Security will change after Huckleberry is removed, because then all the security lies on the Yubikey

> [!Note]
> If you would like to build this system yourself you simply can re-key the files and use your own content.
>
> Simply remove all .age files and execute `nix run github:ryantm/agenix -- --rekey`

## Features and Functions
- [ ] https://github.com/BreakingTV/dotfiles/issues/9 A deployment tool for keeping my system and my packages up to date, even without working on the configuration files
- [ ] https://github.com/BreakingTV/dotfiles/issues/10 A DevOPS tool for keeping the code clean and checking if all the systems can be build

## TODOs 
- [ ] https://github.com/BreakingTV/dotfiles/issues/11 Refactoring the Code from v3 to v4

---
## Credits
- [Jo](https://github.com/Jokiller230) Introduced me to NixOS and helped me out on the starting stages of the Nix Language!
