import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.services
import qs.utils

Rectangle {
    id: container
    color: "transparent"
    implicitWidth: 440
    implicitHeight: 180

    Rectangle {
        anchors.fill: parent
        anchors.margins: 12
        radius: 20
        color: Colors.lightbg
        layer.enabled: true
        layer.samples: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

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
                model: Wallpaper.imageModel

                delegate: Rectangle {
                    id: itemRect
                    width: 150
                    height: 100
                    radius: 12
                    color: mouseArea.containsMouse ? "#313244" : "#181825"
                    smooth: true
                    border.width: 1
                    border.color: mouseArea.containsMouse ? "#6ea8ff" : "transparent"

                    //                    Image {
                    //                      anchors.fill: parent
                    //                    anchors.margins: 6
                    //                  source: model.path
                    //                fillMode: Image.PreserveAspectCrop
                    //              smooth: true
                    //            antialiasing: true
                    //          mipmap: true
                    //    }
                    Text {
                        text: model.path
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Wallpaper.setWallpaper(model.path);
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }
            }
        }
    }
}
