import Quickshell
import QtQuick
import Quickshell.Services.UPower
import qs.utils

Item {
    id: container
    width: 40
    height: 40

    Rectangle {
        id: bat
        width: 40
        height: 40
        radius: 30
        color: "transparent"
        anchors.centerIn: parent

        property real percent: UPower.displayDevice.percentage

        Canvas {
            id: canvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.lineWidth = 3;
                ctx.lineCap = "round";

                var percent = Math.max(0, Math.min(1, bat.percent));
                var radius = Math.min(width, height) / 2 - ctx.lineWidth;
                var start = -Math.PI / 2;
                var end = start + (2 * Math.PI * percent);

                if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
                    ctx.strokeStyle = Colors.accentGreen;
                } else if (percent < 0.2) {
                    ctx.strokeStyle = Colors.accentRed;
                } else if (percent < 0.5) {
                    ctx.strokeStyle = Colors.accentYellow;
                } else {
                    ctx.strokeStyle = Colors.accent;
                }

                ctx.beginPath();
                ctx.arc(width / 2, height / 2, radius, start, end, false);
                ctx.stroke();

                ctx.font = "20px 'monospace'";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.fillStyle = Colors.text;

                var text = "";
                if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
                    text = "󰂄";
                } else if (UPower.displayDevice.state === UPowerDeviceState.Discharging) {
                    text = "󰁹";
                } else if (UPower.displayDevice.state === UPowerDeviceState.FullyCharged) {
                    text = "󰁹";
                } else {
                    text = "󰂃";
                }

                ctx.fillText(text, width / 2 - 0.1, height / 2 + 2);
            }
            Connections {
                target: UPower.displayDevice
                function onPercentageChanged() {
                    canvas.requestPaint();
                }
                function onStateChanged() {
                    canvas.requestPaint();
                }
            }
        }
    }
}
