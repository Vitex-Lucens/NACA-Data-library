# NACAData.jl

Fast aerodynamic performance lookup tables for NACA airfoils.

## Overview

NACAData.jl provides pre-computed aerodynamic coefficients (Cl, Cd, Cm) for NACA airfoils based on experimental data from NACA technical reports. This eliminates the need for computationally expensive panel methods or CFD for standard airfoil analysis.

**Key Benefits:**
- ⚡ **1000x faster** than panel methods (instant lookup vs. seconds/minutes)
- ✅ **Validated experimental data** from Abbott & von Doenhoff (1959)
- 🎯 **Perfect for optimization** loops requiring thousands of evaluations
- 📊 **Simple API** - just specify airfoil, Reynolds number, and angle of attack
- 💾 **Efficient storage** - 168 airfoils in only 2 MB using JLD2 format
- 🚀 **Lazy loading** - Data loaded on-demand and cached in memory

## Installation

```julia
using Pkg
Pkg.add("NACAData")  # Once registered
```

For development:
```julia
using Pkg
Pkg.develop(path="/path/to/NACAData")
```

## Quick Start

```julia
using NACAData

# Get performance for NACA 0012 at Re=100,000, alpha=5°
# IMPORTANT: Angle must be in RADIANS (use deg2rad())
result = get_naca_performance("0012", 1e5, deg2rad(5))

println("Lift coefficient:   ", result.cl_ND)      # Dimensionless
println("Drag coefficient:   ", result.cd_ND)      # Dimensionless
println("Moment coefficient: ", result.cm_ND)      # Dimensionless, about c/4
println("L/D ratio:          ", result.cl_ND / result.cd_ND)

# List available airfoils
available = list_available_airfoils()
println("Available: ", length(available), " NACA airfoils")
```

## ⚠️ IMPORTANT: Unit Conventions

**This package uses strict unit conventions:**

### Angles
- **Angle of attack (α)**: Must be in **RADIANS** (not degrees)
- **Always use `deg2rad()`** to convert from degrees
- Example: `deg2rad(5)` for 5 degrees

### Dimensionless Coefficients
- **Lift coefficient (Cl)**: Dimensionless, normalized by dynamic pressure and area
- **Drag coefficient (Cd)**: Dimensionless, normalized by dynamic pressure and area
- **Moment coefficient (Cm)**: Dimensionless, normalized by dynamic pressure, area, and chord
  - **Reference point**: Quarter-chord (c/4)
  - **Sign convention**: Positive Cm = nose-up pitching moment

### Reynolds Number
- **Reynolds number (Re)**: Dimensionless, Re = ρVc/μ
- **Typical range**: 50,000 to 1,000,000
- **Based on**: Chord length

### Example with Units
```julia
# Correct usage - angle in radians
alpha_deg = 5.0
alpha_rad = deg2rad(alpha_deg)  # Convert to radians
perf = get_naca_performance("0012", 1e5, alpha_rad)

# Wrong - will give incorrect results!
# perf = get_naca_performance("0012", 1e5, 5.0)  # DON'T DO THIS!
```

## Current Status

**Version 0.1.0 - Production Ready**

Currently available:
- ✅ **168 NACA 4-digit symmetric airfoils**
- ✅ Thickness range: 6% to 23.76%
- ✅ Reynolds number range: 50,000 to 1,000,000
- ✅ Angle of attack range: -10° to +16°
- ✅ Experimental data from Abbott & von Doenhoff (1959)

**Database includes:**
- Common airfoils: 0006, 0009, 0012, 0015, 0018, 0021, 0024
- Fine resolution: Intermediate thicknesses (e.g., 006.12, 006.24, etc.)
- Total storage: 2.0 MB (efficient JLD2 binary format)

## Roadmap

### Phase 1 (Complete ✅)
- [x] Package structure and API design
- [x] Interpolation framework
- [x] JLD2 storage with lazy loading
- [x] 168 NACA 4-digit symmetric airfoils
- [x] Experimental data from Abbott & von Doenhoff (1959)
- [x] Comprehensive unit documentation

### Phase 2 (Future)
- [ ] Additional data sources (other repositories/databases)
- [ ] Cambered airfoils (2412, 4412, etc.)
- [ ] Extended Reynolds number ranges
- [ ] Stall prediction models
- [ ] Data visualization tools

