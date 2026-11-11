pragma Singleton

import Quickshell
import Quickshell.Services.Mpris as QsMpris
import QtQuick

import '../data'

Singleton {
    id: root

    property list<QsMpris.MprisPlayer> players: QsMpris.Mpris.players.values.filter(player => player?.trackTitle != "")

    function isMusicPlayer(player): bool {
        const id = ((player?.identity ?? "") + " " + (player?.desktopEntry ?? "")).toLowerCase();
        return Config.musicPlayers.some(name => id.includes(name));
    }

    // Priority: playing beats paused; on equal playing state a music player beats everything else.
    // => an open music player always wins, unless it is paused and something else is playing.
    function score(player): int {
        return (player.isPlaying ? 2 : 0) + (isMusicPlayer(player) ? 1 : 0);
    }

    // In exclusive mode: the player that holds the audio device (matched by process name)
    readonly property QsMpris.MprisPlayer exclusivePlayer: {
        const owner = AlsaExclusive.owner.toLowerCase();
        if (owner === "") return null;
        return players.find(player => {
            const ids = [player.identity, player.desktopEntry].filter(id => id).map(id => id.toLowerCase());
            return ids.some(id => id.includes(owner) || owner.includes(id));
        }) ?? null;
    }

    // the exclusive player always wins; otherwise by score
    readonly property QsMpris.MprisPlayer selectedPlayer: {
        if (exclusivePlayer) return exclusivePlayer;
        let best = null;
        for (const player of players) {
            if (best === null || score(player) > score(best)) best = player;
        }
        return best;
    }

    // Icon of the selected player (SONE reports a desktop entry id that doesn't match its
    // .desktop file, Chromium none at all, see Apps.entryFor)
    readonly property string playerIconPath: Apps.iconPath(selectedPlayer?.desktopEntry ?? "", selectedPlayer?.identity ?? "", "audio-x-generic")
}
