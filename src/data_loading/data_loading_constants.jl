"""
Data loading constants and cache for NACA airfoil performance tables.
"""

using JLD2

# Global cache of loaded airfoil data
const NACA_DATABASE = Dict{String, NACADataTable}()

# Path to data directory
const DATA_DIR = joinpath(@__DIR__, "..", "..", "data", "airfoils")
