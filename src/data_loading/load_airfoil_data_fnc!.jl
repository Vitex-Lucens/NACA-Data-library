"""
    load_airfoil_data_fnc!(naca_code_STR::String)

Load NACA airfoil data from JLD2 file into the database cache.
Returns the loaded NACADataTable or throws an error if file not found.

# Arguments
- `naca_code::String`: NACA airfoil code (e.g., "0012")

# Returns
- `NACADataTable`: Loaded airfoil performance data
"""
function load_airfoil_data_fnc!(naca_code_STR::String)
    if haskey(NACA_DATABASE, naca_code_STR)
        return NACA_DATABASE[naca_code_STR]
    end
    
    filepath_STR = joinpath(DATA_DIR, "$(naca_code_STR).jld2")
    
    if !isfile(filepath_STR)
        error("NACA $naca_code_STR data file not found at: $filepath_STR")
    end
    
    # Load Dict from JLD2 file
    data_dict_DICT = load(filepath_STR, "data")
    
    # Reconstruct NACADataTable from Dict
    data_table = NACADataTable(
        data_dict_DICT["naca_code"],
        data_dict_DICT["reynolds_numbers"],
        data_dict_DICT["alpha"],
        data_dict_DICT["cl_matrix"],
        data_dict_DICT["cd_matrix"],
        data_dict_DICT["cm_matrix"],
        data_dict_DICT["source"]
    )
    
    NACA_DATABASE[naca_code_STR] = data_table
    
    return data_table
end
