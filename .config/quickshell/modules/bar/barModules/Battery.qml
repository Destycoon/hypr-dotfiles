import QtQuick
import Quickshell.Services.UPower
import qs.services.matugen
import qs.utils
import QtQuick.Layouts

Item {
    id: container
    implicitWidth: 40
    implicitHeight: 70

    Rectangle {
        id: bat
        anchors.fill: parent
        radius: 20
        color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)

        property real percent: UPower.displayDevice.percentage
        property color batteryColor: {
            if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
                return Colors.accentGreen;
            } else if (percent < 0.2) {
                return Colors.accentRed;
            } else if (percent < 0.5) {
                return Colors.accentYellow;
            } else {
                return Colors.accent;
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 6

            Item {
                implicitWidth: 24
                implicitHeight: 24
                Layout.alignment: Qt.AlignHCenter

                Canvas {
                    id: progressRing
                    anchors.fill: parent

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);

                        var centerX = width / 2;
                        var centerY = height / 2;
                        var radius = Math.min(width, height) / 2 - 2;
                        var lineWidth = 2.5;

                        ctx.beginPath();
                        ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                        ctx.strokeStyle = Matugen.darkmode ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(0, 0, 0, 0.1);
                        ctx.lineWidth = lineWidth;
                        ctx.stroke();

                        var percent = Math.max(0, Math.min(1, bat.percent));
                        var startAngle = -Math.PI / 2;
                        var endAngle = startAngle + (2 * Math.PI * percent);

                        ctx.beginPath();
                        ctx.arc(centerX, centerY, radius, startAngle, endAngle, false);
                        ctx.strokeStyle = bat.batteryColor;
                        ctx.lineCap = "round";
                        ctx.lineWidth = lineWidth;
                        ctx.stroke();
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                        }
                    }
                }

                StyledText {
                    anchors.centerIn: parent
                    text: {
                        if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
                            return "󰂄";
                        } else if (UPower.displayDevice.state === UPowerDeviceState.FullyCharged) {
                            return "󰁹";
                        } else if (bat.percent < 0.1) {
                            return "󰂎";
                        } else if (bat.percent < 0.3) {
                            return "󰁺";
                        } else if (bat.percent < 0.5) {
                            return "󰁼";
                        } else if (bat.percent < 0.7) {
                            return "󰁾";
                        } else if (bat.percent < 0.9) {
                            return "󰂀";
                        } else {
                            return "󰁹";
                        }
                    }
                    font.pixelSize: 14
                    color: bat.batteryColor

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
            }

            StyledText {
                text: {
                    if (UPower.displayDevice.state === UPowerDeviceState.FullyCharged)
                        return "full";
                    else
                        return Math.round(bat.percent * 100) + "%";
                }
                font.pixelSize: 13
                font.bold: true
                color: Matugen.colors.getcolors(Matugen.colors.on_surface)
                opacity: 0.9
                Layout.alignment: Qt.AlignVCenter
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: Colors.accentGreen
            border.width: 2
            opacity: 0
            visible: UPower.displayDevice.state === UPowerDeviceState.Charging

            SequentialAnimation on opacity {
                running: UPower.displayDevice.state === UPowerDeviceState.Charging
                loops: Animation.Infinite

                NumberAnimation {
                    from: 0
                    to: 0.4
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    from: 0.4
                    to: 0
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: Colors.accentRed
            border.width: 2
            opacity: 0
            visible: bat.percent < 0.15 && UPower.displayDevice.state === UPowerDeviceState.Discharging

            SequentialAnimation on opacity {
                running: bat.percent < 0.15 && UPower.displayDevice.state === UPowerDeviceState.Discharging
                loops: Animation.Infinite

                NumberAnimation {
                    from: 0
                    to: 0.6
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    from: 0.6
                    to: 0
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Connections {
            target: UPower.displayDevice
            function onPercentageChanged() {
                progressRing.requestPaint();
            }
            function onStateChanged() {
                progressRing.requestPaint();
            }
        }
    }
}
