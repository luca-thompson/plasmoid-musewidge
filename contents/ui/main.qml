import QtQuick

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import QtQuick.Layouts

PlasmoidItem {
    id: root
    Layout.preferredWidth: displayLabel.implicitWidth
    Layout.minimumWidth: Layout.preferredWidth
    

    property string displayLabel: "Loading..."

    PlasmaComponents.Label {
        id: displayLabel
        text: root.displayLabel

        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight 
        anchors.centerIn: parent
    }
    
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        
        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (stdout !== undefined) {
                root.displayLabel = stdout.trim()
            }

            disconnectSource(source)
        }
    }

    function fetchMetadata() {

        var cmd = "playerctl metadata --format '{{title}} | {{artist}}'"
        executable.connectSource(cmd)
    }

    function fetchSpecifiedMetadata() {

        var cmd = "playerctl --player=" + Plasmoid.configuration.configuredPlayer + " metadata --format '{{title}} | {{artist}}'"
        executable.connectSource(cmd)
    }

    Timer {
        id: timedLoop
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            if (Plasmoid.configuration.automaticPlayerSelection){
                root.fetchMetadata()
            }
            else {
                root.fetchSpecifiedMetadata()
            }
        }
    }
    
    Component.onCompleted: {
        if (Plasmoid.configuration.automaticPlayerSelection){
            root.fetchMetadata()
        }
        else {
            root.fetchSpecifiedMetadata()
        }
    }
}
