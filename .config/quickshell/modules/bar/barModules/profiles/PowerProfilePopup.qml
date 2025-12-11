import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io
import qs.services.matugen
import qs.utils
import qs.config
import Quickshell.Services.UPower
import QtQuick.Shapes
import qs.utils.anim

Item {
    id: powerWindow

    visible: ShellContext.showPProfile || hideAnim.running
    implicitWidth: contentRect.width
    implicitHeight: contentRect.height
    z : -1
    anchors.left: parent.right
    anchors.rightMargin: 10
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10

    property real slideOffset: -contentRect.width - 60

    onVisibleChanged: {
        if (visible && ShellContext.showPProfile) {
            showAnim.start();
        }
    }

    Connections {
        target: ShellContext
        function onShowPProfileChanged() {
            if (!ShellContext.showPProfile) {
                hideAnim.start();
            }
        }
    }

    SequentialAnimation {
        id: showAnim

        Anim {
            target: powerWindow
            property: "slideOffset"
            to: 0
        }
    }

    SequentialAnimation {
        id: hideAnim

        Anim {
            target: powerWindow
            property: "slideOffset"
            to: -(contentRect.width + 60)
        }
    }

    readonly property color bg: Matugen.colors.getcolors(Matugen.colors.background)
    readonly property color btnBg: Matugen.colors.getcolors(Matugen.colors.primary)
    readonly property color btnFg: Matugen.colors.getcolors(Matugen.colors.on_primary)
    readonly property color btnBgSelected: Matugen.colors.getcolors(Matugen.colors.primary_container)
    readonly property color btnFgSelected: Matugen.colors.getcolors(Matugen.colors.on_primary_container)
    readonly property color surface: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)
    readonly property string status: {
        if (!UPower.displayDevice.isPresent) {
            return "No UPower Device";
        } else if (UPower.displayDevice.state == UPowerDeviceState.Charging) {
            return "Charging";
        } else if (UPower.displayDevice.state == UPowerDeviceState.FullyCharged) {
            return "Fully Charged";
        } else if (UPower.displayDevice.state == UPowerDeviceState.Discharging) {
            return "Discharging";
        } else {
            return "Unknown";
        }
    }

    function formatTime(seconds) {
        if (seconds <= 0 || !isFinite(seconds)) {
            return "N/A";
        }
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);

        if (hours > 0) {
            return hours + "h " + minutes + "m";
        } else {
            return minutes + "m";
        }
    }

    Shape {
        id: contentRect
        property real radius: 18
        width: col.width + 20
        height: col.height + 20

        preferredRendererType: Shape.CurveRenderer

        transform: Translate {
            x: powerWindow.slideOffset
        }

        ShapePath {
            strokeWidth: 0
            fillColor: bg

            startX: contentRect.radius
            startY: 0

            PathLine {
                x: contentRect.width - contentRect.radius
                y: 0
            }

            PathArc {
                x: contentRect.width
                y: contentRect.radius
                radiusX: contentRect.radius
                radiusY: contentRect.radius
                direction: PathArc.Clockwise
                
            }

            PathLine {
                x: contentRect.width
                y: contentRect.height - contentRect.radius
            }

            PathArc {
                x: contentRect.width + contentRect.radius
                y: contentRect.height
                radiusX: contentRect.radius
                radiusY: contentRect.radius
                direction: PathArc.Counterclockwise
            }

            PathLine {
                x: contentRect.radius
                y: contentRect.height
            }

            PathArc {
                x: 0
                y: contentRect.height - contentRect.radius
                radiusX: contentRect.radius
                radiusY: contentRect.radius
                direction: PathArc.Clockwise
            }

            PathLine {
                x: 0
                y: -contentRect.radius
            }

            PathArc {
                x: contentRect.radius
                y: 0
                radiusX: contentRect.radius
                radiusY: contentRect.radius
                direction: PathArc.Counterclockwise
            }
            
        }

        Column {
            id: col
            spacing: 10
            anchors.centerIn: parent

            StyledText {
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 18
                text: "Battery: " + (UPower.displayDevice.isPresent ? UPower.displayDevice.percentage * 100 + "%" : "N/A")
            }

            StyledText {
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 12
                text: {
                    if (status === "Charging") {
                        return "Time to full: " + formatTime(UPower.displayDevice.timeToFull);
                    } else if (status === "Discharging") {
                        return "Time to empty: " + formatTime(UPower.displayDevice.timeToEmpty);
                    } else if (status === "Fully Charged") {
                        return "Battery full";
                    } else {
                        return "Battery status unknown";
                    }
                }
            }

            StyledRect {
                id: info

                implicitWidth: parent.width

                implicitHeight: infoCol.implicitHeight + 20
                color: surface
                radius: 10

                Column {
                    id: infoCol
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Row {
                        width: parent.width
                        StyledText {
                            font.pixelSize: 14
                            width: parent.width / 2
                            text: "Status:"
                            horizontalAlignment: Text.AlignLeft
                        }
                        StyledText {
                            font.pixelSize: 14
                            width: parent.width / 2
                            text: UPower.displayDevice.isPresent ? status : "N/A"
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    Row {
                        width: parent.width
                        StyledText {
                            width: parent.width / 2
                            text: "Energy:"
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 14
                        }
                        StyledText {
                            width: parent.width / 2
                            text: UPower.displayDevice.isPresent ? UPower.displayDevice.energy.toFixed(2) + " W/h" : "N/A"
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: 14
                        }
                    }

                    Row {
                        width: parent.width
                        StyledText {
                            font.pixelSize: 14
                            width: parent.width / 2
                            text: "Charge Rate:"
                            horizontalAlignment: Text.AlignLeft
                        }
                        StyledText {
                            font.pixelSize: 14
                            width: parent.width / 2
                            text: UPower.displayDevice.isPresent ? UPower.displayDevice.changeRate.toFixed(2) + " W" : "N/A"
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }
            }

            Row {
                id: row
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    width: 60
                    height: 60
                    background: StyledRect {
                        radius: 12
                        color: surface
                        opacity: PowerProfiles.profile == PowerProfile.PowerSaver ? 1.0 : 0.6
                        border.width: PowerProfiles.profile == PowerProfile.PowerSaver ? 2 : 0
                        border.color: btnBg

                        StyledText {
                            anchors.centerIn: parent
                            font.pixelSize: 22
                            text: Lucide.icon_leaf
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                        Behavior on border.width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }
                    onClicked: PowerProfiles.profile = PowerProfile.PowerSaver
                }

                Button {
                    width: 60
                    height: 60
                    background: StyledRect {
                        radius: 12
                        color: surface
                        opacity: PowerProfiles.profile == PowerProfile.Balanced ? 1.0 : 0.6
                        border.width: PowerProfiles.profile == PowerProfile.Balanced ? 2 : 0
                        border.color: btnBg

                        StyledText {
                            anchors.centerIn: parent
                            font.pixelSize: 22
                            text: ""
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                        Behavior on border.width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }
                    onClicked: PowerProfiles.profile = PowerProfile.Balanced
                }

                Button {
                    width: 60
                    height: 60
                    background: StyledRect {
                        radius: 12
                        color: surface
                        opacity: PowerProfiles.profile == PowerProfile.Performance ? 1.0 : 0.6
                        border.width: PowerProfiles.profile == PowerProfile.Performance ? 2 : 0
                        border.color: btnBg

                        StyledText {
                            anchors.centerIn: parent
                            font.pixelSize: 22
                            text: Lucide.icon_zap
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                        Behavior on border.width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }
                    onClicked: PowerProfiles.profile = PowerProfile.Performance
                }
            }
        }
    }
}
