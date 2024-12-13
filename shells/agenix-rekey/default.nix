{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,
    # You also have access to your flake's inputs.
    inputs,

    # The namespace used for your flake, defaulting to "internal" if not set.
    namespace,

    # All other arguments come from NixPkgs. You can use `pkgs` to pull shells or helpers
    # programmatically or you may add the named attributes as arguments here.
    pkgs,
    mkShell,
    ...
}:

mkShell { 
    packages = with pkgs; [ 
    # Add zsh if it does not exist yet
    zsh

    # Add agenix-rekey tool
    agenix-rekey 
    ];


    # Launch Zsh in this shell
    shellHook = ''${pkgs.zsh}/bin/zsh'';
}
