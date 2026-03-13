"""
Interpolation functions for NACA airfoil performance data.
"""

"""
    interpolate_performance_fnc(data_table::NACADataTable, reynolds_ND::Float64, alpha_RAD::Float64)

Interpolate aerodynamic coefficients from tabulated data.

Uses bilinear interpolation for Reynolds number and angle of attack.

# Arguments
- `data_table::NACADataTable`: Tabulated performance data
- `reynolds_ND::Float64`: Reynolds number (dimensionless)
- `alpha_RAD::Float64`: Angle of attack in radians

# Returns
- `(cl_ND, cd_ND, cm_ND)`: Tuple of interpolated coefficients

# Notes
- Extrapolation is performed with constant values at boundaries
- Warning is issued if extrapolating beyond data range
"""
function interpolate_performance_fnc(data_table::NACADataTable, reynolds_ND::Float64, alpha_RAD::Float64)
    # Check if we're extrapolating
    re_min_ND = minimum(data_table.reynolds_numbers_ND)
    re_max_ND = maximum(data_table.reynolds_numbers_ND)
    alpha_min_RAD = minimum(data_table.alpha_RAD)
    alpha_max_RAD = maximum(data_table.alpha_RAD)
    
    if reynolds_ND < re_min_ND || reynolds_ND > re_max_ND
        @warn "Reynolds number $(reynolds_ND) is outside data range [$(re_min_ND), $(re_max_ND)] for NACA $(data_table.naca_code_STR). Extrapolating."
    end
    
    if alpha_RAD < alpha_min_RAD || alpha_RAD > alpha_max_RAD
        alpha_DEG = rad2deg(alpha_RAD)
        alpha_min_DEG = rad2deg(alpha_min_RAD)
        alpha_max_DEG = rad2deg(alpha_max_RAD)
        @warn "Angle of attack $(alpha_DEG)° is outside data range [$(alpha_min_DEG)°, $(alpha_max_DEG)°] for NACA $(data_table.naca_code_STR). Extrapolating."
    end
    
    # Create interpolation objects (linear interpolation with flat extrapolation)
    itp_cl = LinearInterpolation(
        (data_table.alpha_RAD, data_table.reynolds_numbers_ND),
        data_table.cl_matrix_ND,
        extrapolation_bc=Flat()
    )
    
    itp_cd = LinearInterpolation(
        (data_table.alpha_RAD, data_table.reynolds_numbers_ND),
        data_table.cd_matrix_ND,
        extrapolation_bc=Flat()
    )
    
    itp_cm = LinearInterpolation(
        (data_table.alpha_RAD, data_table.reynolds_numbers_ND),
        data_table.cm_matrix_ND,
        extrapolation_bc=Flat()
    )
    
    # Interpolate at requested conditions
    cl_ND = itp_cl(alpha_RAD, reynolds_ND)
    cd_ND = itp_cd(alpha_RAD, reynolds_ND)
    cm_ND = itp_cm(alpha_RAD, reynolds_ND)
    
    return (cl_ND, cd_ND, cm_ND)
end
