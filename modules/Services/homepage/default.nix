{
    servies.homepage-dashboard = {
        enable = true;
        listenPort = 3000;

        homepageLocation = ''https://semiko.dev'';

        settings = {
            title = ''Semiko'';
            headerStyle = ''clean'';
            target = ''_blank'';

            color = ''gray'';
            background = {
                image = ''https://images.unsplash.com/photo-1689351060804-fca36e095da4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1632&q=80'';
                blur = ''sm'';
            };
        };

        widgets = {
            search = {
                provider = [''google'' ''duckduckgo''];
                focus = true;
                target = ''_blank'';
            };

            resources = {
                label = ''Disks'';
                /*  TODO: ADD DISKS SOMEHOW */
            };

            datetime = {
                text_size = ''x1'';

                format = {
                    dateStyle = ''short'';
                    timeStyle = ''short'';
                    hourCycle = ''h23'';
                };
            };

            services = [
                {
                    "Remote" = [{
                        Nextcloud = {
                            href = ''https://cloud.semiko.dev'';
                            icon = ''nextcloud'';
                            description = ''Self-Hosted Cloud Platform'';
                            /* TODO: Add Server */
                        };

                        "Firefly 3" = {
                            href = ''https://cash.semiko.dev'';
                            icon = ''firefly'';
                            description = ''Finance managment software'';
                            /* TODO: Add Server */
                        };

                        "n8n" = {
                            href = ''https://n8n.semiko.dev'';
                            icon = ''n8n'';
                            description = ''Workflow automation tool'';
                            /* TODO: Add Server */
                        };

                        "Vaultwarden" = {
                            href = ''https://vault.semiko.dev'';
                            icon = ''vaultwarden'';
                            description = ''Password Manager Service'';
                            /* TODO: Add Server */
                        };

                        "GitLab" = {
                            href = ''https://git.semiko.dev'';
                            icon = ''gitlab'';
                            description = ''Git Server'';
                            /* TODO: Add Server */
                        };
                    }];

                    "Local (only with VPN)" = [{
                        "Nginx Proxy Manager" = {
                            href = ''http://192.168.1.126:81'';
                            icon = ''nginx-proxy-manager'';
                            description = ''Reverse proxy management'';
                            /* TODO: Add Server */
                        };

                        "Portainer" = {
                            href = ''http://192.168.1.126:81'';
                            icon = ''nginx-proxy-manager'';
                            description = ''Container managment platform'';
                            /* TODO: Add Server */
                        };
                        "Fritz!Box" = {
                            href = ''http://192.168.1.1'';
                            icon = ''avmfritzbox.png'';
                            description = ''Router configuration interface'';
                            /* TODO: Add Server */
                        };
                    }];



                }
            ];

        };
    };
}