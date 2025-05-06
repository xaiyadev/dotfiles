{ lib, ... }:
let
  inherit (lib.lists) any;
  inherit (lib) optionals forEach;

  # Search in a list of users, who of these users are in a specific group
  # If the user has at least one of these groups, return true
  # inGroup :: array -> string -> bool
  hasGroup =
     groups: user:
       any (group: builtins.elem group user.extraGroups) groups;

  # Filters an array of usernames, leaving only the ones with root access
  # Uses the from above created "hasGroup"
  # filterTrustedUsers :: array -> array
  filterTrustedUsers =
    users: config:
      forEach users (user:
        optionals (hasGroup [ "wheel" ] config.users.users.${user}) user
      );

in
{ inherit hasGroup filterTrustedUsers; }
