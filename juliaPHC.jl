"""
The module juliaPHC is a collection of functions to prepare the input
and process the output of the executable phc of the software PHCpack.

To check whether the executable is present, type

    juliaPHC.version_string()

See the documentation of version_string for optional arguments.
"""
module juliaPHC

export version_string, read_system, write_system, solve_system
export extract_solutions, extract_solution, mixed_volume, solve
export test, testcyclic7, testcyclic8, testkatsura6, testmultistep

include("version_string.jl")
include("read_system.jl")
include("write_system.jl")
include("solve_system.jl")
include("mixed_volume.jl")
include("solve.jl")
include("extract_solutions.jl")
include("extract_solution.jl")
include("test.jl")
include("testcyclic7.jl")
include("testcyclic8.jl")
include("testmultistep.jl")
include("testkatsura6.jl")

end
