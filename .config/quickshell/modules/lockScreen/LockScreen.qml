import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import qs.services.matugen

ShellRoot {

    LockContext {
        id: context

        onUnlocked: {
            lock.locked = false;

            Qt.quit();
        }
    }

    WlSessionLock {
        id: lock
        locked: true
        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: context
            }
        }
    }
}
