pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.utils
import QtQuick.Effects
import qs.services

Rectangle {
    id: root

    color: Colors.lightbg
    implicitWidth: 800
    implicitHeight: 400
    radius: 18
    focus: true

    // Instance de la logique métier
    property Wallpaper selector: Wallpaper {
        id: wallpaperSelector
        onCurrentIndexChanged: {
            pathView.currentIndex = currentIndex;
        }
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            wallpaperSelector.loadWallpapers();
            pathView.forceActiveFocus();
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
            model: wallpaperSelector.filteredWallpaperList
            pathItemCount: 7
            focus: true

            onCurrentIndexChanged: {
                wallpaperSelector.currentIndex = currentIndex;
            }

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
                            wallpaperSelector.setWallpaper(delegateItem.modelData);
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
                    wallpaperSelector.applyCurrentWallpaper();
                    event.accepted = true;
                }
                if (event.key === Qt.Key_Right) {
                    incrementCurrentIndex();
                }
                if (event.key === Qt.Key_Left) {
                    decrementCurrentIndex();
                }
            }
        }
    }
}
