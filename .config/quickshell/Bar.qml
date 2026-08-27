//qmllint disable unqualified
//qmllint disable unused-imports
//qmllint disable uncreatable-type
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.SystemTray
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

        Workspaces {}

        Item {
            Layout.fillWidth: true
        }

        ActiveWindow {}

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 6

            Layout.rightMargin: 2

            Repeater {
                model: SystemTray.items

                MouseArea {
                    id: trayItem
                    required property var modelData

                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    property bool hidden: trayId.includes("spotify") || trayId.includes("blueman")
                    visible: !hidden

                    Layout.preferredWidth: hidden ? 0 : 22
                    Layout.preferredHeight: hidden ? 0 : 22
                    Layout.alignment: Qt.AlignVCenter

                    property string trayId: modelData.id.toLowerCase()

                    QsMenuAnchor {
                           id: menuAnchor
                           menu: trayItem.modelData.menu
                           anchor.window: root
                           anchor.item: trayItem
                           anchor.edges: Edges.Bottom
                           anchor.gravity: Edges.Bottom
                           anchor.adjustment: PopupAdjustment.Flip
                    }

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) modelData.onlyMenu ? menuAnchor.open() : modelData.activate()

                        else if (mouse.button === Qt.RightButton && modelData.hasMenu)
                            menuAnchor.open()
                    }

                    IconImage {
                        anchors.fill: parent
                        source: parent.modelData.icon
                    }
                }
            }
        }

        Clock {}
    }
}
