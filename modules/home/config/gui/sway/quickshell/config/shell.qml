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
      SystemStats.sample();   // fresh values (only file reads)
      return JSON.stringify({
        audio: {
          volume: Pipewire.sinkVolume,
          muted: Pipewire.sinkMuted,
          exclusive: Pipewire.sinkExclusive,
          owner: AlsaExclusive.owner,
          outputs: Pipewire.sinks.length,
          player: Mpris.selectedPlayer?.identity ?? null
        },
        network: { wifi: Network.wifiEnabled, connected: Network.activeWifi?.name ?? null, icon: Network.icon },
        bluetooth: { enabled: Bluetooth.enabled, connected: Bluetooth.connected.length },
        tailscale: { available: Tailscale.available, state: Tailscale.backendState, peers: Tailscale.peers.length },
        brightness: { available: Brightness.available, value: Brightness.value },
        power: {
          present: Power.present,
          percent: Power.percent,
          raw: Power.rawPercent,
          fullAt: Power.fullAt,
          charging: Power.charging,
          full: Power.full,
          profile: Power.profile
        },
        framework: {
          available: FrameworkTool.available,
          chargeLimit: FrameworkTool.chargeLimit,
          micSwitchOn: FrameworkTool.micSwitchOn,
          cameraSwitchOn: FrameworkTool.cameraSwitchOn,
          bay: FrameworkTool.bayModule,
          firmware: FrameworkTool.firmware.length
        },
        system: {
          cpuUsage: SystemStats.cpuUsage,
          memUsedGiB: SystemStats.memUsedGiB,
          cpuTemp: SystemStats.cpuTemp,
          igpuTemp: SystemStats.igpuTemp,
          nvmeTemp: SystemStats.nvmeTemp,
          dgpuAwake: SystemStats.dgpuAwake
        },
        privacy: { mic: Privacy.micApps, camera: Privacy.cameraApps, cameraPresent: Privacy.cameraPresent },
        notifications: { count: Notifications.count, dnd: Notifications.doNotDisturb },
        gameMode: { active: GameMode.active, main: GameMode.mainOutput },
        keepAwake: IdleInhibit.enabled
      });
    }
  }
}
