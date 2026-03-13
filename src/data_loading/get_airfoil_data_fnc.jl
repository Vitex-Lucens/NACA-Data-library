"""
    get_airfoil_data_fnc(naca_code_STR::String)

Get NACA airfoil data, loading from disk if not already cached.

# Arguments
- `naca_code::String`: NACA airfoil code (e.g., "0012")

# Returns
- `NACADataTable`: Airfoil performance data
"""
function get_airfoil_data_fnc(naca_code_STR::String)
    if haskey(NACA_DATABASE, naca_code_STR)
        return NACA_DATABASE[naca_code_STR]
    end
    
    return load_airfoil_data_fnc!(naca_code_STR)
end
