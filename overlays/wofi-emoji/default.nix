{ channels, ...  }:

final: prev: {
    # Will maybe be replaced in: https://github.com/BreakingTV/nur-packages, unclear because this is a temporary solution
    # use my forked version until https://github.com/Zeioth/wofi-emoji/pull/17 is merged
    wofi-emoji =
    let
      emojiJSON = prev.fetchurl {
        url = "https://raw.githubusercontent.com/muan/emojilib/refs/heads/main/dist/emoji-en-US.json";
        hash = "sha256-IoU9ZPCqvSPX4DmfC+r5MiglhFc41XMRrbJRL9ZNrvs=";
      };
    in prev.wofi-emoji.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "BreakingTV";
        repo = "wofi-emoji";
        rev = "97d582c5db09cec818322c5de4157b8498439ba5";
        hash = "sha256-6cJE2tgJeZex4sZ0V15ZBPuIBqXboCGpWuu9w1mEhtY=";
      };

      # adding replacing build urls
      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        cp wofi-emoji $out/bin

        runHook postInstall
      '';

      postPatch = ''
        substituteInPlace build.sh \
          --replace 'curl ${emojiJSON.url}' 'cat ${emojiJSON}'

        substituteInPlace wofi-emoji \
          --replace 'wofi' '${prev.wofi}/bin/wofi' \
          --replace 'wtype' '${prev.wtype}/bin/wtype' \
          --replace 'wl-copy' '${prev.wl-clipboard}/bin/wl-copy'
      '';

    });

}