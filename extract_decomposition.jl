using Dates
using Random
include("extract_factors.jl")
"""
    extract_decomposition(outfile::String,
                          topdim::Int;
                          phcbin::String="phc",
                          tmpdir::String="/tmp",
                          debug::Bool=false,
                          verbose::Bool=true)

On input is the output file of phc -B and the top dimension that
was given on input to phc -B.

The other optional input arguments are

    phcbin is the location of the binary phc

    tmpdir is the folder for temporary files
  
    if debug is true, then temporary files are not removed,
    by default all temporary files are removed

    verbose is the verbose flag
"""
function extract_decomposition(outfile::String,
                               topdim::Int;
                               phcbin::String="phc",
                               tmpdir::String="/tmp",
                               debug::Bool=false,
                               verbose::Bool=true)
    if verbose
        println("Opening $outfile ...")
    end

    outf_id = open(outfile, "r")
    output = String(read(outf_id))
    close(outf_id)

    superstr = "_sw"
    superidx = findall(superstr, output)
    supersets = []
    dimensions = []

    if length(superidx) == 0
        if verbose
            println("-> found no super witness sets")
        end
    else
        for i=1:length(superidx)
            rng = superidx[i]
            endrng = length(superstr) + rng[2] - 1
            strsuper = output[rng[1]:endrng+2]
            dimstrsuper = output[endrng:endrng+2]
            endstrsuper = findnext("\n", dimstrsuper, 1)
            dim = parse(Int, dimstrsuper[1:endstrsuper[1]-1])
            filesuperset = outfile * "_sw" * string(dim)
            if verbose
                println("-> found solutions of dimension ", dim)
                println(filesuperset, " is the super witness set file")
            end
            push!(supersets, filesuperset)
            push!(dimensions, dim)
        end
    end

    if(verbose)
        println("The dimensions : ", dimensions)
        println("The super set files :")
        for i=1:length(supersets)
            println(supersets[i])
        end
    end

    factors = extract_factors(outfile,Array{Int, 1}(dimensions),
       phcbin=phcbin,tmpdir=tmpdir,debug=debug,verbose=verbose)

    isostr = "THE ISOLATED SOLUTIONS :"
    isolated = findall(isostr, output)
    
    if length(isolated) == 0
        if verbose
            println("-> found no isolated solutions")
        end
    else
        if verbose
            println("-> found isolated solutions")
        end
        moment = Dates.now()
        fileseed = Dates.value(moment)
        rng = MersenneTwister(fileseed)
        sr = string(abs(round(rand(rng, Int64)))) 
        isosols2file = tmpdir * "/" * "isosols2file" * sr
        isosols1file = supersets[1]
        if verbose
             println("Extracting solutions from $isosols1file ...")
        end
        cmd_z = `$phcbin -z $isosols1file $isosols2file`
        if verbose
            println("Running ", cmd_z)
        end
        run(cmd_z)
        isosols2_id = open(isosols2file, "r")
        isosols = String(read(isosols2_id))
        close(isosols2_id)
        if verbose
            println("The isolated solutions :")
            print(isosols)
        end
        isosolutions = extract_sols(isosols, verbose=false)
        # push!(factors, isosolutions)
        for resfac in factors
            if resfac["dimension"] == 0
                push!(resfac["factors"], isosolutions)
            end
        end
    end

    return factors
end
