
/*
adapted from
 *   SPDX-FileCopyrightText: 2012 Gregor Taetzner <gregor@freenet.de>
 *   SPDX-FileCopyrightText: 2020 Ivan Čukić <ivan.cukic at kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

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

    PlasmaComponents3.Label {
        id: name

        height: parent.height
        width: implicitWidth

        verticalAlignment: Text.AlignVCenter

        text: "test"
    }

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        
        onNewData: function(source, data) {
            var stdout = data["stdout"]
            if (stdout !== undefined) {
                root.outputText = stdout.trim()
            }
            // Disconnect the source after reading so it doesn't loop
            disconnectSource(source)
        }
    }

    function runBashCommand() {
        var cmd = "date '+%H:%M:%S'" // Replace with your bash command or script
        executable.connectSource(cmd)
    }

    ColumnLayout {
            anchors.fill: parent
            spacing: 8
    
            PlasmaComponents3.Label {
                id: myLabel
                text: root.outputText
                Layout.alignment: Qt.AlignCenter
            }
    
            PlasmaComponents3.Button {
                text: "Run Bash"
                onClicked: runBashCommand()
            }
        }
    
        Component.onCompleted: {
            runBashCommand() // Run automatically on load, or trigger via timer/button
        }

}
