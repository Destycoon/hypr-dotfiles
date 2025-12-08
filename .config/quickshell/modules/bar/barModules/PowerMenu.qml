import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import qs.services.matugen
import qs.utils
import qs.config
import qs.utils.anim

Item {
    id: powerWindow
    visible: ShellContext.powerOpen || hideAnim.running
    implicitWidth: contentRect.width
    implicitHeight: contentRect.height

    anchors.right: parent.right
    anchors.rightMargin: 10
    anchors.verticalCenter: parent.verticalCenter

    property real slideOffset: contentRect.width + 20

    onVisibleChanged: {
        if (visible && ShellContext.powerOpen) {
            showAnim.start();
        }
    }

    Connections {
        target: ShellContext
        function onPowerOpenChanged() {
            if (!ShellContext.powerOpen) {
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
            to: contentRect.width + 20
        }
    }

    Process {
        id: shutdownCmd
        command: ["shutdown", "now"]
    }
    Process {
        id: rebootCmd
        command: ["reboot"]
    }
    Process {
        id: lockCmd
        command: ["hyprlock"]
    }

    IpcHandler {
        target: "powerWindow"
        function toggle() {
            ShellContext.togglePower();
        }
    }

    Shape {
        id: contentRect
        property real radius: 18
        width: buttonRow.width + 20
        height: buttonRow.height + 20

        preferredRendererType: Shape.CurveRenderer

        transform: Translate {
            x: powerWindow.slideOffset
        }

        ShapePath {
            strokeWidth: 0
            fillColor: Matugen.colors.getcolors(Matugen.colors.background)

            startX: contentRect.radius
            startY: 0

            PathLine {
                x: contentRect.width - contentRect.radius
                y: 0
            }

            PathArc {
                x: contentRect.width
                y: -contentRect.radius
                radiusX: contentRect.radius
                radiusY: contentRect.radius
                direction: PathArc.Counterclockwise
            }

            PathArc {
                x: contentRect.width + contentRect.radius
                y: 0
                radiusX: contentRect.radius
                radiusY: contentRect.radius
                direction: PathArc.Counterclockwise
            }

            PathLine {
                x: contentRect.width + contentRect.radius
                y: contentRect.height
            }

            PathArc {
                x: contentRect.width
                y: contentRect.height + contentRect.radius
                radiusX: contentRect.radius
                radiusY: contentRect.radius
                direction: PathArc.Counterclockwise
            }

            PathArc {
                x: contentRect.width - contentRect.radius
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
                y: contentRect.radius
            }

            PathArc {
                x: contentRect.radius
                y: 0
                radiusX: contentRect.radius
                radiusY: contentRect.radius
                direction: PathArc.Clockwise
            }
        }

        Column {
            id: buttonRow

            anchors.centerIn: parent
            spacing: 10

            Button {
                width: 50
                height: 50
                background: StyledRect {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8

                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: Lucide.icon_power
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    ShellContext.togglePower();
                    shutdownCmd.running = true;
                }
            }

            Button {
                width: 50
                height: 50
                background: StyledRect {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8
                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: Lucide.icon_rotate_cw
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    ShellContext.togglePower();
                    rebootCmd.running = true;
                }
            }

            Button {
                width: 50
                height: 50
                background: StyledRect {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8
                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: Lucide.icon_lock
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    console.log("Locking screen");
                    ShellContext.togglePower();
                    lockCmd.running = true;
                }
            }
        }
    }
}
