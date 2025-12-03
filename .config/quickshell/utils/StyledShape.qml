pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

import qs.utils
import qs.config
import qs.modules.bar
import qs.modules.bar.barModules

import qs.services.matugen

item {

    color: "transparent"
    mask: Region {
        item: cornersArea
        intersection: Intersection.Subtract
    }

    component Corner: WrapperItem {
        id: root

        property int corner
        property real radius: 30
        property color color

        Component.onCompleted: {
            switch (corner) {
            case 0:
                anchors.left = parent.left;
                anchors.top = parent.top;
                break;
            case 1:
                anchors.top = parent.top;
                anchors.right = parent.right;
                rotation = 90;
                break;
            case 2:
                anchors.right = parent.right;
                anchors.bottom = parent.bottom;
                rotation = 180;
                break;
            case 3:
                anchors.left = parent.left;
                anchors.bottom = parent.bottom;
                rotation = -90;
                break;
            }
        }

        Shape {
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: 0
                fillColor: root.color
                startX: root.radius

                PathArc {
                    relativeX: -root.radius
                    relativeY: root.radius
                    radiusX: root.radius
                    radiusY: radiusX
                    direction: PathArc.Counterclockwise
                }

                PathLine {
                    relativeX: 0
                    relativeY: -root.radius
                }

                PathLine {
                    relativeX: root.radius
                    relativeY: 0
                }
            }
        }
    }
    component Exclusion: PanelWindow {
        property string name
        implicitWidth: 0
        implicitHeight: 0
        WlrLayershell.namespace: `quickshell:${name}ExclusionZone`
    }

    Scope {
        Exclusion {
            name: "left"
            exclusiveZone: leftBar.implicitWidth
            anchors.left: true
        }
        Exclusion {
            name: "top"
            exclusiveZone: topBar.implicitHeight
            anchors.top: true
        }
        Exclusion {
            name: "right"
            exclusiveZone: rightBar.implicitWidth
            anchors.right: true
        }
        Exclusion {
            name: "bottom"
            exclusiveZone: bottomBar.implicitHeight
            anchors.bottom: true
        }
    }

    StyledRect {
        id: leftBar
        implicitWidth: 50
        implicitHeight: QsWindow.window?.height ?? 0
        color: win.barColor
        anchors.left: parent.left
    }
    StyledRect {
        id: topBar
        implicitWidth: QsWindow.window?.width ?? 0
        implicitHeight: 10
        color: win.barColor
        anchors.top: parent.top
    }
    StyledRect {
        id: rightBar
        implicitWidth: 10
        implicitHeight: QsWindow.window?.height ?? 0
        color: win.barColor
        anchors.right: parent.right
    }
    StyledRect {
        id: bottomBar
        implicitWidth: QsWindow.window?.width ?? 0
        implicitHeight: 10
        color: win.barColor
        anchors.bottom: parent.bottom
    }

    StyledRect {
        id: cornersArea
        implicitWidth: QsWindow.window?.width - (leftBar.implicitWidth + rightBar.implicitWidth)
        implicitHeight: QsWindow.window?.height - (topBar.implicitHeight + bottomBar.implicitHeight)
        color: "transparent"
        x: leftBar.implicitWidth
        y: topBar.implicitHeight

        Repeater {
            model: [0, 1, 2, 3]

            Corner {
                required property int modelData
                corner: modelData
                color: win.barColor
            }
        }
    }
}
