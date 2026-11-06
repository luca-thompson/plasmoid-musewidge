import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    width: 200
    height: 100

    property string titleText: "Loading..."
    property string albumText: "Loading..."
    
    Plasma5Support.DataSource {
        id: titleExecutable
        engine: "executable"
        connectedSources: []
        
        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (stdout !== undefined) {
                root.titleText = stdout.trim()
            }

            disconnectSource(source)
        }
    }

    Plasma5Support.DataSource {
        id: albumExecutable
        engine: "executable"
        connectedSources: []
        
        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (stdout !== undefined) {
                root.albumText = stdout.trim()
            }

            disconnectSource(source)
        }
    }

    function runTitleCommand() {
        var cmd = "playerctl metadata title"
        titleExecutable.connectSource(cmd)
    }

    function runAlbumCommand() {
        var cmd = "playerctl metadata album"
        albumExecutable.connectSource(cmd)
    }

    RowLayout {
        anchors.fill: parent
        spacing: 20

        PlasmaComponents3.Label {
            id: titleLabel
            text: root.titleText
        }

        PlasmaComponents3.Label {
            id: albumLabel
            text: root.albumText
        }

        Timer {
            id: timedLoop
            interval: 1000
            running: true
            repeat: true
    
            onTriggered: {
                root.runTitleCommand()
                root.runAlbumCommand()
            }
        }
    }
    
    Component.onCompleted: {
        root.runTitleCommand()
        root.runAlbumCommand()
    }
}
