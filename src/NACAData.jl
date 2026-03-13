"""
NACAData.jl

Fast aerodynamic performance lookup tables for NACA airfoils based on 
experimental data from NACA technical reports and validated sources.

Provides Cl, Cd, Cm coefficients via interpolation for:
- NACA 4-digit symmetric airfoils
- Multiple Reynolds numbers
- Angle of attack range

# Example
```julia
using NACAData

# Get performance data for NACA 0012 at Re=100,000, alpha=5°
result = get_naca_performance("0012", 1e5, deg2rad(5))
println("Cl = ", result.cl_ND)
println("Cd = ", result.cd_ND)
```
"""
module NACAData

using Interpolations

# Include submodules (order matters - dependencies first!)
include("unit_conventions.jl")
include("types/nacaPerformance.jl")
include("types/nacaDataTable.jl")
include("data_loading/data_loading_constants.jl")
include("data_loading/load_airfoil_data_fnc!.jl")
include("data_loading/get_airfoil_data_fnc.jl")
include("data_loading/list_available_airfoils_fnc.jl")
include("data_loading/preload_all_airfoils_fnc!.jl")
include("data_loading/clear_cache_fnc!.jl")
include("performance_lookup/interpolate_performance_fnc.jl")
include("performance_lookup/get_naca_performance_fnc.jl")

# Export public API
export get_naca_performance_fnc
export list_available_airfoils_fnc
export NACAPerformance

end # module NACAData
