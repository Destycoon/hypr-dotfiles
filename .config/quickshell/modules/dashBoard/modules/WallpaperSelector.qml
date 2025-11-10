pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.utils
import QtQuick.Effects
import qs.services
import qs.services.matugen
import QtQuick.Controls
import Quickshell.Io

Rectangle {
    id: root

    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)
    implicitWidth: 800
    implicitHeight: 400
    radius: 18
    focus: true

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
                    color: "#2a2a2a"
                    radius: 18
                    opacity: pathView.currentIndex === delegateItem.index ? 1 : 0.8
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
                var current = pathView.model[pathView.currentIndex];
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    wallpaperSelector.applyCurrentWallpaper();
                    Matugen.updateColor(pathView.model[pathView.currentIndex]);
                    event.accepted = true;
                }
                if (event.key === Qt.Key_Right) {
                    incrementCurrentIndex();
                    wallpaperSelector.applyCurrentWallpaper();
                    Matugen.updateColor(pathView.model[pathView.currentIndex]);
                }
                if (event.key === Qt.Key_Left) {
                    decrementCurrentIndex();
                    wallpaperSelector.applyCurrentWallpaper();
                    Matugen.updateColor(pathView.model[pathView.currentIndex]);
                }
            }
        }
    }
}
