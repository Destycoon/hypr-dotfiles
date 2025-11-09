pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property bool darkmode: true
    property string image: ""

    onImageChanged: {
        updateColor();
    }

    function updateColor(img) {
        root.image = img.toString();

        matugen.running = true;
    }

    Process {
        id: matugen
        command: ["sh", "-c", `matugen image --dry-run -j hex ${root.image}`]
        stdout: StdioCollector {
            onStreamFinished: {
                var data = JSON.parse(this.text);
                if (data.colors) {
                    for (var colorName in data.colors) {
                        var colorData = data.colors[colorName];

                        if (root.colors.hasOwnProperty(colorName)) {
                            if (colorData.dark !== undefined) {
                                root.colors[colorName].dark = colorData.dark;
                            }
                            if (colorData.default !== undefined) {
                                root.colors[colorName].defaut = colorData.default;
                            }
                            if (colorData.light !== undefined) {
                                root.colors[colorName].light = colorData.light;
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: getWal

        command: ["sh", "-c", "swww query"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.image = this.text.match(/image:\s*(\/[^\s]+)/);
            }
        }
    }
    property ColorScheme colors: ColorScheme {
        background: ColorObject {
            dark: "#0f1416"
            defaut: "#0f1416"
            light: "#f5fafc"
        }

        error: ColorObject {
            dark: "#ffb4ab"
            defaut: "#ffb4ab"
            light: "#ba1a1a"
        }

        error_container: ColorObject {
            dark: "#93000a"
            defaut: "#93000a"
            light: "#ffdad6"
        }

        inverse_on_surface: ColorObject {
            dark: "#2c3133"
            defaut: "#2c3133"
            light: "#ecf2f4"
        }

        inverse_primary: ColorObject {
            dark: "#00687a"
            defaut: "#00687a"
            light: "#84d2e7"
        }

        inverse_surface: ColorObject {
            dark: "#dee3e5"
            defaut: "#dee3e5"
            light: "#2c3133"
        }

        on_background: ColorObject {
            dark: "#dee3e5"
            defaut: "#dee3e5"
            light: "#171c1e"
        }

        on_error: ColorObject {
            dark: "#690005"
            defaut: "#690005"
            light: "#ffffff"
        }

        on_error_container: ColorObject {
            dark: "#ffdad6"
            defaut: "#ffdad6"
            light: "#410002"
        }

        on_primary: ColorObject {
            dark: "#003640"
            defaut: "#003640"
            light: "#ffffff"
        }

        on_primary_container: ColorObject {
            dark: "#acedff"
            defaut: "#acedff"
            light: "#001f26"
        }

        on_primary_fixed: ColorObject {
            dark: "#001f26"
            defaut: "#001f26"
            light: "#001f26"
        }

        on_primary_fixed_variant: ColorObject {
            dark: "#004e5c"
            defaut: "#004e5c"
            light: "#004e5c"
        }

        on_secondary: ColorObject {
            dark: "#1d343a"
            defaut: "#1d343a"
            light: "#ffffff"
        }

        on_secondary_container: ColorObject {
            dark: "#cee7ef"
            defaut: "#cee7ef"
            light: "#061f24"
        }

        on_secondary_fixed: ColorObject {
            dark: "#061f24"
            defaut: "#061f24"
            light: "#061f24"
        }

        on_secondary_fixed_variant: ColorObject {
            dark: "#334a51"
            defaut: "#334a51"
            light: "#334a51"
        }

        on_surface: ColorObject {
            dark: "#dee3e5"
            defaut: "#dee3e5"
            light: "#171c1e"
        }

        on_surface_variant: ColorObject {
            dark: "#bfc8cb"
            defaut: "#bfc8cb"
            light: "#3f484b"
        }

        on_tertiary: ColorObject {
            dark: "#282f4d"
            defaut: "#282f4d"
            light: "#ffffff"
        }

        on_tertiary_container: ColorObject {
            dark: "#dde1ff"
            defaut: "#dde1ff"
            light: "#131937"
        }

        on_tertiary_fixed: ColorObject {
            dark: "#131937"
            defaut: "#131937"
            light: "#131937"
        }

        on_tertiary_fixed_variant: ColorObject {
            dark: "#3f4565"
            defaut: "#3f4565"
            light: "#3f4565"
        }

        outline: ColorObject {
            dark: "#899295"
            defaut: "#899295"
            light: "#70797c"
        }

        outline_variant: ColorObject {
            dark: "#3f484b"
            defaut: "#3f484b"
            light: "#bfc8cb"
        }

        primary: ColorObject {
            dark: "#84d2e7"
            defaut: "#84d2e7"
            light: "#00687a"
        }

        primary_container: ColorObject {
            dark: "#004e5c"
            defaut: "#004e5c"
            light: "#acedff"
        }

        primary_fixed: ColorObject {
            dark: "#acedff"
            defaut: "#acedff"
            light: "#acedff"
        }

        primary_fixed_dim: ColorObject {
            dark: "#84d2e7"
            defaut: "#84d2e7"
            light: "#84d2e7"
        }

        scrim: ColorObject {
            dark: "#000000"
            defaut: "#000000"
            light: "#000000"
        }

        secondary: ColorObject {
            dark: "#b2cbd2"
            defaut: "#b2cbd2"
            light: "#4b6269"
        }

        secondary_container: ColorObject {
            dark: "#334a51"
            defaut: "#334a51"
            light: "#cee7ef"
        }

        secondary_fixed: ColorObject {
            dark: "#cee7ef"
            defaut: "#cee7ef"
            light: "#cee7ef"
        }

        secondary_fixed_dim: ColorObject {
            dark: "#b2cbd2"
            defaut: "#b2cbd2"
            light: "#b2cbd2"
        }

        shadow: ColorObject {
            dark: "#000000"
            defaut: "#000000"
            light: "#000000"
        }

        source_color: ColorObject {
            dark: "#427c8b"
            defaut: "#427c8b"
            light: "#427c8b"
        }

        surface: ColorObject {
            dark: "#0f1416"
            defaut: "#0f1416"
            light: "#f5fafc"
        }

        surface_bright: ColorObject {
            dark: "#343a3c"
            defaut: "#343a3c"
            light: "#f5fafc"
        }

        surface_container: ColorObject {
            dark: "#1b2022"
            defaut: "#1b2022"
            light: "#e9eff1"
        }

        surface_container_high: ColorObject {
            dark: "#252b2d"
            defaut: "#252b2d"
            light: "#e4e9eb"
        }

        surface_container_highest: ColorObject {
            dark: "#303638"
            defaut: "#303638"
            light: "#dee3e5"
        }

        surface_container_low: ColorObject {
            dark: "#171c1e"
            defaut: "#171c1e"
            light: "#eff4f7"
        }

        surface_container_lowest: ColorObject {
            dark: "#090f11"
            defaut: "#090f11"
            light: "#ffffff"
        }

        surface_dim: ColorObject {
            dark: "#0f1416"
            defaut: "#0f1416"
            light: "#d5dbdd"
        }

        surface_tint: ColorObject {
            dark: "#84d2e7"
            defaut: "#84d2e7"
            light: "#00687a"
        }

        surface_variant: ColorObject {
            dark: "#3f484b"
            defaut: "#3f484b"
            light: "#dbe4e7"
        }

        tertiary: ColorObject {
            dark: "#bfc4eb"
            defaut: "#bfc4eb"
            light: "#575d7e"
        }

        tertiary_container: ColorObject {
            dark: "#3f4565"
            defaut: "#3f4565"
            light: "#dde1ff"
        }

        tertiary_fixed: ColorObject {
            dark: "#dde1ff"
            defaut: "#dde1ff"
            light: "#dde1ff"
        }

        tertiary_fixed_dim: ColorObject {
            dark: "#bfc4eb"
            defaut: "#bfc4eb"
            light: "#bfc4eb"
        }
    }
}
