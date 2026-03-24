//qmllint disable unqualified
//qmllint disable unused-imports
//qmllint disable uncreatable-type
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Repeater {
    model: Hyprland.workspaces.values

    delegate: Rectangle {
        id: workspaceComponent
        Layout.preferredWidth: 30
        Layout.preferredHeight: parent.height
        color: "transparent"

        property bool isActive: modelData.focused
        property int lastActive: 1
        property int wsId: modelData.id
        property bool isHovered: mouseHandler.containsMouse

        states: [
            State {
                name: "active"
                when: isActive
                PropertyChanges {
                    target: workspaceComponent
                    color: Qt.rgba(1, 1, 1, 0.2)
                }
                PropertyChanges {
                    target: underline
                    color: root.colPurple
                }
            },
            State {
                name: "hovered"
                when: isHovered && !isActive
                PropertyChanges {
                    target: workspaceComponent
                    color: Qt.rgba(1, 1, 1, 0.1)
                }
                PropertyChanges {
                    target: underline
                    color: "#7aa2f7"
                }
            }
        ]

        transitions: Transition {
            ColorAnimation {
                duration: 200
            }
        }

        Text {
            text: modelData.id
            color: isActive ? "#a9b1d6" : "#7aa2f7"
            font {
                pixelSize: root.fontSize
                bold: true
                family: "Comic Relief"
            }
            anchors.centerIn: parent
        }

        Rectangle {
            id: underline
            width: 30
            height: 3
            color: root.colBg
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            id: mouseHandler
            hoverEnabled: true
            anchors.fill: parent
            onClicked: Hyprland.dispatch("workspace " + modelData.id)
        }
    }
}
