import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts

import qs.services.matugen
import qs.utils
import qs.utils.anim

Item {
    id: root

    property LockContext context 
    property bool loaded: false
    
    Component.onCompleted: {
        root.loaded = true;
        fadeInAnimation.start();
    }

    // Fond d'écran avec effet de flou
    Item {
        anchors.fill: parent
        
        Image {
            id: wallpaperImage
            anchors.fill: parent
            source: Matugen.get()
            fillMode: Image.PreserveAspectCrop
            visible: root.loaded
            smooth: true
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 64
                brightness: -0.3
                saturation: 0.8
            }
        }
        
        // Overlay gradient pour améliorer la lisibilité
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.4) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.6) }
            }
        }
    }
    
    // Animation de fade-in au démarrage
    NumberAnimation {
        id: fadeInAnimation
        target: mainContainer
        property: "opacity"
        from: 0
        to: 1
        duration: 600
        easing.type: Easing.OutCubic
    }
        
    // Conteneur principal avec animation
    Item {
        id: mainContainer
        anchors.centerIn: parent
        width: 450
        height: 600
        opacity: 0

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 24
            width: parent.width

            // Conteneur de l'icône avec effet de glow
            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 120
                Layout.preferredHeight: 120
                
                StyledRect {
                    anchors.centerIn: parent
                    width: 96
                    height: 96
                    radius: 48
                    color: Matugen.colors.getcolors(Matugen.colors.primary_container)
                    opacity: 0.2
                    
                    Behavior on scale {
                        Anim { duration: 300 }
                    }
                    
                    scale: lockIcon.scale
                }
                
                StyledText {
                    id: lockIcon
                    anchors.centerIn: parent
                    text: Lucide.icon_lock_keyhole
                    font.pixelSize: 56
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    
                    Behavior on scale {
                        Anim { duration: 300 }
                    }
                    
                    scale: root.context && root.context.unlockInProgress ? 0.9 : 1.0
                    
                    SequentialAnimation on rotation {
                        running: root.context && root.context.showFailure
                        loops: 1
                        NumberAnimation { from: 0; to: -10; duration: 50 }
                        NumberAnimation { from: -10; to: 10; duration: 100 }
                        NumberAnimation { from: 10; to: -10; duration: 100 }
                        NumberAnimation { from: -10; to: 0; duration: 50 }
                    }
                }
            }

            // Titre avec style amélioré
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: "Écran verrouillé"
                font.family: "Hubot Sans"
                font.pixelSize: 32
                font.weight: Font.Medium
                color: Matugen.colors.getcolors(Matugen.colors.on_background)
                opacity: 0.95
            }

            Item { Layout.preferredHeight: 16 }

            // Horloge avec animation
            StyledText {
                id: clockText
                Layout.alignment: Qt.AlignHCenter
                font.family: "Hubot Sans"
                font.pixelSize: 72
                font.weight: Font.Bold
                color: Matugen.colors.getcolors(Matugen.colors.on_background)
                
                Behavior on scale {
                    Anim { duration: 200 }
                }

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
                
                Timer {
                    interval: 60000
                    running: true
                    repeat: true
                    onTriggered: {
                        clockText.scale = 1.05;
                        clockText.scale = 1.0;
                    }
                }
            }

            // Date avec icône
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8
                
                StyledText {
                    text: Lucide.icon_calendar
                    font.pixelSize: 16
                    color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                    opacity: 0.7
                }
                
                StyledText {
                    id: dateText
                    font.family: "Hubot Sans"
                    font.pixelSize: 18
                    font.weight: Font.Normal
                    color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                    opacity: 0.85

                    Component.onCompleted: {
                        var date = new Date();
                        dateText.text = Qt.formatDate(date, "dddd d MMMM yyyy");
                    }
                }
            }

            Item { Layout.preferredHeight: 32 }

            // Conteneur du champ de mot de passe avec design moderne
            StyledRect {
                id: passwordContainer
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 380
                Layout.preferredHeight: 60
                radius: 30
                color: Matugen.colors.getcolors(Matugen.colors.surface_container_highest)
                border.color: {
                    if (root.context && root.context.showFailure)
                        return Matugen.colors.getcolors(Matugen.colors.error);
                    else if (passwordInput.activeFocus)
                        return Matugen.colors.getcolors(Matugen.colors.primary);
                    else
                        return "transparent";
                }
                border.width: 2
                opacity: 0.95

                Behavior on border.color { CAnim {} }
                Behavior on scale { Anim { duration: 200 } }
                
                scale: passwordInput.activeFocus ? 1.02 : 1.0

                // Effet de glow au focus
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -4
                    radius: parent.radius + 4
                    color: "transparent"
                    border.color: Matugen.colors.getcolors(Matugen.colors.primary)
                    border.width: 0
                    opacity: passwordInput.activeFocus ? 0.3 : 0
                    
                    Behavior on opacity { Anim {} }
                    Behavior on border.width { Anim {} }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    spacing: 16

                    // Icône utilisateur stylisée
                    StyledText {
                        text: Lucide.icon_user_round
                        font.pixelSize: 24
                        color: passwordInput.activeFocus 
                            ? Matugen.colors.getcolors(Matugen.colors.primary)
                            : Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                        opacity: 0.8
                        
                        Behavior on color { CAnim {} }
                    }

                    TextInput {
                        id: passwordInput
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        verticalAlignment: TextInput.AlignVCenter

                        font.family: "Hubot Sans"
                        font.pixelSize: 18
                        color: Matugen.colors.getcolors(Matugen.colors.on_surface)
                        echoMode: TextInput.Password
                        focus: true
                        enabled: root.context ? !root.context.unlockInProgress : true
                        selectionColor: Matugen.colors.getcolors(Matugen.colors.primary)

                        onTextChanged: {
                            if (root.context) root.context.currentText = passwordInput.text;
                        }

                        onAccepted: { 
                            if (root.context) root.context.tryUnlock(); 
                        }

                        Keys.onEscapePressed: {
                            passwordInput.text = "";
                        }

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            text: (root.context && root.context.unlockInProgress) 
                                ? "Authentification en cours..." 
                                : "Entrez votre mot de passe"
                            font: passwordInput.font
                            color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                            opacity: 0.5
                            visible: passwordInput.text.length === 0
                        }
                    }

                    // Indicateur de chargement moderne
                    Item {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        visible: root.context && root.context.unlockInProgress

                        Rectangle {
                            id: spinner
                            anchors.centerIn: parent
                            width: 24
                            height: 24
                            radius: 12
                            color: "transparent"
                            border.color: Matugen.colors.getcolors(Matugen.colors.primary)
                            border.width: 3

                            Rectangle {
                                width: 6
                                height: 6
                                radius: 3
                                color: Matugen.colors.getcolors(Matugen.colors.primary)
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.topMargin: 2
                            }

                            RotationAnimation {
                                target: spinner
                                from: 0
                                to: 360
                                duration: 1200
                                loops: Animation.Infinite
                                running: root.context && root.context.unlockInProgress
                                easing.type: Easing.Linear
                            }
                        }
                    }
                    
                    // Icône de validation/erreur
                    StyledText {
                        Layout.preferredWidth: 28
                        visible: !root.context || !root.context.unlockInProgress
                        text: (root.context && root.context.showFailure) 
                            ? Lucide.icon_circle_x 
                            : Lucide.icon_lock_keyhole
                        font.pixelSize: 20
                        color: (root.context && root.context.showFailure)
                            ? Matugen.colors.getcolors(Matugen.colors.error)
                            : Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                        opacity: 0.6
                        
                        Behavior on color { CAnim {} }
                    }
                }
            }

            // Message d'erreur avec icône
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8
                visible: root.context && root.context.showFailure
                opacity: (root.context && root.context.showFailure) ? 1.0 : 0.0

                Behavior on opacity { Anim {} }
                
                StyledText {
                    text: Lucide.icon_triangle_alert
                    font.pixelSize: 16
                    color: Matugen.colors.getcolors(Matugen.colors.error)
                }
                
                StyledText {
                    text: "Mot de passe incorrect"
                    font.family: "Hubot Sans"
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    color: Matugen.colors.getcolors(Matugen.colors.error)
                }
            }

            Item { Layout.preferredHeight: 8 }

            // Instructions avec icône
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8
                opacity: passwordInput.text.length > 0 && (!root.context || !root.context.unlockInProgress) ? 1.0 : 0.4

                Behavior on opacity { Anim {} }
                
                StyledText {
                    text: Lucide.icon_corner_down_left
                    font.pixelSize: 14
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                }
                
                StyledText {
                    text: "Appuyez sur Entrée pour déverrouiller"
                    font.family: "Hubot Sans"
                    font.pixelSize: 14
                    color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
                }
            }
        }
    }
    
    // Indicateur de statut en bas de l'écran
    RowLayout {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 40
        spacing: 24
        opacity: 0.7
        
        // Indicateur réseau (décoratif)
        RowLayout {
            spacing: 6
            
            StyledText {
                text: Lucide.icon_wifi
                font.pixelSize: 18
                color: Matugen.colors.getcolors(Matugen.colors.on_background)
            }
        }
        
        // Séparateur
        Rectangle {
            width: 1
            height: 20
            color: Matugen.colors.getcolors(Matugen.colors.on_surface_variant)
            opacity: 0.3
        }
        
        // Indicateur batterie (décoratif)
        RowLayout {
            spacing: 6
            
            StyledText {
                text: Lucide.icon_battery_charging
                font.pixelSize: 18
                color: Matugen.colors.getcolors(Matugen.colors.on_background)
            }
        }
    }
}
