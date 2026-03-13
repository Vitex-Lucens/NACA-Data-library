using NACAData
using Test

@testset "NACAData.jl" begin
    @testset "Database initialization" begin
        # Check that database is loaded
        available = list_available_airfoils()
        @test length(available) > 0
        @test "0012" in available
    end
    
    @testset "Basic performance lookup" begin
        # Test NACA 0012 at typical conditions
        result = get_naca_performance("0012", 1e5, deg2rad(5))
        
        @test result.naca_code_STR == "0012"
        @test result.reynolds_ND == 1e5
        @test result.alpha_RAD ≈ deg2rad(5)
        
        # Check that coefficients are reasonable
        @test result.cl_ND > 0  # Positive lift at positive alpha
        @test result.cd_ND > 0  # Drag is always positive
        @test abs(result.cm_ND) < 0.1  # Moment should be small for symmetric airfoil
    end
    
    @testset "Zero angle of attack" begin
        # Symmetric airfoil should have zero lift at zero alpha
        result = get_naca_performance("0012", 1e5, 0.0)
        
        @test abs(result.cl_ND) < 0.01  # Nearly zero lift
        @test result.cd_ND > 0  # Still has profile drag
    end
    
    @testset "Reynolds number effects" begin
        # Higher Re should generally have lower drag
        result_low_re = get_naca_performance("0012", 5e4, deg2rad(5))
        result_high_re = get_naca_performance("0012", 1e6, deg2rad(5))
        
        @test result_low_re.cd_ND > result_high_re.cd_ND
    end
    
    @testset "Invalid airfoil code" begin
        # Should throw error for unavailable airfoil
        @test_throws ArgumentError get_naca_performance("9999", 1e5, deg2rad(5))
    end
    
    @testset "L/D ratio calculation" begin
        # Test that we can compute L/D
        result = get_naca_performance("0012", 1e5, deg2rad(5))
        ld_ratio = result.cl_ND / result.cd_ND
        
        @test ld_ratio > 0
        @test ld_ratio < 200  # Reasonable upper bound for 2D airfoil
    end
end
