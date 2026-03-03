//qmllint disable unqualified
//qmllint disable unused-imports
//qmllint disable uncreatable-type
import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQml.Models
import "../services" as Services

Item {
    id: workspacesRoot
    required property string outputName
    Layout.fillHeight: true
    implicitWidth: workspacesRow.implicitWidth

    DelegateModel {
        id: workspaceDelegateModel
        model: Services.Niri.workspaces

        groups: [
            DelegateModelGroup {
                id: allItems
                name: "allItems"
                includeByDefault: true
                onChanged: workspacesRoot.refilter()
            },
            DelegateModelGroup {
                id: filteredItems
                name: "filteredItems"
                includeByDefault: false
            }
        ]

        filterOnGroup: "filteredItems"

        delegate: Rectangle {
            id: workspaceComponent
            Layout.preferredWidth: 30
            Layout.preferredHeight: workspacesRow.height
            color: "transparent"
            required property var model
            property bool isActive: model.isFocused
            property int wsId: model.id
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
                text: model.name !== "" ? model.name : model.index
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
                onClicked: Services.Niri.focusWorkspaceById(model.id)
            }
        }
    }

    function refilter() {
        for (var i = 0; i < allItems.count; i++) {
            var item = allItems.get(i);
            var shouldShow = (item.model.output === outputName);
            if (shouldShow !== item.inFilteredItems) {
                allItems.setGroups(i, 1, shouldShow ? ["allItems", "filteredItems"] : ["allItems"]);
            }
        }
    }

    RowLayout {
        id: workspacesRow
        anchors.fill: parent
        spacing: 0
        Repeater {
            model: workspaceDelegateModel
        }
    }
}
