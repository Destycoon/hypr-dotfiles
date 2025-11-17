pragma ComponentBehavior: Bound
import QtQuick
import qs.services
import qs.services.matugen
import QtQuick.Effects
import QtQuick.Layouts

Item {
    id: imageItem
    Layout.preferredWidth: 180
    Layout.preferredHeight: 180
    Layout.alignment: Qt.AlignVCenter

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 16
        color: Matugen.colors.getcolors(Matugen.colors.surface_container)

        Item {
            id: disk
            layer.enabled: true
            layer.smooth: true
            anchors.fill: parent

            Rectangle {
                implicitWidth: parent.width - 30
                implicitHeight: parent.height - 30
                anchors.centerIn: parent
                radius: implicitWidth / 2
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
                implicitWidth: parent.width / 4.5
                implicitHeight: parent.width / 4.5
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

            SequentialAnimation on rotation {
                running: Player.running
                loops: Animation.Infinite

                RotationAnimation {
                    from: cover.rotation
                    to: cover.rotation + 360
                    duration: 2500
                    easing.type: Easing.InQuad
                }

                RotationAnimation {
                    from: cover.rotation
                    to: cover.rotation + 360
                    duration: 1700
                    easing.type: Easing.Linear
                    loops: Animation.Infinite
                }
            }

            RotationAnimation on rotation {
                running: !Player.running && cover.rotation !== 0
                from: cover.rotation
                to: 0
                duration: 2500
                easing.type: Easing.OutQuad

                direction: RotationAnimation.Clockwise
            }
        }
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(255, 255, 255, 0.05)
                }
                GradientStop {
                    position: 0.5
                    color: "transparent"
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(0, 0, 0, 0.1)
                }
            }
        }
    }

    Item {
        id: tonearm
        z: 10
        anchors.right: container.right
        anchors.top: container.top
        anchors.rightMargin: -18
        anchors.topMargin: 12
        width: 75
        height: 100
        transformOrigin: Item.Top

        property real baseRotation: 0
        property real minRotation: 10
        property real maxRotation: 40
        property real progress: Player.progress

        rotation: Player.running ? minRotation + (maxRotation - minRotation) * progress : baseRotation

        Behavior on rotation {
            id: armAnim
            enabled: !Player.running || Math.abs(rotation - (minRotation + (maxRotation - minRotation) * progress)) > 5
            NumberAnimation {
                duration: 700
                easing.type: Easing.InOutQuad
            }
        }

        Rectangle {
            id: pivot
            width: 14
            height: 14
            radius: 7
            color: Matugen.colors.getcolors(Matugen.colors.primary)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.3)
                shadowBlur: 0.4
                shadowVerticalOffset: 2
            }
        }

        Rectangle {
            id: arm
            width: 5
            height: 75
            color: Matugen.colors.getcolors(Matugen.colors.on_surface)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: pivot.bottom
            anchors.topMargin: -2
            radius: 2
            smooth: true
        }

        Item {
            id: headshell
            width: 10
            height: 18
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: arm.bottom
            anchors.topMargin: -2

            Rectangle {
                width: 10
                height: 14
                radius: 5
                color: Matugen.colors.getcolors(Matugen.colors.primary)
                anchors.top: parent.top
            }

            Rectangle {
                width: 2.5
                height: 6
                color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                radius: 1
            }
        }
    }
}
