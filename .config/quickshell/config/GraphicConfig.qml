pragma Singleton

import QtQuick

QtObject {
    property Rounding rounding: Rounding {}
    property Spacing spacing: Spacing {}
    property Padding padding: Padding {}
    property FontStuff font: FontStuff {}
    property Anim anim: Anim {}
    property Transparency transparency: Transparency {}

    component Rounding: QtObject {
        property real scale: 1
        property int small: 12 * scale
        property int normal: 17 * scale
        property int large: 25 * scale
        property int full: 1000 * scale
    }

    component Spacing: QtObject {
        property real scale: 1
        property int small: 7 * scale
        property int smaller: 10 * scale
        property int normal: 12 * scale
        property int larger: 15 * scale
        property int large: 20 * scale
    }

    component Padding: QtObject {
        property real scale: 1
        property int small: 5 * scale
        property int smaller: 7 * scale
        property int normal: 10 * scale
        property int larger: 12 * scale
        property int large: 15 * scale
    }

    component FontFamily: QtObject {
        property string sans: "Hubot Sans"
        property string mono: "Monospace"
        property string material: "Lucide"
    }

    component FontSize: QtObject {
        property real scale: 1
        property int small: 11 * scale
        property int smaller: 12 * scale
        property int normal: 13 * scale
        property int larger: 15 * scale
        property int large: 18 * scale
        property int extraLarge: 28 * scale
    }

    component FontStuff: QtObject {
        property FontFamily family: FontFamily {}
        property FontSize size: FontSize {}
    }

    component AnimCurves: QtObject {
        property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
        property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
    }

    component AnimDurations: QtObject {
        property real scale: 1
        property int small: 200 * scale
        property int normal: 400 * scale
        property int large: 600 * scale
        property int extraLarge: 1000 * scale
        property int expressiveFastSpatial: 350 * scale
        property int expressiveDefaultSpatial: 500 * scale
        property int expressiveEffects: 200 * scale
    }

    component Anim: QtObject {
        property AnimCurves curves: AnimCurves {}
        property AnimDurations durations: AnimDurations {}
    }

    component Transparency: QtObject {
        property bool enabled: false
        property real base: 0.85
        property real layers: 0.4
    }
}
