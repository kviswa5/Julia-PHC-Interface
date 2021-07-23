using Dates
using Random

"""
    solve_system(pols::Array{String,1};
                 phcbin::String="phc",
                 tmpdir::String="/tmp",
                 startsys::Bool=false,
                 nthreads=0,
                 seed::Int=0,
                 precision::Int=0,
                 debug::Bool=false,
                 verbose::Bool=true)

Takes on input a list of string representations of polynomials
and returns the solutions computed by the blackbox solver,
as first argument on return.  

Optionally, the polynomials in the start system and the start solutions
may be returned, respectively as the second and the third argument 
in the return tuple, if the option startsys is set to true.

The other optional input arguments are

    phcbin is the location of the binary phc

    tmpdir is the folder for temporary files

    startsys is the flag to indicate the return of the start system

    nthreads is the number of threads (by default no multithreading if zero),
    nthreads=Inf applies all available threads

    seed is the value of the seed for the random number generators,
    seed=0 generates a seed based on the current time, by default

    precision allows to request double double or quad double arithmetic,
    respectively by precision=2 or precision=4,
    precision=0 computes by default in hardware double precision

    if debug is true, then temporary files are not removed,
    by default all temporary files are removed

    verbose is the verbose flag
"""
function solve_system(pols::Array{String,1};
                      phcbin::String="phc",
                      tmpdir::String="/tmp",
                      startsys::Bool=false,
                      nthreads=0,
                      seed::Int=0,
                      precision::Int=0,
                      debug::Bool=false,
                      verbose::Bool=true)
    moment = Dates.now()          # use time to generate random string
    fileseed = Dates.value(moment)
    rng = MersenneTwister(fileseed)
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

    if seed != 0
        argseed = Int(seed)
    end
    if precision != 0
        argprc = Int(precision)
        if !(argprc in [0, 2, 4])
            println("Provide 0, 2, or 4 as precision value.")
            println("Will default to double precision ...")
            argprc = 0
        end
    end

    if nthreads == 0
        if seed == 0
            if precision == 0
                cmd_b = `$phcbin -b $infile $outfile`
            else
                cmd_b = `$phcbin -b$argprc $infile $outfile`
            end
        else
            if precision == 0
                cmd_b = `$phcbin -b -0$argseed $infile $outfile`
            else
                cmd_b = `$phcbin -b$argprc -0$argseed $infile $outfile`
            end
        end
    elseif nthreads == Inf
        if seed == 0
            if precision == 0
                cmd_b = `$phcbin -b -t $infile $outfile`
            else
                cmd_b = `$phcbin -b$argprc -t $infile $outfile`
            end
        else
            if precision == 0
                cmd_b = `$phcbin -b -t -0$argseed $infile $outfile`
            else
                cmd_b = `$phcbin -b$argprc -t -0$argseed $infile $outfile`
            end
        end
    else
        argnt = Int(nthreads) 
        if seed == 0
            if precision == 0
                cmd_b = `$phcbin -b -t$argnt -0$argseed $infile $outfile`
            else
                cmd_b = `$phcbin -b$argprc -t$argnt -0$argseed $infile $outfile`
            end
        else
            if precision == 0
                cmd_b = `$phcbin -b -t$argnt -0$argseed $infile $outfile`
            else
                cmd_b = `$phcbin -b$argprc -t$argnt -0$argseed $infile $outfile`
            end
        end
    end
    if verbose
        println("Running ", cmd_b)
    end
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
    solutions = extract_sols(sols, precision=precision, verbose=verbose)

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
        startsolutions = extract_sols(startsols,
                                      precision=precision, verbose=verbose)

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
