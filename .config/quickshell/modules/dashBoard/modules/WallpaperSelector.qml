import QtQuick
import QtQuick.Layouts
import qs.services
import qs.utils
import Quickshell.Io
import QtQuick.Effects

Rectangle {
    id: container
    color: "transparent"
    implicitWidth: 440
    implicitHeight: 170

    ListModel {
        id: imageModel
    }

    Component.onCompleted: find.running = true
    Process {
        id: find
        command: ["find", "/home/destycoon/.config/theme/", "-type", "f", "-name", "wallpaper.png"]
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
    Process {
        id: swww
        running: false
        property string path
        command: ["swww", "img", path, "--transition-type=center", "--transition-fps=60", "--transition-step=255", "--transition-duration=1.5"]
    }
    function setWallpaper(path) {
        swww.path = path;
        swww.running = true;
    }
    Rectangle {
        anchors.fill: parent
        radius: 20
        color: Colors.lightbg
        layer.enabled: true
        layer.samples: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            ListView {
                id: wallpaperList
                Layout.fillWidth: true
                Layout.preferredHeight: 110
                orientation: ListView.Horizontal
                spacing: 12
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                interactive: true
                snapMode: ListView.SnapToItem
                highlightFollowsCurrentItem: true

                model: imageModel
                delegate: Item {
                    width: 180
                    height: 100
                    Layout.alignment: Qt.AlignVCenter
                    Rectangle {
                        id: mask
                        anchors.fill: parent
                        radius: 12
                        color: Colors.darkbg
                        layer.enabled: true
                        layer.smooth: true
                    }
                    Image {
                        id: image
                        anchors.fill: parent
                        source: model.path
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        antialiasing: true
                        mipmap: true
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            maskEnabled: true
                            maskSource: mask
                            maskThresholdMin: 0.5
                            maskSpreadAtMin: 1.0
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var absolut = model.path.replace("file://", "");
                            setWallpaper(absolut);
                        }
                    }
                }
            }
        }
    }
}
