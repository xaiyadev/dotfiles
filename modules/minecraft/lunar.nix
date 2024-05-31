{pkgs, ...}: {
        home.packages = with pkgs; [
            lunar-client
        ];

        # TODO: add options from .minecraft
}