"""
The module runphc is a collection of functions to prepare the input
and process the output of the executable phc of the software PHCpack.

Exports `read_system`, `write_system`, and `extract_sols`.
"""
module runphc

export read_system, write_system, extract_sols

include("read_system.jl")
include("write_system.jl")
include("extract_sols.jl")

end
