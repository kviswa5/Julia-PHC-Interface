"""
The module juliaPHC is a collection of functions to prepare the input
and process the output of the executable phc of the software PHCpack.

To check whether the executable is present, type

    juliaPHC.version_string()

See the documentation of version_string for optional arguments.
"""
module juliaPHC

export version_string, read_system, write_system, solve_system
export extract_sols, extract_solution, mixed_volume
export test, testcyclic7, testkatsura6

include("version_string.jl")
include("read_system.jl")
include("write_system.jl")
include("solve_system.jl")
include("extract_sols.jl")
include("extract_solution.jl")
include("test.jl")
include("testcyclic7.jl")
include("mixed_volume.jl")
include("testkatsura6.jl")

end
