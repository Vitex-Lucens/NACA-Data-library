# NACAData.jl

**High-performance aerodynamic coefficient lookup for NACA airfoils**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Julia](https://img.shields.io/badge/Julia-1.6+-purple.svg)](https://julialang.org)

## Overview

NACAData.jl provides instant access to validated experimental aerodynamic data for NACA 4-digit symmetric airfoils. Built for performance-critical applications, this package delivers lift, drag, and moment coefficients through efficient interpolation of wind tunnel data from Abbott & von Doenhoff (1959).

**Key Features:**
- **Instant lookup** — faster than panel methods
- **Validated data** — Experimental wind tunnel measurements
- **Optimization-ready** — Designed for parametric studies requiring thousands of evaluations
- **Efficient storage** — 168 airfoils in 2 MB using JLD2 binary format
- **Lazy loading** — On-demand data loading with automatic caching

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

# Get aerodynamic coefficients for NACA 0012 at Re=100,000, α=5°
# Note: Angles must be in radians
perf = get_naca_performance_fnc("0012", 1.0e5, deg2rad(5.0))

println("Cl = ", perf.cl_ND)                    # 0.545
println("Cd = ", perf.cd_ND)                    # 0.010
println("Cm = ", perf.cm_ND)                    # -0.009
println("L/D = ", perf.cl_ND / perf.cd_ND)     # 52.3

# List available airfoils
airfoils = list_available_airfoils_fnc()
println("Available: ", length(airfoils), " airfoils")  # 168
```

## Database Coverage

**168 NACA 4-digit symmetric airfoils**

| Parameter | Range |
|-----------|-------|
| Thickness ratio | 6.00% to 23.76% |
| Reynolds number | 50,000 to 1,000,000 |
| Angle of attack | -10° to +16° |
| Data source | Abbott & von Doenhoff (1959) |

**Available airfoils include:**
- Standard series: 0006, 0009, 0012, 0015, 0018, 0021, 0024
- Fine resolution: 0006.12, 0006.24, 0012.24, 0012.45, etc.

## Unit Conventions

> **⚠️ Critical:** All angles must be in **radians**. Use `deg2rad()` for conversion.

| Quantity | Units | Notes |
|----------|-------|-------|
| Angle of attack (α) | Radians | Use `deg2rad()` to convert from degrees |
| Reynolds number (Re) | Dimensionless | Re = ρVc/μ, based on chord length |
| Lift coefficient (Cl) | Dimensionless | Normalized by dynamic pressure and area |
| Drag coefficient (Cd) | Dimensionless | Normalized by dynamic pressure and area |
| Moment coefficient (Cm) | Dimensionless | About quarter-chord (c/4), positive = nose-up |

## Use Cases

**Aircraft and Airship Design**
```julia
# Evaluate airfoil at cruise conditions
cruise_perf = get_naca_performance_fnc("0012", 5.0e5, deg2rad(2.0))
ld_ratio = cruise_perf.cl_ND / cruise_perf.cd_ND
```

**Parametric Studies**
```julia
# Compare multiple airfoils
for thickness in ["0009", "0012", "0015", "0018"]
    perf = get_naca_performance_fnc(thickness, 1.0e5, deg2rad(5.0))
    ld = perf.cl_ND / perf.cd_ND
    println("NACA $thickness: L/D = $(round(ld, digits=1))")
end
```

**Optimization Loops**
```julia
# Find optimal thickness for maximum L/D
function evaluate_airfoil(thickness_pct::Float64)
    code = lpad(string(Int(round(thickness_pct))), 4, "0")
    perf = get_naca_performance_fnc(code, 1.0e5, deg2rad(5.0))
    return perf.cl_ND / perf.cd_ND
end
```

## API Reference

### `get_naca_performance_fnc(naca_code_STR, reynolds_ND, alpha_RAD)`

Get aerodynamic coefficients using bilinear interpolation on tabulated data.

**Parameters:**
- `naca_code_STR::String` — NACA 4-digit code (e.g., `"0012"`, `"0006.12"`)
- `reynolds_ND::Float64` — Reynolds number (dimensionless, range: 50,000 to 1,000,000)
- `alpha_RAD::Float64` — Angle of attack in radians (use `deg2rad()` to convert)

**Returns:**
- `NACAPerformance` struct containing:
  - `cl_ND` — Lift coefficient
  - `cd_ND` — Drag coefficient
  - `cm_ND` — Moment coefficient (about c/4, positive = nose-up)
  - `alpha_RAD` — Angle of attack (radians)
  - `reynolds_ND` — Reynolds number
  - `naca_code_STR` — NACA code

### `list_available_airfoils_fnc()`

Returns sorted vector of available NACA airfoil codes.

**Returns:**
- `Vector{String}` — List of 168 NACA codes

## Performance

| Metric | Value |
|--------|-------|
| Lookup time | < 1 ms (after initial load) |
| Memory per airfoil | ~10 KB (cached) |
| Database size | 2.0 MB (168 airfoils) |
| Speed vs panel code | ~1000× faster |

## Limitations

- **Airfoil types:** NACA 4-digit symmetric only (no cambered airfoils)
- **Reynolds range:** 50,000 to 1,000,000 (extrapolation with warning outside range)
- **Angle range:** -10° to +16° (extrapolation with warning outside range)
- **Flow regime:** Low-speed incompressible (Mach < 0.3)
- **Geometry:** 2D infinite wing (no 3D effects)

## Data Source

**Abbott, I. H., & von Doenhoff, A. E. (1959)**  
*Theory of Wing Sections*  
Dover Publications

Wind tunnel validated experimental data accessed via experimentalAirfoilDatabase repository.

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Priority areas:**
- Cambered NACA 4-digit airfoils (2412, 4412, etc.)
- Extended Reynolds number ranges
- Additional validated data sources

**Development standards:**  
This project follows [Vitex Lucens Julia Development Standards](https://github.com/Vitex-Lucens/Vitex-Lucens-Julia-Development-Standards)

## License

MIT License — See [LICENSE](LICENSE) for details

## Citation

When using NACAData.jl in research, please cite:

```bibtex
@book{abbott1959theory,
  title={Theory of Wing Sections},
  author={Abbott, Ira H and Von Doenhoff, Albert E},
  year={1959},
  publisher={Dover Publications}
}
```

## Acknowledgments

Built on the foundational work of NACA researchers (1930s-1950s) and the comprehensive data compilation by Abbott & von Doenhoff.

---

**Version:** 0.1.0  
**Status:** Production ready  
**Airfoils:** 168 NACA 4-digit symmetric profiles
