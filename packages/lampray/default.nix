{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,
    # You also have access to your flake's inputs.
    inputs,

    # The namespace used for your flake, defaulting to "internal" if not set.
    namespace,

    # All other arguments come from NixPkgs. You can use `pkgs` to pull packages or helpers
    # programmatically or you may add the named attributes as arguments here.
    pkgs,
    stdenv,
    ...
}:

stdenv.mkDerivation {
  pname = "lampray";
  version = "1.4.0-unstable-2024-05-25";

  src = pkgs.fetchFromGitHub {
    owner = "CHollingworth";
    repo = "Lampray";
    rev = "c549fbfbd6ad18b2eca0a6d17b6066d1f74c54b7";
    hash = "sha256-tjFxHU2kFS5yX0itm4rGKLE7lm/NMgsRjTEGykJELv8=";
  };

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.cmake
    pkgs.makeWrapper
    pkgs.ninja
    pkgs.pkg-config
  ];

  buildInputs = [
    pkgs.SDL2
    pkgs.curl
    pkgs.lz4
  ];

  postPatch = ''
    substituteInPlace Lampray/Control/lampConfig.cpp \
      --replace-fail '/usr/libexec/p7zip/7z.so' '${pkgs.p7zip.lib}/lib/p7zip/7z.so'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 Lampray $out/bin/lampray
    wrapProgram $out/bin/lampray \
      --prefix PATH : "${lib.makeBinPath [ pkgs.zenity ]}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mod manager for gaming on Linux";
    homepage = "https://github.com/CHollingworth/Lampray";
    license = with licenses; [
      unlicense
      mpl20 # bit7z
      mit # json & pugixml
      bsd2 # l4z
      gpl2Only # l4z
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ azahi ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "lampray";
  };
}
