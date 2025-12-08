pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: selector

    property string wallpaperDir: "/home/destycoon/.config/wallpaper/"
    property string searchQuery: ""
    property var wallpaperList: []
    property var filteredWallpaperList: {
        if (searchQuery === "")
            return wallpaperList;
        return wallpaperList.filter(path => {
            const filename = path.split('/').pop();
            return filename.toLowerCase().includes(searchQuery.toLowerCase());
        });
    }
    property int currentIndex: 0

    signal wallpaperChanged(string path)

    function setWallpaper(path) {
        Quickshell.execDetached({
            command: ["sh", "-c", `matugen image ${path} `]
        });
        wallpaperChanged(path);
    }

    function applyCurrentWallpaper() {
        if (filteredWallpaperList.length > 0 && currentIndex >= 0 && currentIndex < filteredWallpaperList.length) {
            setWallpaper(filteredWallpaperList[currentIndex]);
        }
    }

    Component.onCompleted: {
        loadWallpapers();
    }

    function loadWallpapers() {
        wallpaperScanner.running = true;
    }

    Process {
        id: wallpaperScanner
        command: ["sh", "-c", `find -L ${selector.wallpaperDir} -type f -print`]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const wallList = text.trim().split('\n').filter(path => path.length > 0);
                selector.wallpaperList = wallList;
            }
        }
    }
}
