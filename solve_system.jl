using Dates
using Random

"""
    solve_system(pols::Array{String,1},
                 phcbin::String=\"phc\",
                 tmpdir::String="/tmp",
                 verbose::Bool=true)

Takes on input a list of string representations of polynomials
and returns the solutions computed by the blackbox solver.

The other input arguments are

    phcbin is the location of the binary phc

    tmpdir is the folder for temporary files

    verbose is the verbose flag
"""
function solve_system(pols::Array{String,1},
                      phcbin::String="phc",
                      tmpdir::String="/tmp",
                      verbose::Bool=true)
    moment = Dates.now()          # use time to generate random string
    seed = Dates.value(moment)
    rng = MersenneTwister(seed)
    sr = string(abs(round(rand(rng, Int64)))) 

    infile = tmpdir * "/in" * sr
    if verbose
         println("Writing the system to $infile ...")
    end
    write_system(infile, pols)

    outfile = tmpdir * "/out" * sr
    if verbose
         println("Writing output to $outfile ...")
    end
    cmd_b = `$phcbin -b $infile $outfile`
    run(cmd_b)

    solfile = tmpdir * "/sol" * sr
    if verbose
         println("Extracting solutions from $solfile ...")
    end
    cmd_z = `$phcbin -z $infile $solfile`
    run(cmd_z)

    solf_id = open(solfile, "r")
    sols = String(read(solf_id))
    if verbose
        println("The solutions :")
        print(sols)
    end
    close(solf_id)
    solutions = extract_sols(sols)
    
    return solutions
end
