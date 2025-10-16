pragma Singleton

import QtQuick

QtObject {
    id: palette
    //background
    property color bg: "#1a1b26"
    property color darkbg: "#16161e"
    property color lightbg: "#24283b"
    // text
    property color text: "#c0caf5"
    property color textDim: "#a9b1d6"
    property color textMuted: "#565f89"
    // color
    property color accent: "#7aa2f7"
    property color accentAlt: "#bb9af7"
    property color accentGreen: "#9ece6a"
    property color accentRed: "#f7768e"
    property color accentOrange: "#ff9e64"
    property color accentYellow: "#e0af68"
    //border
    property color border: "#3b4261"
    property color borderLight: "#565f89"
    property color shadow: "#00000088"

    // State
    property color success: accentGreen
    property color warning: accentOrange
    property color error: accentRed
    property color info: accent
}
