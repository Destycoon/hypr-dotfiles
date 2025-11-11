import QtQuick
import qs.utils
import qs.services
import QtQuick.Layouts
import qs.services.matugen

Rectangle {
    id: root
    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)
    radius: 18
    implicitWidth: 380
    implicitHeight: 200

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        PlayerImage {}
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
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                }

                StyledText {
                    text: Player.artist || "Artiste inconnu"
                    font.pixelSize: 14
                    color: Colors.text
                    opacity: 0.7
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                }
                StyledText {
                    text: Player.pos + "/" + Player.len
                    font.pixelSize: 15
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    opacity: 0.6
                }
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
