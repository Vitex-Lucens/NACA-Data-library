# Contributing to NACAData.jl

Thank you for your interest in contributing to NACAData.jl! This document provides guidelines for contributing to the project.

## How to Contribute

### Adding NACA Airfoil Data

The most valuable contribution is adding real experimental data from validated sources.

**Approved Data Sources:**
1. Abbott & von Doenhoff - "Theory of Wing Sections" (1959)
2. NACA Technical Reports (public domain)
3. UIUC Airfoil Database (with proper citation)
4. NASA Technical Reports
5. Other peer-reviewed, validated wind tunnel data

**Steps to add new airfoils:**

1. **Create extraction script** (if from new data source):
   - Create a new script in a temporary extraction directory
   - Script should read source data and output JLD2 files
   - Follow the format used in the experimentalAirfoilDatabase extraction

2. **Generate JLD2 file(s)**:
   - Each airfoil must be saved as `{NACA_CODE}.jld2` in `data/airfoils/`
   - NACA codes must use 4-digit format: `"0012"`, `"0006.12"`, etc.
   - File must contain a Dict with these exact keys:

```julia
using JLD2

data_dict_DICT = Dict(
    "naca_code" => "0012",                           # String: NACA code
    "reynolds_numbers" => [5e4, 1e5, 2e5, 5e5, 1e6], # Vector{Float64}: Re (dimensionless)
    "alpha" => deg2rad.([-10, -8, -6, ...]),         # Vector{Float64}: α (RADIANS!)
    "cl_matrix" => [...],                            # Matrix{Float64}: [n_alpha × n_reynolds]
    "cd_matrix" => [...],                            # Matrix{Float64}: [n_alpha × n_reynolds]
    "cm_matrix" => [...],                            # Matrix{Float64}: [n_alpha × n_reynolds]
    "source" => "Abbott & von Doenhoff (1959)..."    # String: Full citation
)

save("data/airfoils/0012.jld2", "data", data_dict_DICT)
```

3. **Verify data format**:
   - All angles MUST be in RADIANS
   - All coefficients are dimensionless
   - Matrix dimensions: `[n_alpha × n_reynolds]`
   - NACA code format: 4 digits before decimal (e.g., `"0006.12"` not `"006.12"`)

4. **Test the new airfoil**:
```julia
using NACAData

# Verify it loads
airfoils_ARR = list_available_airfoils_fnc()
@assert "0012" in airfoils_ARR

# Test performance lookup
perf = get_naca_performance_fnc("0012", 1e5, deg2rad(5.0))
@assert perf.cl_ND > 0
@assert perf.cd_ND > 0
```

5. **Add unit tests** in `test/runtests.jl`

6. **Update documentation**:
   - Update README.md with new airfoil count
   - Update DESCRIPTION.md if adding new thickness ranges
   - Include source citation

### Code Style

**This project follows Vitex Lucens Julia Development Standards. All contributions MUST comply.**

📖 **Coding standards**: https://github.com/Vitex-Lucens/Vitex-Lucens-Julia-Development-Standards

**Critical for NACAData.jl:**
- All angles MUST be in RADIANS (not degrees)

### Testing

All contributions must include tests:
```julia
@testset "NACA 0012 Performance" begin
    # Test basic lookup
    perf = get_naca_performance_fnc("0012", 1e5, deg2rad(5.0))
    
    @test perf.cl_ND > 0
    @test perf.cd_ND > 0
    @test perf.cl_ND / perf.cd_ND > 10  # Reasonable L/D
    
    # Test angle is in radians
    @test perf.alpha_RAD ≈ deg2rad(5.0)
end
```

Run tests with:
```bash
julia --project=. test/runtests.jl
```

Or using Pkg:
```julia
using Pkg
Pkg.activate(".")
Pkg.test()
```

### Documentation

All public functions require comprehensive docstrings:

```julia
"""
    function_name_fnc(arg1_UNIT::Type, arg2_UNIT::Type) -> ReturnType

Brief description of what the function does.

# Arguments
- `arg1_UNIT::Type`: Description with units specified
- `arg2_UNIT::Type`: Description with units specified

# Returns
- `ReturnType`: Description of return value

# Examples
```julia
result = function_name_fnc(value1_M, value2_RAD)
```

# Notes
- Important implementation details
- Unit conventions
- Limitations
"""
```

**Documentation updates required:**
- Add docstrings to all new functions
- Update README.md if adding new features or airfoils
- Update DESCRIPTION.md if expanding capabilities
- Include practical examples

## Development Setup

1. **Clone the repository**
```bash
git clone <repository-url>
cd NACAData
```

2. **Activate package environment**
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

3. **Verify installation**
```julia
using NACAData
airfoils_ARR = list_available_airfoils_fnc()
println("Available airfoils: ", length(airfoils_ARR))
```

4. **Make your changes**
   - Follow Vitex Lucens coding standards
   - Add JLD2 files to `data/airfoils/`
   - Update tests

5. **Run tests**
```julia
Pkg.test()
```

6. **Submit pull request**
   - Include clear description of changes
   - Reference any related issues
   - Ensure all tests pass

## Priority Areas

**Current Status: 168 NACA 4-digit symmetric airfoils available ✅**

**High Priority:**
- Cambered NACA 4-digit airfoils (2412, 4412, 6412, etc.)
- Extended Reynolds number ranges (Re < 50,000 or Re > 1,000,000)
- Additional data sources for validation

**Medium Priority:**
- NACA 5-digit series
- Extended angle of attack ranges
- Compressibility corrections (Mach > 0.3)
- 3D wing corrections

**Future:**
- NACA 6-series (laminar flow airfoils)
- Modern airfoils (supercritical, etc.)
- Visualization tools
- Interactive design tools

## Git Workflow

**Follow Vitex Lucens Git workflow standards.**

📖 **Git workflow details**: https://github.com/Vitex-Lucens/Vitex-Lucens-Julia-Development-Standards

**Key points:**
1. Never push to main branch directly
2. Create feature branches with descriptive names
3. Squash commits before merge
4. Request code review
5. Merge to main after approval

## Questions?

- Open an issue on GitHub for questions or discussions
- See https://github.com/Vitex-Lucens/Vitex-Lucens-Julia-Development-Standards for full coding standards
- Contact maintainers for data source validation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Remember:**
- ✅ All angles in RADIANS
- ✅ All variables with unit suffixes
- ✅ All functions end with `_fnc`
- ✅ NACA codes use 4-digit format
- ✅ Follow Vitex Lucens coding standards
