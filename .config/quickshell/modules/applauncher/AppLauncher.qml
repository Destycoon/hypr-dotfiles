pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import qs.services.matugen
import qs.utils
import qs.config

PanelWindow {
    id: launcher
    implicitWidth: 450
    implicitHeight: 500
    color: "transparent"
    visible: ShellContext.launcherOpen
    focusable: true

    property var filteredApps: {
        var searchText = search.text.toLowerCase();
        if (searchText === "") {
            return DesktopEntries.applications.values;
        }
        return DesktopEntries.applications.values.filter(function (app) {
            return app.name.toLowerCase().includes(searchText);
        });
    }

    mask: Region {
        item: app
    }
    IpcHandler {
        target: "launcher"
        function toggle() {
            ShellContext.toggleLauncher();
        }
    }

    StyledRect {
        id: app
        anchors.fill: parent
        radius: 30
        color: Matugen.colors.getcolors(Matugen.colors.surface_container)

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                StyledText {
                    text: "Applications"
                    font.pixelSize: 22
                    font.weight: Font.Medium
                    color: Matugen.colors.getcolors(Matugen.colors.on_surface)
                    Layout.fillWidth: true
                }

                StyledText {
                    text: resultCount.text
                    font.pixelSize: 12
                    color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                }
            }

            StyledRect {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                color: Matugen.colors.getcolors(Matugen.colors.surface_container_high)
                radius: 28
                border.width: search.activeFocus ? 2 : 0
                border.color: Matugen.colors.getcolors(Matugen.colors.primary)

                Behavior on border.width {
                    NumberAnimation {
                        duration: 200
                    }
                }

                Behavior on border.color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 16
                    spacing: 12

                    StyledText {
                        text: Lucide.icon_search
                        font.pixelSize: 20
                        color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                    }

                    TextField {
                        id: search
                        Layout.fillWidth: true
                        placeholderText: "Rechercher une application..."
                        placeholderTextColor: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                        background: Item {}
                        font.pixelSize: 16
                        enabled: true
                        focus: true
                        activeFocusOnPress: true
                        color: Matugen.colors.getcolors(Matugen.colors.on_surface)

                        Keys.onEscapePressed: {
                            ShellContext.toggleLauncher();
                        }
                        Keys.onDownPressed: {
                            if (appList.count > 0) {
                                appList.currentIndex = 0;
                                appList.forceActiveFocus();
                            }
                        }

                        Keys.onReturnPressed: {
                            if (appList.count > 0) {
                                var app = launcher.filteredApps[0];
                                app.execute();
                                ShellContext.toggleLauncher();
                                search.text = "";
                            }
                        }
                    }

                    MouseArea {
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        visible: search.text.length > 0
                        cursorShape: Qt.PointingHandCursor

                        StyledRect {
                            anchors.fill: parent
                            radius: 12
                            color: parent.containsMouse ? Matugen.colors.getcolors(Matugen.colors.surface_container_highest) : "transparent"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            StyledText {
                                anchors.centerIn: parent
                                text: "✕"
                                color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                                font.pixelSize: 16
                            }
                        }

                        onClicked: search.text = ""
                    }
                }
            }

            StyledText {
                id: resultCount
                text: appList.count + " application" + (appList.count > 1 ? "s" : "")
                font.pixelSize: 12
                color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                visible: search.text.length > 0
                Layout.leftMargin: 4
            }

            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Matugen.colors.getcolors(Matugen.colors.surface_container_low)
                radius: 16
                clip: true

                ListView {
                    id: appList
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4
                    clip: true

                    property var filteredApps: {
                        var searchText = search.text.toLowerCase();
                        if (searchText === "") {
                            return DesktopEntries.applications.values;
                        }
                        return DesktopEntries.applications.values.filter(function (app) {
                            return app.name.toLowerCase().includes(searchText);
                        });
                    }

                    model: filteredApps

                    Keys.onUpPressed: {
                        if (currentIndex === 0) {
                            search.forceActiveFocus();
                        } else {
                            decrementCurrentIndex();
                        }
                    }
                    Keys.onDownPressed: incrementCurrentIndex()
                    Keys.onReturnPressed: {
                        var app = filteredApps[currentIndex];
                        app.execute();
                        ShellContext.toggleLauncher();
                        search.text = "";
                    }
                    Keys.onEscapePressed: {
                        ShellContext.toggleLauncher();
                    }

                    delegate: StyledRect {
                        id: appItem
                        required property DesktopEntry modelData
                        required property int index

                        implicitWidth: appList.width - 8
                        implicitHeight: 64
                        color: {
                            if (appList.currentIndex === index) {
                                return Matugen.colors.getcolors(Matugen.colors.secondary_container);
                            }

                            if (mouseArea.containsMouse) {
                                return Matugen.colors.getcolors(Matugen.colors.surface_container_highest);
                            }
                            return "transparent";
                        }
                        radius: 12

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 16

                            Item {
                                Layout.preferredWidth: 40
                                Layout.preferredHeight: 40

                                Image {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    source: {
                                        if (modelData.runInTerminal == false)
                                            return Quickshell.iconPath(modelData.icon);
                                        else
                                            return "../../utils/Assets/svg/terminal.svg";
                                    }
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    layer.mipmap: true
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                StyledText {
                                    text: modelData.name
                                    font.pixelSize: 16
                                    font.weight: Font.Medium
                                    color: Matugen.colors.getcolors(Matugen.colors.on_surface)
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                StyledText {
                                    text: modelData.genericName || modelData.comment || ""
                                    font.pixelSize: 12
                                    color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                    visible: text.length > 0
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                modelData.execute();
                                ShellContext.toggleLauncher();
                                search.text = "";
                            }

                            onEntered: appList.currentIndex = index
                        }
                    }

                    StyledText {
                        anchors.centerIn: parent
                        visible: appList.count === 0 && search.text.length > 0
                        text: "Aucune application trouvée"
                        font.pixelSize: 16
                        color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        width: 8

                        contentItem: StyledRect {
                            radius: 4
                            color: parent.pressed ? Matugen.colors.getcolors(Matugen.colors.on_surface) : Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                            opacity: parent.pressed ? 0.8 : 0.6

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                Layout.topMargin: 4

                StyledText {
                    text: "↵ Ouvrir"
                    font.pixelSize: 11
                    color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                }

                StyledText {
                    text: Lucide.icon_arrow_down_up + " Naviguer"
                    font.pixelSize: 11
                    color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                }

                StyledText {
                    text: "Esc Fermer"
                    font.pixelSize: 11
                    color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }
    }
}
