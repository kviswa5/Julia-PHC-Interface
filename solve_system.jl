using Dates
using Random

"""
    solve_system(pols::Array{String,1};
                 phcbin::String="phc",
                 tmpdir::String="/tmp",
                 startsys::Bool=false,
                 debug::Bool=false,
                 verbose::Bool=true)

Takes on input a list of string representations of polynomials
and returns the solutions computed by the blackbox solver,
as first argument on return.  

Optionally, the polynomials in the start system and the start solutions
may be returned, respectively as the second and the third argument 
in the return tuple.

The four other optional input arguments are

    phcbin is the location of the binary phc

    tmpdir is the folder for temporary files

    startsys is the flag to indicate the return of the start system

    if debug is true, then temporary files are not removed

    verbose is the verbose flag
"""
function solve_system(pols::Array{String,1};
                      phcbin::String="phc",
                      tmpdir::String="/tmp",
                      startsys::Bool=false,
                      debug::Bool=false,
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

    if !startsys
        if !debug
            if verbose
                println("Removing $infile ...")
                rm(infile)
                println("Removing $outfile ...")
                rm(outfile)
                println("Removing $solfile ...")
                rm(solfile)
            end
        end
        return solutions
    else
        startfile = tmpdir * "/start" * sr
        if verbose
             println("Extracting start system and solutions from $outfile ...")
        end
        cmd_q = `$phcbin -z -p $outfile $startfile`
        run(cmd_q)
        if verbose
            println("Reading start system from $startfile ...")
        end
        dim, startpols = read_system(startfile, verbose)
        startsolfile = tmpdir * "/tmp" * sr
        if verbose
            println("Extracting start solutions from $startfile ...")
        end
        cmd_qz = `$phcbin -z $startfile $startsolfile`
        run(cmd_qz)
        startsolf_id = open(startsolfile, "r")
        startsols = String(read(startsolf_id))
        if verbose
            println("The start solutions :")
            print(startsols)
        end
        close(startsolf_id)
        startsolutions = extract_sols(startsols)

        if !debug
            if verbose
                println("Removing $infile ...")
                rm(infile)
                println("Removing $outfile ...")
                rm(outfile)
                println("Removing $solfile ...")
                rm(solfile)
                println("Removing $startfile ...")
                rm(startfile)
            end
        end

        return solutions, startpols, startsolutions
    end
end
