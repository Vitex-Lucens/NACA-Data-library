"""
    clear_cache_fnc!()

Clear the in-memory airfoil data cache.
"""
function clear_cache_fnc!()
    empty!(NACA_DATABASE)
    return nothing
end
