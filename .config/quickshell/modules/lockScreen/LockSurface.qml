import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Controls.Fusion
import qs.services.matugen
import qs.utils

Item {
    id: root

    required property LockContext context

    Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Matugen.image
    }
    MultiEffect {
        source: background
        anchors.fill: background
        blurEnabled: true
        blurMax: 45
        blur: 1
        autoPaddingEnabled: false
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "It's not working, LET ME OUT!!!"
        onClicked: root.context.unlocked()
    }

    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        topPadding: 80
        spacing: 15

        TextInput {
            id: passwordInput

            property list<string> symbols: symbols = ["$", "%", "@", "*", "&", "#", "-", "+", "=", "?", "~"]
            property string lastSymbol: "%"
            property string displayedText: ""

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: width > parent.width ? -width / 2 + parent.width / 2 : 0
            clip: true
            padding: parent.radius / 2
            width: Math.min(contentWidth + padding * 2, parent.width - parent.border.width * 2)

            font.family: "Host Grotesk"
            // font.pointSize: 12
            font.pointSize: 10
            color: Colors.dark_medium.fg

            // echoMode: TextInput.NoEcho
            echoMode: TextInput.Password
            focus: true
            enabled: !root.context.unlockInProgress
            // cursorVisible: root.context.currentText.length == 0

            onTextChanged: {
                // const i = Math.floor(Math.random() * (passwordInput.symbols.length - 2));
                // passwordInput.lastSymbol = passwordInput.symbols.filter(s => s != passwordInput.lastSymbol)[i];
                // if (root.context.currentText.length > passwordInput.text.length) {
                //     passwordInput.displayedText = passwordInput.displayedText.substring(0, passwordInput.text.length);
                //     passwordInput.lastSymbol = passwordInput.displayedText.length ? passwordInput.displayedText[passwordInput.displayedText.length - 1] : "%";
                // } else {
                //     passwordInput.displayedText += passwordInput.lastSymbol;
                // }

                root.context.currentText = passwordInput.text;
            }
            onAccepted: root.context.tryUnlock()
            Keys.onEscapePressed: {
                passwordInput.text = "";
                passwordInput.displayedText = "";
            }

            // Update the text in the box to match the text in the context.
            // This makes sure multiple monitors have the same text.
            Connections {
                target: root.context

                function onCurrentTextChanged() {
                    passwordInput.text = root.context.currentText;
                }
            }
        }
    }
}
