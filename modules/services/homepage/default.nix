{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.homepage;
in
{
    options.services.homepage = {
        enable = mkEnableOption "custom homepage service";
    };

    config = mkIf cfg.enable {
        services.homepage-dashboard = {
            enable = true;
            listenPort = 3000;

            settings = {
                title = ''Semiko'';
                headerStyle = ''clean'';

                color = ''gray'';
                background = {
                    image = ''https://images.unsplash.com/photo-1689351060804-fca36e095da4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1632&q=80'';
                    blur = ''sm'';
                };
            };

            widgets =
            [
                {
                   resources = {
                        label = ''System'';
                        cpu = true;
                        memory = true;
                        uptime = true;
                    };
                }

                {
                   resources = {
                        label = ''Disks'';
                        disk = [ "/" "/mnt/raid" ];
                    };
                }

                {
                    search = {
                        provider = [''google'' ''duckduckgo''];
                        focus = true;
                        target = ''_blank'';
                    };
                }
                {
                datetime = {
                    text_size = ''x1'';

                    format = {
                        dateStyle = ''short'';
                        timeStyle = ''short'';
                        hourCycle = ''h23'';
                        };
                    };
                }
            ];

            services =
            [
                {
                    "File Managment" =
                    [

                        {
                            "copyParty" = {
                                href = ''https://files.semiko.dev'';
                                icon = ''synology-photo-station'';
                                description = ''Manage and view Files! // Searching for replacment!'';
                            };
                        }

                        {
                            "Syncthing" = {
                                href = ''https://sync.semiko.dev'';
                                icon = ''syncthing'';
                                description = ''Sync Files Remotely!'';
                            };
                        }
                    ];
                }

                {
                    "Remote" =
                    [
                        # CopyParty
                        # Syncthing
                        # Soft-Server (?)
                        # Plex

                        {
                            "Firefly 3" = {
                                href = ''https://cash.semiko.dev'';
                                icon = ''firefly'';
                                description = ''Finance managment software'';
                            };
                        }

                        {
                            "Vaultwarden" = {
                                href = ''https://vault.semiko.dev'';
                                icon = ''vaultwarden'';
                                description = ''Password Manager Service'';
                            };
                        }
                    ];
                }

                {
                    "Local (only with VPN)" = [
                        {
                            "Fritz!Box" = {
                                href = ''http://192.168.1.1'';
                                icon = ''avmfritzbox'';
                                description = ''Router configuration interface'';
                                widget = {
                                    type = "fritzbox";
                                    url = "http://192.168.1.1/";
                                };
                                ping = "http://192.168.1.1/";
                            };
                        }
                    ];
                }
            ];

            bookmarks =
            [
                {
                    School =
                    [
                        {
                            "Office 360" = [{
                                icon = "mdi-file-edit";
                                href = "https://office.com";
                            }];
                        }
                        {
                            "Sharepoint" = [{
                                icon = "mdi-microsoft-sharepoint";
                                href = "https://btahaus-my.sharepoint.com/";
                            }];
                        }
                        {
                            "WebUntis" = [{
                                icon = "mdi-calendar-blank-multiple";
                                href = "https://webuntis.com/";
                            }];
                        }

                        {
                            "Anton" = [{
                                icon = "mdi-emoticon";
                                href = "https://anton.app/";
                            }];
                        }
                        {
                            "SUA Code" = [{
                                icon = "mdi-book";
                                href = "https://github.com/BreakingTV/09-U1";
                            }];
                        }
                    ];
                }
                {
                    Dotfiles =
                    [
                        {
                            "MyNixos" = [{
                                icon = "mdi-snowflake-variant";
                                href = "https://mynixos.com/";
                            }];
                        }
                        {
                            "Nixos Search" = [{
                                icon = "mdi-weather-snowy-heavy";
                                href = "https://search.nixos.org/";
                            }];
                        }
                        {
                            "Homemanager Options Search" = [{
                                icon = "mdi-home-flood";
                                href = "https://home-manager-options.extranix.com/";
                            }];
                        }
                        {
                            "Dotfiles" = [{
                                icon = "mdi-dots-circle";
                                href = "https://github.com/BreakingTV/dotfiles";
                            }];
                        }
                    ];
                }
            ];

        };

        services.nginx.virtualHosts."semiko.dev" = {
            forceSSL = true;
            useACMEHost = "semiko.dev";

            serverAliases = [ "www.semiko.dev" ];
            locations."/".proxyPass = "http://[::1]:3000";
            extraConfig = "proxy_ssl_server_name on;";
        };
    };
}