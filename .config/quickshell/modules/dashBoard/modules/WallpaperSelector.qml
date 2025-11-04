pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.utils
import QtQuick.Effects

Rectangle {
    id: root

    color: Colors.lightbg
    implicitWidth: 800
    implicitHeight: 400
    radius: 18

    focus: true

    onActiveFocusChanged: {
        if (activeFocus) {
            pathView.forceActiveFocus();
        }
    }

    property string wallpaperDir: "/home/destycoon/.config/wallpaper/" // Change this
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

    Process {
        workingDirectory: root.wallpaperDir
        command: ["sh", "-c", `find -L ${root.wallpaperDir} -type f -print`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const wallList = text.trim().split('\n').filter(path => path.length > 0);
                root.wallpaperList = wallList;
            }
        }
    }
    RowLayout {

        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        PathView {
            id: pathView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.filteredWallpaperList
            pathItemCount: 7
            focus: true
            delegate: Item {
                id: delegateItem
                required property var modelData
                required property int index
                width: 400
                height: 300
                scale: PathView.scale
                z: PathView.z

                Rectangle {
                    id: mask
                    anchors.fill: parent
                    anchors.margins: 10
                    color: "#2a2a2a"
                    radius: 18
                    border.color: pathView.currentIndex === delegateItem.index ? "#4a9eff" : "transparent"

                    opacity: pathView.currentIndex === delegateItem.index ? 1 : 0.8
                    border.width: 3
                    layer.enabled: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            pathView.currentIndex = delegateItem.index;
                            Quickshell.execDetached({
                                command: ["sh", "-c", `swww img ${delegateItem.modelData} --transition-type=wipe --transition-fps=60 --transition-step=255 --transition-duration=1`]
                            });
                        }
                    }
                }
                Image {
                    anchors.fill: parent
                    anchors.margins: 3
                    source: "file://" + delegateItem.modelData
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true
                    mipmap: true
                    layer.enabled: true

                    opacity: pathView.currentIndex === delegateItem.index ? 1 : 0.8
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: mask
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1.0
                    }
                }
            }

            path: Path {
                startX: -100
                startY: pathView.height / 2

                PathAttribute {
                    name: "z"
                    value: 0
                }
                PathAttribute {
                    name: "scale"
                    value: 0.6
                }

                PathLine {
                    x: pathView.width / 2
                    y: pathView.height / 2
                }

                PathAttribute {
                    name: "z"
                    value: 10
                }
                PathAttribute {
                    name: "scale"
                    value: 1.0
                }

                PathLine {
                    x: pathView.width + 100
                    y: pathView.height / 2
                }

                PathAttribute {
                    name: "z"
                    value: 0
                }
                PathAttribute {
                    name: "scale"
                    value: 0.6
                }
            }

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    Quickshell.execDetached({
                        command: ["sh", "-c", `swww img ${root.filteredWallpaperList[pathView.currentIndex]} --transition-type=wipe --transition-fps=60 --transition-step=255 --transition-duration=1`]
                    });
                    event.accepted = true;
                }
                if (event.key === Qt.Key_Right)
                    incrementCurrentIndex();

                if (event.key === Qt.Key_Left)
                    decrementCurrentIndex();
            }
        }
    }
}
