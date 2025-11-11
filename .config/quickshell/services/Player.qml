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
    property string len: active ? formatTime(active.length) : "--:--"
    property real length: active ? active.length : 0.0
    property string pos: (active && active.playbackState !== MprisPlaybackState.Stopped) ? formatTime(active.position) : "--:--"
    property real progress: (active && active.playbackState !== MprisPlaybackState.Stopped) ? (active.position / active.length) : 0.0
    property bool hasNext: active ? active.canGoNext : false
    property bool hasPrev: active ? active.canGoPrevious : false

    Timer {
        running: root.active && root.active.playbackState == MprisPlaybackState.Playing
        interval: 1000
        repeat: true
        onTriggered: {
            if (root.active && root.active.playbackState !== MprisPlaybackState.Stopped) {
                root.pos = root.formatTime(root.active.position);
                root.progress = root.active.position / root.active.length;
            }
        }
    }

    Connections {
        target: root.active
        function onPlaybackStateChanged(): void {
            if (!root.active || root.active.playbackState == MprisPlaybackState.Stopped) {
                root.pos = "--:--";
                root.progress = 0.0;
            }
        }
    }

    function formatTime(time: real): string {
        let minutes = Math.floor(time / 60);
        let seconds = Math.floor(time % 60);
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
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

    function seek(position: real) {
        if (active != null) {
            active.position = position;
        }
    }

    function seekRelative(offset: real) {
        if (active != null) {
            active.position = Math.max(0, Math.min(active.length, active.position + offset));
        }
    }
}
