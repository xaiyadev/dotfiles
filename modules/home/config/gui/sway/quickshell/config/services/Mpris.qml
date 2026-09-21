pragma Singleton

import Quickshell
import Quickshell.Services.Mpris as QsMpris
import QtQuick

Singleton {
    id: root

    property list<QsMpris.MprisPlayer> players: QsMpris.Mpris.players.values.filter(player => player?.trackTitle != "")
    property QsMpris.MprisPlayer selectedPlayer: players.length > 0 ? players[0] : null
}
