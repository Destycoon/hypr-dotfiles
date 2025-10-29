import Quickshell.Io
import Quickshell
import QtQuick

QtObject {
    id: wallpaperService

    readonly property string folder: "/home/destycoon/.config/theme/"

    property ListModel imageModel: imageModel {}
    ListModel {
        id: imageModel
    }
    Process {
        id: find
        command: ["find", folder, "-type", "f", "-name", "wallpaper.png"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.split("\n").filter(l => l.length > 0);

                imageModel.clear();
                for (let path of lines) {
                    imageModel.append({
                        path: "file://" + path
                    });
                }
            }
        }
    }

    function refreshWallpapers() {
        find.running = true;
    }

    function setWallpaper(path) {
        swww.path = path;
        swww.running = true;
    }

    Component.onCompleted: refreshWallpapers()
}
