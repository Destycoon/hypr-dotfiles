import QtQuick
import Quickshell

ShellRoot {
    LockContext {
        id: lockContext
        onUnlocked: Qt.quit()
    }

    FloatingWindow {
        visible: surface.loaded
        LockSurface {
            id: surface
            anchors.fill: parent
            context: lockContext
        }
    }

    // exit the example if the window closes
    Connections {
        target: Quickshell

        function onLastWindowClosed() {
            Qt.quit();
        }
    }
}
