pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer active: Mpris.players.values[0]

    property bool running: active ? active.isPlaying : false

    property string title: active ? (active.metadata["xesam:title"] || "Inconnu") : "Aucun lecteur"
    property string artist: active ? (active.metadata["xesam:artist"]?.[0] || "Artiste inconnu") : ""
    property string album: active ? (active.metadata["xesam:album"] || "") : ""
    property string coverArt: active ? (active.metadata["mpris:artUrl"] || "") : ""

    Component.onCompleted: {
        updateActive();
        if (active != null) {
            if (active.trackChanged) {
                updateActive();
            }
        }
    }

    function playPause() {
        if (active != null)
            active.togglePlaying();
    }

    function next() {
        if (active != null)
            active.next();
    }

    function previous() {
        if (active != null)
            active.previous();
    }

    function stop() {
        if (active != null)
            active.stop();
    }
}
