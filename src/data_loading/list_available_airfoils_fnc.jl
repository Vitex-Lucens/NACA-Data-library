"""
    list_available_airfoils_fnc()

Returns a vector of NACA airfoil codes available in the data directory.

# Returns
- `Vector{String}`: List of available NACA codes (e.g., ["0006", "0009", "0012"])
"""
function list_available_airfoils_fnc()
    if !isdir(DATA_DIR)
        return String[]
    end
    
    files_ARR = readdir(DATA_DIR)
    airfoils_ARR = String[]
    
    for file_STR in files_ARR
        if endswith(file_STR, ".jld2")
            push!(airfoils_ARR, replace(file_STR, ".jld2" => ""))
        end
    end
    
    return sort(airfoils_ARR)
end
