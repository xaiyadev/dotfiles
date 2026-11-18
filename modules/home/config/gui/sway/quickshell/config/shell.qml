//@ pragma IconTheme Adwaita

import Quickshell
import Quickshell.Io

import "modules"
import "services"

Scope {
  Bar { }
  Toasts { }

  // state of all services as JSON, for tests/smoke.sh and debugging:
  //   qs ipc -p ~/.config/quickshell call bar status
  IpcHandler {
    target: "bar"

    function status(): string {
      return JSON.stringify({
        audio: {
          volume: Pipewire.sinkVolume,
          muted: Pipewire.sinkMuted,
          outputs: Pipewire.sinks.length,
          player: Mpris.selectedPlayer?.identity ?? null
        },
        network: { wifi: Network.wifiEnabled, connected: Network.activeWifi?.name ?? null, icon: Network.icon },
        bluetooth: { enabled: Bluetooth.enabled, connected: Bluetooth.connected.length },
        power: {
          present: Power.present,
          percent: Power.percent,
          raw: Power.rawPercent,
          charging: Power.charging,
          full: Power.full
        },
        notifications: { count: Notifications.count, dnd: Notifications.doNotDisturb },
        keepAwake: IdleInhibit.enabled
      });
    }
  }
}
