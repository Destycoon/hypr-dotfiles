import QtQuick
import qs.services.matugen

QtObject {
    property ColorObject background
    property ColorObject error
    property ColorObject error_container
    property ColorObject inverse_on_surface
    property ColorObject inverse_primary
    property ColorObject inverse_surface
    property ColorObject on_background
    property ColorObject on_error
    property ColorObject on_error_container
    property ColorObject on_primary
    property ColorObject on_primary_container
    property ColorObject on_primary_fixed
    property ColorObject on_primary_fixed_variant
    property ColorObject on_secondary
    property ColorObject on_secondary_container
    property ColorObject on_secondary_fixed
    property ColorObject on_secondary_fixed_variant
    property ColorObject on_surface
    property ColorObject on_surface_variant
    property ColorObject on_tertiary
    property ColorObject on_tertiary_container
    property ColorObject on_tertiary_fixed
    property ColorObject on_tertiary_fixed_variant
    property ColorObject outline
    property ColorObject outline_variant
    property ColorObject primary
    property ColorObject primary_container
    property ColorObject primary_fixed
    property ColorObject primary_fixed_dim
    property ColorObject scrim
    property ColorObject secondary
    property ColorObject secondary_container
    property ColorObject secondary_fixed
    property ColorObject secondary_fixed_dim
    property ColorObject shadow
    property ColorObject source_color
    property ColorObject surface
    property ColorObject surface_bright
    property ColorObject surface_container
    property ColorObject surface_container_high
    property ColorObject surface_container_highest
    property ColorObject surface_container_low
    property ColorObject surface_container_lowest
    property ColorObject surface_dim
    property ColorObject surface_tint
    property ColorObject surface_variant
    property ColorObject tertiary
    property ColorObject tertiary_container
    property ColorObject tertiary_fixed
    property ColorObject tertiary_fixed_dim

    function getcolors(colorObj) {
        return Matugen.darkmode ? colorObj.dark : colorObj.light;
    }
}
