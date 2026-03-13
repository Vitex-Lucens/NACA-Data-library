"""
Unit Conventions for NACAData.jl

All aerodynamic data in this package follows strict unit conventions:

## Angles
- **Angle of attack (α)**: RADIANS (not degrees)
- Use `deg2rad()` to convert from degrees

## Dimensionless Coefficients
- **Lift coefficient (Cl)**: Dimensionless, normalized by dynamic pressure and area
- **Drag coefficient (Cd)**: Dimensionless, normalized by dynamic pressure and area  
- **Moment coefficient (Cm)**: Dimensionless, normalized by dynamic pressure, area, and chord
  - Moment reference point: Quarter-chord (c/4)
  - Positive Cm indicates nose-up pitching moment

## Reynolds Number
- **Reynolds number (Re)**: Dimensionless, Re = ρVc/μ
- Typical range in database: 50,000 to 1,000,000
- Based on chord length

## Data Format
- All JLD2 files store data as Julia Dict with keys:
  - "naca_code": String (e.g., "0012", "0006.12")
  - "reynolds_numbers": Vector{Float64} (dimensionless)
  - "alpha": Vector{Float64} (radians)
  - "cl_matrix": Matrix{Float64} (dimensionless, [n_alpha × n_reynolds])
  - "cd_matrix": Matrix{Float64} (dimensionless, [n_alpha × n_reynolds])
  - "cm_matrix": Matrix{Float64} (dimensionless, [n_alpha × n_reynolds])
  - "source": String (data source citation)
"""
module UnitConventions end
