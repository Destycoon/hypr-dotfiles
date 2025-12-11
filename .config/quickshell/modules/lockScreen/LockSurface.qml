import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property LockContext context 
    property bool loaded : false
    
    Component.onCompleted: {
        root.loaded = true;
    }

    // Fond d'écran avec gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a1a2e" }
            GradientStop { position: 1.0; color: "#16213e" }
        }
    }

    // Conteneur principal centré
    Item {
        anchors.centerIn: parent
        width: 400
        height: 500

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 30
            width: parent.width

            // Icône de cadenas
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "🔒"
                font.pixelSize: 64
                opacity: 0.9
            }

            // Titre
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Écran verrouillé"
                font.family: "Host Grotesk"
                font.pixelSize: 28
                font.weight: Font.Light
                color: "#ffffff"
            }

            // Horloge
            Text {
                id: clockText
                Layout.alignment: Qt.AlignHCenter
                font.family: "Host Grotesk"
                font.pixelSize: 48
                font.weight: Font.Bold
                color: "#ffffff"

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: {
                        var date = new Date();
                        clockText.text = Qt.formatTime(date, "hh:mm");
                    }
                }
            }

            // Date
            Text {
                id: dateText
                Layout.alignment: Qt.AlignHCenter
                font.family: "Host Grotesk"
                font.pixelSize: 16
                color: "#aaaaaa"

                Component.onCompleted: {
                    var date = new Date();
                    dateText.text = Qt.formatDate(date, "dddd d MMMM yyyy");
                }
            }

            Item { Layout.preferredHeight: 20 }

            // Conteneur du champ de mot de passe
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 320
                Layout.preferredHeight: 50
                radius: 25
                color: (root.context && root.context.showFailure) ? "#3d1e1e" : "#2a2a3e"
                border.color: (root.context && root.context.showFailure) ? "#ff4444" : (passwordInput.activeFocus ? "#4a9eff" : "#444466")
                border.width: 2

                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on border.color { ColorAnimation { duration: 200 } }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 10

                    // Icône utilisateur
                    Text {
                        text: "👤"
                        font.pixelSize: 20
                        opacity: 0.7
                    }

                    // Champ de saisie du mot de passe
                    TextInput {
                        id: passwordInput
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        verticalAlignment: TextInput.AlignVCenter

                        font.family: "Host Grotesk"
                        font.pixelSize: 16
                        color: "#ffffff"
                        echoMode: TextInput.Password
                        focus: true
                        enabled: root.context ? !root.context.unlockInProgress : true

                        onTextChanged: {
                            if (root.context) root.context.currentText = passwordInput.text;
                        }

                        onAccepted: { if (root.context) root.context.tryUnlock(); }

                        Keys.onEscapePressed: {
                            passwordInput.text = "";
                        }

                        // Synchronisation avec le contexte pour multi-écrans
                       
                        // Placeholder text
                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            text: (root.context && root.context.unlockInProgress) ? "Authentification..." : "Mot de passe"
                            font: passwordInput.font
                            color: "#666666"
                            visible: passwordInput.text.length === 0
                        }
                    }

                    // Indicateur de chargement
                    Item {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        visible: root.context && root.context.unlockInProgress

                        Rectangle {
                            id: spinner
                            anchors.centerIn: parent
                            width: 16
                            height: 16
                            radius: 8
                            color: "transparent"
                            border.color: "#4a9eff"
                            border.width: 2

                            Rectangle {
                                width: 4
                                height: 4
                                radius: 2
                                color: "#4a9eff"
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            RotationAnimation {
                                target: spinner
                                from: 0
                                to: 360
                                duration: 1000
                                loops: Animation.Infinite
                                running: root.context && root.context.unlockInProgress
                            }
                        }
                    }
                }
            }

            // Message d'erreur
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Mot de passe incorrect"
                font.family: "Host Grotesk"
                font.pixelSize: 14
                color: "#ff4444"
                visible: root.context && root.context.showFailure
                opacity: (root.context && root.context.showFailure) ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

            // Instructions
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                text: "Appuyez sur Entrée pour déverrouiller"
                font.family: "Host Grotesk"
                font.pixelSize: 12
                color: "#888888"
                opacity: passwordInput.text.length > 0 && (!root.context || !root.context.unlockInProgress) ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }
        }
    }
}
