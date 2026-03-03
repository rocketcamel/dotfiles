pragma Singleton

import QtQuick
import Niri 0.1 as NiriPlugin

QtObject {
    id: root

    property var niri: NiriPlugin.Niri {}
    property var workspaces: niri.workspaces
    property var windows: niri.windows
    property var focusedWindow: niri.focusedWindow

    function focusWorkspaceById(id) {
        niri.focusWorkspaceById(id);
    }

    function focusWorkspaceByName(name) {
        niri.focusWorkspaceByName(name);
    }

    function focusWindow(id) {
        niri.focusWindow(id);
    }

    function closeWindow(id) {
        niri.closeWindow(id);
    }

    Component.onCompleted: {
        niri.connect();
    }
}
