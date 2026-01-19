//qmllint disable unqualified
//qmllint disable unused-imports
//qmllint disable uncreatable-type
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 34
    color: "#1a1b26"

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

        Item {
            Layout.fillWidth: true
        }
    }
}
