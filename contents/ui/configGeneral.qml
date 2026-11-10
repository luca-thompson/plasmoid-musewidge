



import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.components as PlasmaComponents3

KCM.SimpleKCM {
    id: cfgGeneral

    title: "General"

    property alias cfg_automaticPlayerSelection: automaticPlayerSelectionCheckbox.checked
    property alias cfg_configuredPlayer: playerEntry.text

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        PlasmaComponents3.CheckBox {
            id: automaticPlayerSelectionCheckbox

            text: "automatic player selection"
        }

        PlasmaComponents3.TextField {
            id: playerEntry
            enabled: !automaticPlayerSelectionCheckbox.checked
        }
    }
}
