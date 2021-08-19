using Dates
using Random
"""
    extract_factor(factor::String;
                   phcbin::String="phc",
                   tmpdir::String="/tmp",
                   debug::Bool=false,
                   verbose::Bool=true)

Extracts the system and the generic point to represent an irreducible
factor in the input string factor.

The other optional input arguments are

    phcbin is the location of the binary phc

    tmpdir is the folder for temporary files
  
    if debug is true, then temporary files are not removed,
    by default all temporary files are removed

    verbose is the verbose flag
"""
function extract_factor(factor::String;
                        phcbin::String="phc",
                        tmpdir::String="/tmp",
                        debug::Bool=false,
                        verbose::Bool=true)
    if verbose
        println("Extracting the factor from the string")
        println(factor)
    end

    moment = Dates.now()
    fileseed = Dates.value(moment)
    rng = MersenneTwister(fileseed)
    sr = string(abs(round(rand(rng, Int64)))) 
    facsetfile = tmpdir * "/" * "facset" * sr
    facsolfile = tmpdir * "/" * "facsol" * sr
    
    if verbose
        println("Write factor to $facsetfile ...")
    end
    # removing the first line of the factor string
    lines = split(factor, "\n")
    factor2 = join(lines[2:length(lines)], "\n")
    factor3 = join(lines[3:length(lines)], "\n")
    
    fileset = open(facsetfile, "w")
    write(fileset, factor2)
    close(fileset)

    # facsys = read_system(facsetfile)
    pols = split(factor3, ";")
    setpols = []
    for i=1:length(pols)-1
        setpols = push!(setpols, pols[i] * ";")
    end

    if verbose
        println("The system :")
        println(setpols);
    end

    cmd_z = `$phcbin -z $facsetfile $facsolfile`
    if verbose
        println("Running ", cmd_z)
    end
    run(cmd_z)

    genpts_id = open(facsolfile, "r")
    strgenpts = String(read(genpts_id))
    close(genpts_id)
    if verbose
        println("The generic points :")
        print(strgenpts)
    end
    genpts = extract_solutions(strgenpts, verbose=false)

    result = Dict([("polynomials", setpols), ("points", genpts)])

    return result
end
