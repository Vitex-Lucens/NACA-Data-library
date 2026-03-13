"""
    NACAPerformance

Aerodynamic performance coefficients for a NACA airfoil at specific conditions.

# Fields
- `cl_ND::Float64`: Lift coefficient (dimensionless)
- `cd_ND::Float64`: Drag coefficient (dimensionless)
- `cm_ND::Float64`: Moment coefficient about quarter-chord (dimensionless, positive = nose-up)
- `alpha_RAD::Float64`: Angle of attack (RADIANS, not degrees)
- `reynolds_ND::Float64`: Reynolds number (dimensionless)
- `naca_code_STR::String`: NACA airfoil code (e.g., "0012", "0006.12")

# Units
- **Angles**: RADIANS (use `deg2rad()` to convert from degrees)
- **Coefficients**: Dimensionless
- **Reynolds number**: Dimensionless
"""
struct NACAPerformance
    cl_ND::Float64
    cd_ND::Float64
    cm_ND::Float64
    alpha_RAD::Float64
    reynolds_ND::Float64
    naca_code_STR::String
end
