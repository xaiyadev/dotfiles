{
  type = "server-stats";
  servers = [
    {
      type = "local";
      name = "Apricot";

      mountpoints = {
        "/mnt/raid" = {
          name = "/mnt/raid";
        };
      };
    }
  ];
}
