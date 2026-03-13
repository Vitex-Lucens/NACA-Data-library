"""
    NACADataTable

Internal structure holding tabulated performance data for a single NACA airfoil.
Data is stored in matrix form for efficient interpolation.

# Fields
- `naca_code_STR::String`: NACA airfoil code (e.g., "0012", "0006.12")
- `reynolds_numbers_ND::Vector{Float64}`: Available Reynolds numbers (dimensionless)
- `alpha_RAD::Vector{Float64}`: Angle of attack values (RADIANS, not degrees)
- `cl_matrix_ND::Matrix{Float64}`: Lift coefficients (dimensionless) [n_alpha × n_reynolds]
- `cd_matrix_ND::Matrix{Float64}`: Drag coefficients (dimensionless) [n_alpha × n_reynolds]
- `cm_matrix_ND::Matrix{Float64}`: Moment coefficients about c/4 (dimensionless) [n_alpha × n_reynolds]
- `source_STR::String`: Data source citation

# Matrix Indexing
- **Row index**: Angle of attack (alpha)
- **Column index**: Reynolds number
- Example: `cl_matrix_ND[i, j]` = Cl at `alpha_RAD[i]` and `reynolds_numbers_ND[j]`

# Units
- **All angles**: RADIANS
- **All coefficients**: Dimensionless
- **Reynolds numbers**: Dimensionless
"""
struct NACADataTable
    naca_code_STR::String
    reynolds_numbers_ND::Vector{Float64}
    alpha_RAD::Vector{Float64}
    cl_matrix_ND::Matrix{Float64}
    cd_matrix_ND::Matrix{Float64}
    cm_matrix_ND::Matrix{Float64}
    source_STR::String
end
