pragma ComponentBehavior: Bound
import QtQuick
import qs.services
import qs.services.matugen
import QtQuick.Effects
import QtQuick.Layouts

Item {
    id: imageItem
    Layout.preferredWidth: 140
    Layout.preferredHeight: 140
    Layout.alignment: Qt.AlignVCenter

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 18
        color: Matugen.colors.getcolors(Matugen.colors.surface_container)
        Item {
            id: disk
            layer.enabled: true
            layer.smooth: true
            anchors.fill: parent
            Rectangle {
                implicitWidth: parent.width - 40
                implicitHeight: parent.height - 40
                anchors.centerIn: parent
                radius: 70
                color: Matugen.colors.getcolors(Matugen.colors.surface_dim)
            }
        }

        Item {
            id: imageCenter
            anchors.fill: parent
            layer.enabled: true
            layer.smooth: true

            Rectangle {
                anchors.centerIn: parent
                implicitWidth: parent.width / 5
                implicitHeight: parent.width / 5
                radius: implicitWidth / 2
                color: Matugen.colors.getcolors(Matugen.colors.surface_container)
            }
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
                maskSource: disk
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskInverted: true
                    maskSource: imageCenter
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0
                }
            }
            RotationAnimation on rotation {
                from: imageItem.rotation
                to: imageItem.rotation + 360
                running: Player.running
                loops: Animation.Infinite
                duration: 2000
            }
        }
    }

    Item {
        id: tonearm
        z: 10
        anchors.right: container.right
        anchors.top: container.top
        anchors.rightMargin: -15
        anchors.topMargin: 10
        width: 60
        height: 80
        transformOrigin: Item.Top

        property real baseRotation: 0
        property real minRotation: 7
        property real maxRotation: 32
        property real progress: Player.progress

        rotation: Player.running ? minRotation + (maxRotation - minRotation) * progress : baseRotation

        Behavior on rotation {
            enabled: !Player.running || Math.abs(rotation - (minRotation + (maxRotation - minRotation) * progress)) > 5
            NumberAnimation {
                duration: 600
                easing.type: Easing.InOutQuad
            }
        }
        Rectangle {
            id: pivot
            width: 12
            height: 12
            radius: 6
            color: Matugen.colors.getcolors(Matugen.colors.primary)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }

        Rectangle {
            id: arm
            width: 4
            height: 60
            color: Matugen.colors.getcolors(Matugen.colors.on_surface)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: pivot.bottom
            anchors.topMargin: -1
        }

        Item {
            id: headshell
            width: 8
            height: 15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: arm.bottom
            anchors.topMargin: -1
            Rectangle {
                width: 8
                height: 12
                radius: 4
                color: Matugen.colors.getcolors(Matugen.colors.primary)
                anchors.top: parent.top
            }

            Rectangle {
                width: 2
                height: 5
                color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }
        }
    }
}
