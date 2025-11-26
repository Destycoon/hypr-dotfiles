pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.utils
import QtQuick.Effects
import qs.services
import qs.services.matugen
import QtQuick.Controls
import Quickshell.Io

StyledRect {
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
            pathItemCount: 3
            focus: true

            onCurrentIndexChanged: {
                wallpaperSelector.currentIndex = currentIndex;
            }

            delegate: Item {
                id: delegateItem
                required property var modelData
                required property int index

                width: pathView.currentIndex === delegateItem.index ? 450 : 150
                height: 350

                z: PathView.z

                Behavior on width {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }

                StyledRect {
                    id: mask
                    anchors.fill: parent
                    color: "#2a2a2a"
                    radius: 18
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

                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: mask
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1.0
                    }
                }
            }

            path: Path {
                startX: pathView.width * 0.1
                startY: pathView.height / 2

                PathAttribute {
                    name: "scale"
                    value: 0.5
                }
                PathAttribute {
                    name: "z"
                    value: 0
                }

                PathLine {
                    x: 0
                    y: pathView.height / 2
                }

                PathAttribute {
                    name: "scale"
                    value: 1.0
                }
                PathAttribute {
                    name: "z"
                    value: 10
                }

                PathLine {
                    x: pathView.width * 1.1
                    y: pathView.height / 2
                }

                PathAttribute {
                    name: "scale"
                    value: 0.5
                }
                PathAttribute {
                    name: "z"
                    value: 0
                }
            }

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            highlightRangeMode: PathView.StrictlyEnforceRange
            highlightMoveDuration: 300

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
