"""
    preload_all_airfoils_fnc!()

Load all available airfoil data files into memory cache.
Useful for applications that need fast access to all airfoils.
"""
function preload_all_airfoils_fnc!()
    airfoils_ARR = list_available_airfoils_fnc()
    for code_STR in airfoils_ARR
        load_airfoil_data_fnc!(code_STR)
    end
    return length(airfoils_ARR)
end
