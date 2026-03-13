"""
Basic usage examples for NACAData.jl
"""

using NACAData

println("=" ^ 60)
println("NACAData.jl - Basic Usage Examples")
println("=" ^ 60)

# List available airfoils
println("\n1. Available airfoils:")
available = list_available_airfoils()
println("   ", available)

# Example 1: NACA 0012 at typical conditions
println("\n2. NACA 0012 at Re=100,000, α=5°:")
result = get_naca_performance("0012", 1e5, deg2rad(5))
println("   Cl = ", round(result.cl_ND, digits=4))
println("   Cd = ", round(result.cd_ND, digits=4))
println("   Cm = ", round(result.cm_ND, digits=4))
println("   L/D = ", round(result.cl_ND / result.cd_ND, digits=2))

# Example 2: Zero angle of attack
println("\n3. NACA 0012 at Re=100,000, α=0°:")
result = get_naca_performance("0012", 1e5, 0.0)
println("   Cl = ", round(result.cl_ND, digits=4))
println("   Cd = ", round(result.cd_ND, digits=4))

# Example 3: Reynolds number effects
println("\n4. Reynolds number effects (α=5°):")
for re in [5e4, 1e5, 5e5, 1e6]
    result = get_naca_performance("0012", re, deg2rad(5))
    println("   Re = ", Int(re), " → Cd = ", round(result.cd_ND, digits=5))
end

# Example 4: Angle of attack sweep
println("\n5. Angle of attack sweep (Re=100,000):")
println("   α(°)    Cl      Cd      L/D")
for alpha_deg in 0:2:10
    result = get_naca_performance("0012", 1e5, deg2rad(alpha_deg))
    ld = result.cl_ND / result.cd_ND
    println("   ", lpad(alpha_deg, 3), "   ", 
            rpad(round(result.cl_ND, digits=3), 6), "  ",
            rpad(round(result.cd_ND, digits=4), 6), "  ",
            round(ld, digits=1))
end

println("\n" * "=" ^ 60)
println("Note: Current data uses simplified models.")
println("Real experimental data will be added in future releases.")
println("=" ^ 60)
