pragma Singleton

import QtQuick
import Quickshell

Scope {
    id: root

    property bool powerOpen: false
    property bool dashOpen: false
    property bool launcherOpen: false

    property bool showPProfile: false

    property alias wal: wal.currentWall

    PersistentProperties {
        id: wal
        reloadableId: "Wallpaper"
        property string currentWall: "/home/destycoon/.config/wallpaper/pixelTree.png"
    }

    function toggleDash() {
        dashOpen = !dashOpen;
        powerOpen = false;
        launcherOpen = false;
    }
    function togglePower() {
        dashOpen = false;
        powerOpen = !powerOpen;
        launcherOpen = false;
    }
    function toggleLauncher() {
        dashOpen = false;
        powerOpen = false;
        launcherOpen = !launcherOpen;
    }
    function toggleProfile() {
        showPProfile = !showPProfile;
    }
}
