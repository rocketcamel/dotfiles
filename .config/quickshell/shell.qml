//qmllint disable unqualified
//qmllint disable unused-imports
//qmllint disable uncreatable-type
import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            Bar {}
        }
    }
}
