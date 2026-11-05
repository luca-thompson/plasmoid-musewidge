import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    width: 200
    height: 100

    property string outputText: "Loading..."

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        
        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (stdout !== undefined) {
                root.outputText = stdout.trim()
            }

            disconnectSource(source)
        }
    }

    function runBashCommand() {
        var cmd = "date"
        executable.connectSource(cmd)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        PlasmaComponents3.Label {
            id: myLabel
            text: root.outputText
        }

        Timer {
            id: timedLoop
            interval: 1000
            running: true
            repeat: true
    
            onTriggered: {
                root.runBashCommand()
            }
        }
    }
    
    Component.onCompleted: {
        root.runBashCommand()
    }
}
