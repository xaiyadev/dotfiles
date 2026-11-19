pragma Singleton

import Quickshell
import Quickshell.Services.Mpris as QsMpris
import QtQuick

import "../data"

Singleton {
    // players without a track (e.g. an idle browser tab) are left out
    readonly property list<QsMpris.MprisPlayer> players: QsMpris.Mpris.players.values.filter(player => (player?.trackTitle ?? "") !== "")

    function isMusicPlayer(player): bool {
        const id = ((player?.identity ?? "") + " " + (player?.desktopEntry ?? "")).toLowerCase();
        return Config.musicPlayers.some(name => id.includes(name));
    }

    // playing beats paused, and with the same playing state a music player beats everything else;
    // so an open music player always wins unless its paused and something else is playing
    function score(player): int {
        return (player.isPlaying ? 2 : 0) + (isMusicPlayer(player) ? 1 : 0);
    }

    readonly property QsMpris.MprisPlayer selectedPlayer: players.reduce((best, p) => !best || score(p) > score(best) ? p : best, null)

    // icon of the selected player; goes through the desktop entry lookup in Apps because SONE
    // reports an id that doesnt match its .desktop file and chromium sends none at all
    readonly property string playerIconPath: Apps.iconPath(selectedPlayer?.desktopEntry ?? "", selectedPlayer?.identity ?? "", "audio-x-generic")
}
