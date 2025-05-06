{
  wayland.windowManager.sway.config = {
    defaultWorkspace = "1";
    workspaceOutputAssign = [
      {
        output = [ "Philips Consumer Electronics Company PHL 272B4Q AU11526001821" "LG Electronics LG ULTRAFINE 203NTXR8L890" "eDP-2" ];
        workspace = "1";
      }

      {
        output = [ "Philips Consumer Electronics Company PHL 272B4Q AU11531001040" "LG Electronics LG ULTRAFINE 203NTFA8L891" ];
        workspace = "2";
      }

      { output = "eDP-2"; workspace = "3"; }
      { output = "eDP-2"; workspace = "4"; }
      { output = "eDP-2"; workspace = "5"; }
    ];
  };
}