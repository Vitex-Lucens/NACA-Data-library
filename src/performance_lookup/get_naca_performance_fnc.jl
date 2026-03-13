"""
Public API functions for NACAData.jl

# IMPORTANT: Unit Conventions
- **Angle of attack**: RADIANS (not degrees) - use `deg2rad()` to convert
- **All coefficients**: Dimensionless
- **Reynolds number**: Dimensionless
"""

"""
    get_naca_performance_fnc(naca_code_STR::String, reynolds_ND::Float64, alpha_RAD::Float64)

Get aerodynamic performance coefficients for a NACA airfoil at specified conditions.
Uses bilinear interpolation on tabulated data.

# Arguments
- `naca_code_STR::String`: NACA 4-digit code (e.g., "0012", "006.12")
- `reynolds_ND::Float64`: Reynolds number (dimensionless, typically 50,000 to 1,000,000)
- `alpha_RAD::Float64`: Angle of attack in RADIANS (use `deg2rad()` to convert from degrees)

# Returns
- `NACAPerformance`: Struct containing:
  - `cl_ND`: Lift coefficient (dimensionless)
  - `cd_ND`: Drag coefficient (dimensionless)
  - `cm_ND`: Moment coefficient about quarter-chord (dimensionless, positive = nose-up)
  - `alpha_RAD`: Angle of attack (radians)
  - `reynolds_ND`: Reynolds number (dimensionless)
  - `naca_code_STR`: NACA code

# Units
- **Input angle**: RADIANS (not degrees)
- **Output coefficients**: All dimensionless
- **Moment reference**: Quarter-chord (c/4)

# Examples
```julia
using NACAData

# NACA 0012 at Re=100,000, alpha=5° (convert to radians!)
result = get_naca_performance_fnc("0012", 1e5, deg2rad(5))
println("Lift coefficient: ", result.cl_ND)      # Dimensionless
println("Drag coefficient: ", result.cd_ND)      # Dimensionless
println("Moment coefficient: ", result.cm_ND)    # Dimensionless, about c/4
println("L/D ratio: ", result.cl_ND / result.cd_ND)

# Multiple conditions
for alpha_deg in [0, 5, 10]
    perf = get_naca_performance_fnc("0012", 1e5, deg2rad(alpha_deg))
    println("α=\$(alpha_deg)°: Cl=\$(round(perf.cl_ND, digits=3))")
end

# Check available airfoils
available = list_available_airfoils_fnc()
println("Available: ", length(available), " airfoils")
```

# Throws
- `ArgumentError`: If NACA code is not available in database

# Data Source
Abbott, I. H., & von Doenhoff, A. E. (1959). Theory of Wing Sections.
Dover Publications. Via experimentalAirfoilDatabase.
"""
function get_naca_performance_fnc(naca_code_STR::String, reynolds_ND::Float64, alpha_RAD::Float64)
    # Get data table (lazy loads from disk if needed)
    local data_table
    try
        data_table = get_airfoil_data_fnc(naca_code_STR)
    catch e
        available_ARR = list_available_airfoils_fnc()
        throw(ArgumentError("NACA $naca_code_STR not found. Available airfoils: $available_ARR"))
    end
    
    # Interpolate performance
    (cl_ND, cd_ND, cm_ND) = interpolate_performance_fnc(data_table, reynolds_ND, alpha_RAD)
    
    # Return structured result
    return NACAPerformance(
        cl_ND,
        cd_ND,
        cm_ND,
        alpha_RAD,
        reynolds_ND,
        naca_code_STR
    )
end
