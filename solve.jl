include("extract_decomposition.jl")

using Dates
using Random

"""
    solve(pols::Array{String,1};
          phcbin::String="phc",
          tmpdir::String="/tmp",
          topdim::Int=0,
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
  
    topdim is the expected top dimension of the solution set,
    topdim=0 returns only the isolated solutions, by default

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
function solve(pols::Array{String,1};
               phcbin::String="phc",
               tmpdir::String="/tmp",
               topdim::Int=0,
               startsys::Bool=false,
               nthreads=0,
               seed::Int=0,
               precision::Int=0,
               debug::Bool=false,
               verbose::Bool=true)
    if(topdim == 0)
        return solve_system(pols,phcbin=phcbin,tmpdir=tmpdir,
                            startsys=startsys,nthreads=nthreads,
                            seed=seed,precision=precision,
                            debug=debug,verbose=verbose)
    else
        moment = Dates.now()          # use time to generate random string
        fileseed = Dates.value(moment)
        rng = MersenneTwister(fileseed)
        sr = string(abs(round(rand(rng, Int64)))) 

        infile = tmpdir * "/" * "solveinfile" * sr
        outfile = tmpdir * "/" * "solveoutfile" * sr
        sessioninput = tmpdir * "/" * "solvesessioninput" * sr
        sessionoutput = tmpdir * "/" * "solvesessionoutput" * sr

        infile = tmpdir * "/in" * sr
        if verbose
             println("Writing the system to $infile ...")
        end
        write_system(infile, pols)

        outfile = tmpdir * "/out" * sr
        if verbose
             println("Writing the output to $outfile ...")
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

        sessionstr = "$topdim\n"
        sessioninput_id = open(sessioninput, "w")
        println(sessioninput_id, sessionstr)
        close(sessioninput_id)

        if nthreads == 0
            if seed == 0
                if precision == 0
                    cmd_B = `$phcbin -B $infile $outfile`
                else
                    cmd_B = `$phcbin -B$argprc $infile $outfile`
                end
            else
                if precision == 0
                    cmd_B = `$phcbin -B -0$argseed $infile $outfile`
                else
                    cmd_B = `$phcbin -B$argprc -0$argseed $infile $outfile`
                end
            end
        elseif nthreads == Inf
            if seed == 0
                if precision == 0
                    cmd_B = `$phcbin -B -t $infile $outfile`
                else
                    cmd_B = `$phcbin -B$argprc -t $infile $outfile`
                end
            else
                if precision == 0
                    cmd_B = `$phcbin -B -t -0$argseed $infile $outfile`
                else
                    cmd_B = `$phcbin -B$argprc -t -0$argseed $infile $outfile`
                end
            end
        else
            argnt = Int(nthreads) 
            if seed == 0
                if precision == 0
                    cmd_B = `$phcbin -B -t$argnt -0$argseed $infile $outfile`
                else
                    cmd_B = `$phcbin -B$argprc -t$argnt -0$argseed $infile $outfile`
                end
            else
                if precision == 0
                    cmd_B = `$phcbin -B -t$argnt -0$argseed $infile $outfile`
                else
                    cmd_B = `$phcbin -B$argprc -t$argnt -0$argseed $infile $outfile`
                end
            end
        end
        if verbose
            println("Running ", cmd_B)
        end
        run(pipeline(`cat $sessioninput`,
            pipeline(cmd_B,stdout = "$sessionoutput")))

        println("See $outfile for the results.")

        return extract_decomposition(outfile,topdim,verbose=true)
    end
end
