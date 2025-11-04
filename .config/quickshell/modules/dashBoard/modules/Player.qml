import QtQuick
import qs.utils
import qs.services
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    color: Colors.lightbg
    radius: 18
    implicitWidth: 380
    implicitHeight: 200

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        Item {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 120
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
                id: cover
                anchors.fill: parent
                source: Player.coverArt
                fillMode: Image.PreserveAspectCrop
                visible: source !== ""
                smooth: true
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: mask
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0
                }
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                StyledText {
                    text: Player.title || "Aucun titre"
                    font.bold: true
                    font.pixelSize: 15
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                }

                StyledText {
                    text: Player.artist || "Artiste inconnu"
                    font.pixelSize: 13
                    color: Colors.text
                    opacity: 0.7
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                }
                StyledText {
                    text: Player.len + "/" + Player.pos
                    font.pixelSize: 18
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                }
            }

            Item {
                Layout.fillHeight: true
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                Rectangle {
                    id: prev
                    implicitWidth: 44
                    implicitHeight: 44
                    radius: 22
                    color: playerPrevMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.1) : "transparent"

                    visible: Player.hasPrev
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    StyledText {
                        anchors.centerIn: parent
                        text: "󰒮"
                        font.pixelSize: 20
                        color: Colors.text
                    }

                    MouseArea {
                        id: playerPrevMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Player.previous()
                    }
                }

                Rectangle {
                    id: play
                    implicitWidth: 52
                    implicitHeight: 52
                    radius: 26
                    color: playerPlayMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.2) : Qt.rgba(255, 255, 255, 0.12)

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    StyledText {
                        anchors.centerIn: parent
                        text: Player.running ? "" : ""
                        font.pixelSize: 24
                        color: Colors.text
                    }

                    MouseArea {
                        id: playerPlayMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Player.playPause()
                    }
                }

                Rectangle {
                    id: next
                    implicitWidth: 44
                    implicitHeight: 44
                    radius: 22
                    color: playerNextMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.1) : "transparent"

                    visible: Player.hasNext
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    StyledText {
                        anchors.centerIn: parent
                        text: "󰒭"
                        font.pixelSize: 20
                        color: Colors.text
                    }

                    MouseArea {
                        id: playerNextMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Player.next()
                    }
                }
            }
        }
    }
}
