//qmllint disable unqualified
//qmllint disable unused-imports
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

RowLayout {
    id: activeWindow
    spacing: 8

    property string displayMode: "title"

    property var toplevel: Hyprland.activeToplevel
    property string appClass: toplevel?.lastIpcObject?.class ?? ""
    property var desktopEntry: appClass ? DesktopEntries.heuristicLookup(appClass) : null
    property string appName: desktopEntry?.name ?? appClass
    property string windowTitle: toplevel?.title ?? ""

    visible: toplevel !== null

    // IconImage {
    //     id: iconDisplay
    //     property string iconPath: Quickshell.iconPath(activeWindow.desktopEntry?.icon ?? "")
    //     source: iconDisplay.iconPath
    //     visible: iconDisplay.iconPath !== null
    //     implicitSize: 20
    //     Layout.preferredWidth: 20
    //     Layout.preferredHeight: 20
    // }

    Text {
        text: {
            switch (activeWindow.displayMode) {
            case "title":
                return activeWindow.windowTitle;
            case "both":
                return activeWindow.appName + (activeWindow.windowTitle ? " - " + activeWindow.windowTitle : "");
            case "appName":
            default:
                return activeWindow.appName;
            }
        }
        color: root.colFg
        font {
            pixelSize: root.fontSize - 4
            family: "Comic Relief"
        }
        elide: Text.ElideRight
        Layout.maximumWidth: 400
    }
}
