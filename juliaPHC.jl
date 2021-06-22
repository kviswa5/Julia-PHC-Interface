"""
The module juliaPHC is a collection of functions to prepare the input
and process the output of the executable phc of the software PHCpack.

Exports `version_string`, `read_system`, `write_system`, `solve_system`,
`extract_sols`, and `test`.

To run the test in a Julia sesion, type

    juliaPHC.test()
"""
module juliaPHC

export version_string, read_system, write_system, solve_system, extract_sols, test

include("version_string.jl")
include("read_system.jl")
include("write_system.jl")
include("solve_system.jl")
include("extract_sols.jl")
include("test.jl")

end
