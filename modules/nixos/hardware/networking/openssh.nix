{ self, lib, config,... }:
let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;

  cfg = config.sylveon.system.networking.openssh;
  prof = config.sylveon.profiles;
in
{
  options.sylveon.system.networking.openssh = {
    loadKeys = {
      github.enable = mkOption {
        type = bool;
        default = true;
        description = ''Enable the github SSH key'';
      };

      bitbucket.enable = mkOption {
        type = bool;
        default = true;
        description = ''Enable the bitbucket SSH key'';
      };

      tangled.enable = mkOption {
        type = bool;
        default = true;
        description = ''Enable the tangled SSH key'';
      };
    };
  };

  config = {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;

      allowSFTP = true;

      openFirewall = true;
      ports = [ 22 ];

      settings = {
        PermitRootLogin = "no";

        # TODO: after setting up ssh
        # PasswordAuthentication = false;
        # KbdInteractiveAuthentication = false;
        # PubkeyAuthentication = "yes";
        # ChallengeResponseAuthentication = "no";
        # UsePAM = false;
        # UseDns = false;
        # X11Forwarding = false;

        # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "diffie-hellman-group-exchange-sha256"
          "mlkem768x25519-sha256"
          "sntrup761x25519-sha512"
        ];

        # Use Macs recommended by `nixpkgs#ssh-audit`
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];

        # kick out inactive sessions
        ClientAliveCountMax = 5;
        ClientAliveInterval = 60;

        # TODO
        # Banner = '''';
      };
    };

    age.secrets = {
      "ssh-github" = mkIf cfg.loadKeys.github.enable {
        rekeyFile = "${self}/secrets/ssh-gh.age";
        mode = "644";
        group = "users";
      };

      "ssh-bitbucket" = mkIf cfg.loadKeys.bitbucket.enable {
        rekeyFile = "${self}/secrets/ssh-bb.age";
        mode = "644";
        group = "users";
      };

      "ssh-tangled" = mkIf cfg.loadKeys.tangled.enable {
        rekeyFile = "${self}/secrets/ssh-tangled.age";
        mode = "644";
        group = "users";
      };
    };
  };
}