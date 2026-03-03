//qmllint disable unqualified
//qmllint disable unused-imports
//qmllint disable uncreatable-type
import QtQuick
import QtQuick.Layouts
import Quickshell
import "components"

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 34
    color: "#1a1b26"
    required property var modelData
    screen: modelData

    property int fontSize: 18
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colPurple: "#ad8ee6"
    property color colRed: "#f7768e"
    property color colYellow: "#e0af68"
    property color colBlue: "#7aa2f7"

    RowLayout {
        anchors.fill: parent

        Rectangle {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 28
            color: "transparent"

            Image {
                anchors.fill: parent
                source: "file:///home/luca/dotfiles/.config/quickshell/icons/nixos.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Workspaces {
            outputName: root.screen.name
        }

        Item {
            Layout.fillWidth: true
        }

        Clock {}
    }
}
