using Dates
using Random

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
function  extract_decomposition(outfile::String,
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

    dimstr = "Writing the factors of dimension"
    dimensions = findall(dimstr, output)

    if verbose
        # println("the dimension information :")
        # println(length(dimensions))
        if length(dimensions) == 0
            println("-> found no positive dimensional solutions")
        else
            for i=1:length(dimensions)
                # println(dimensions[i])
                rng = dimensions[i]
                # println(output[rng])
                endrng = length(dimstr) + rng[2] - 1
                strdim = output[endrng:endrng+2]
                # println(strdim)
                dim = parse(Int, strdim)
                println("-> found solutions of dimension ", dim)
            end
        end
    end

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
        isosols1file = tmpdir * "/" * "isosols1file" * sr
        isosols2file = tmpdir * "/" * "isosols2file" * sr
        isosols1_id = open(isosols1file, "w")
        println(isosols1_id, "THE SOLUTIONS :")
        rng = isolated[1]
        # println(rng)
        # println(output[rng])
        endrng = length(isostr) + rng[2]
        strisosols1 = output[endrng:length(output)]
        println(isosols1_id, strisosols1)
        close(isosols1_id)
        if verbose
             println("Extracting solutions from $isosols1file ...")
        end
        cmd_z = `$phcbin -z $isosols1file $isosols2file`
        run(cmd_z)
        if verbose
            println("Running ", cmd_z)
        end
        isosols2_id = open(isosols2file, "r")
        isosols = String(read(isosols2_id))
        close(isosols2_id)
        if verbose
            println("The isolated solutions :")
            print(isosols)
        end
        isosolutions = extract_sols(isosols, verbose=false)
    end

    return isosolutions
end
