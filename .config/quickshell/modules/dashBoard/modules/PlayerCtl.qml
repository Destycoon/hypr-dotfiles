pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: player

    property list<MprisPlayer> avaliablePlayer: Mpris.players.values

    property MprisPlayer active: avaliablePlayer.find(p => p.isPlaying) ?? avaliablePlayer.find(p => p.canControl && p.canPlay) ?? null

    IpcHandler {
        target: "mpris"

        function list(): string {
            return player.avaliablePlayer.map(p => p.identity).join("\n");
        }
    }
}
