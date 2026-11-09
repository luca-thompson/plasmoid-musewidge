import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    width: 200
    height: 100

    property string displayLabel: "Loading..."

    PlasmaComponents3.Label {
        id: displayLabel
        text: root.displayLabel

        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight 
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

    Timer {
        id: timedLoop
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            root.fetchMetadata()
        }
    }
    
    Component.onCompleted: {
        root.fetchMetadata()
    }
}
