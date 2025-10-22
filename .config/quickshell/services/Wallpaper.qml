import Quickshell.Io
import Quickshell
import QtQuick

QtObject {

    readonly property string folder: "/home/destycoon/.config/theme/"

    ListModel {
        id: imageModel
    }

    function refreshWallpapers() {
        find.command = ["find", folder, "-type", "f", "-name", "wallpaper.png"];
        find.running = true;
    }

    Process {
        id: find
        command: ["find", folder, "-type", "f", "-name", "wallpaper.png"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.split("\n").filter(l => l.length > 0);
                imageModel.clear();
                for (let path of lines)
                    imageModel.append({
                        path
                    });
            }
        }
    }

    Process {
        id: swww
        required property string path
        command: ["swww", "img", path, "--transition-type=center", "--transition-fps=60", "--transition-step=255", "--transition-duration=1.5"]
        running: false
    }

    function setWallpaper(path) {
        swww.path = path;
        swww.running = true;
    }

    Component.onCompleted: {
        refreshWallpapers();
    }
}
