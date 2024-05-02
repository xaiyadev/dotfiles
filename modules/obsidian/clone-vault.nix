{ stdenv }: stdenv.mkDerivation {
  pname = "obsidian-and-vault-installer";

  src = builtins.fetchGit {
    url = "https://git.semiko.dev/Synchroniser/obsidian-sync";
    ref = "main";
  };
  version = "0.0.1";
  unpackPhase = "true";
  installPhase = ''
         mkdir -p $out/bin
         mv * $out/bin
        echo "Done :D"
  '';
}