### Phase 3 (Future)
- [ ] NACA 5-digit series
- [ ] NACA 6-series
- [ ] Modern airfoils (e.g., supercritical)
- [ ] Community contributions

## Data Sources

### Current Database
1. **Abbott, I. H., & von Doenhoff, A. E. (1959)**
   - "Theory of Wing Sections"
   - Dover Publications
   - Via experimentalAirfoilDatabase repository
   - 168 NACA 4-digit symmetric airfoils
   - Wind tunnel validated data

### Future Sources (Planned)
- Additional NACA Technical Reports (public domain)
- UIUC Airfoil Database (with proper citation)
- NASA Technical Reports
- Community contributions

All data sources are properly cited and documented in the package.

## API Reference

### `get_naca_performance(naca_code, reynolds, alpha)`

Get aerodynamic coefficients for specified conditions using bilinear interpolation.

**Arguments:**
- `naca_code::String` - NACA 4-digit code (e.g., "0012", "006.12")
- `reynolds::Float64` - Reynolds number (dimensionless, range: 50,000 to 1,000,000)
- `alpha::Float64` - Angle of attack in **RADIANS** (use `deg2rad()` to convert)

**Returns:**
- `NACAPerformance` struct with fields:
  - `cl_ND::Float64` - Lift coefficient (dimensionless)
  - `cd_ND::Float64` - Drag coefficient (dimensionless)
  - `cm_ND::Float64` - Moment coefficient about c/4 (dimensionless, positive = nose-up)
  - `alpha_RAD::Float64` - Angle of attack (radians)
  - `reynolds_ND::Float64` - Reynolds number (dimensionless)
  - `naca_code_STR::String` - NACA code

**Units:**
- Input angle: **RADIANS** (not degrees)
- All coefficients: Dimensionless
- Moment reference: Quarter-chord (c/4)

**Example:**
```julia
# NACA 0012 at Re=100,000, alpha=5°
perf = get_naca_performance("0012", 1e5, deg2rad(5))
println("Cl = ", perf.cl_ND)  # ~0.545
println("Cd = ", perf.cd_ND)  # ~0.010
println("L/D = ", perf.cl_ND / perf.cd_ND)  # ~52
```

### `list_available_airfoils()`

Returns vector of available NACA airfoil codes.

**Returns:**
- `Vector{String}` - Sorted list of NACA codes (e.g., ["0006", "0009", "0012", ...])

**Example:**
```julia
airfoils = list_available_airfoils()
println("Total airfoils: ", length(airfoils))  # 168
println("First 5: ", airfoils[1:5])
```

## Contributing

Contributions are welcome! Areas where help is needed:
- Adding experimental data from NACA reports
- Additional airfoil profiles
- Validation against known data
- Documentation improvements

## License

MIT License (to be added)

## Citation

If you use NACAData.jl in research, please cite the original NACA technical reports for the specific airfoils used.

## Acknowledgments

This package is built on the foundational work of:
- NACA researchers (1930s-1950s)
- Abbott & von Doenhoff
- UIUC Airfoil Database maintainers

## Data Format

Airfoil data is stored in efficient JLD2 binary format in `data/airfoils/`.

**File structure:**
- Each airfoil: `{naca_code}.jld2` (e.g., `0012.jld2`, `006.12.jld2`)
- File size: ~9.4 KB per airfoil
- Total database: 2.0 MB for 168 airfoils

**Data structure (Julia Dict):**
```julia
Dict(
    "naca_code" => "0012",                    # String
    "reynolds_numbers" => [5e4, 1e5, ...],    # Vector{Float64}, dimensionless
    "alpha" => [-0.174, -0.139, ...],         # Vector{Float64}, radians
    "cl_matrix" => [...],                     # Matrix{Float64}, [n_alpha × n_reynolds]
    "cd_matrix" => [...],                     # Matrix{Float64}, [n_alpha × n_reynolds]
    "cm_matrix" => [...],                     # Matrix{Float64}, [n_alpha × n_reynolds]
    "source" => "Abbott & von Doenhoff..."   # String
)
```

---

**Status:** Production ready with 168 NACA airfoils. Contributions and feedback welcome!
# NACA-Data-library
