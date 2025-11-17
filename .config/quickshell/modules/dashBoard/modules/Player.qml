import QtQuick
import qs.utils
import qs.services
import QtQuick.Layouts
import qs.services.matugen
import QtQuick.Controls

Rectangle {
    id: root
    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)
    radius: 18
    implicitWidth: 400
    implicitHeight: 220

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        PlayerImage {
            id: img
            Layout.preferredWidth: 140
            Layout.preferredHeight: 140
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                StyledText {
                    text: Player.title || "Aucun titre"
                    font.bold: true
                    font.pixelSize: 18
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    maximumLineCount: 1
                }

                StyledText {
                    text: Player.artist || "Artiste inconnu"
                    font.pixelSize: 14
                    color: Colors.text
                    opacity: 0.65
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    maximumLineCount: 1
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Slider {
                    id: progressSlider
                    Layout.fillWidth: true
                    from: 0
                    to: Player.length
                    value: Player.active ? Player.active.position : 0
                    snapMode: Slider.NoSnap

                    property bool seeking: false

                    onPressedChanged: {
                        if (!pressed && seeking) {
                            Player.seek(value);
                            seeking = false;
                        } else if (pressed) {
                            seeking = true;
                        }
                    }

                    background: Rectangle {
                        x: progressSlider.leftPadding
                        y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 4
                        width: progressSlider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: Qt.rgba(255, 255, 255, 0.15)

                        Rectangle {
                            width: progressSlider.visualPosition * parent.width
                            height: parent.height
                            color: Colors.text
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        x: progressSlider.leftPadding + progressSlider.visualPosition * (progressSlider.availableWidth - width)
                        y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                        implicitWidth: 14
                        implicitHeight: 14
                        radius: 7
                        color: Colors.text
                        opacity: progressSlider.hovered ? 1 : 0.9
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    StyledText {
                        text: Player.pos
                        font.pixelSize: 12
                        opacity: 0.6
                        Layout.alignment: Qt.AlignLeft
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    StyledText {
                        text: Player.len
                        font.pixelSize: 12
                        opacity: 0.6
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 4
                spacing: 12

                Rectangle {
                    id: prevButton
                    implicitWidth: 40
                    implicitHeight: 40
                    radius: 20
                    color: playerPrevMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : "transparent"
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
                    id: playButton
                    implicitWidth: 50
                    implicitHeight: 50
                    radius: 25
                    color: playerPlayMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.22) : Qt.rgba(255, 255, 255, 0.15)

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                        }
                    }

                    scale: playerPlayMouse.pressed ? 0.95 : 1.0

                    StyledText {
                        anchors.centerIn: parent
                        text: Player.running ? "" : ""
                        font.pixelSize: 26
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
                    id: nextButton
                    implicitWidth: 40
                    implicitHeight: 40
                    radius: 20
                    color: playerNextMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : "transparent"
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
