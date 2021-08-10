include("extract_factor.jl")
"""
    extract_factors(outfile::String,
                    dimensions::Array{Int, 1};
                    phcbin::String="phc",
                    tmpdir::String="/tmp",
                    debug::Bool=false,
                    verbose::Bool=true)

Extracts the irreducible factors of the output file of phc -B.

The second argument is the list of dimensions extracted from
the output file of phc -B.

The other optional input arguments are

    phcbin is the location of the binary phc

    tmpdir is the folder for temporary files
  
    if debug is true, then temporary files are not removed,
    by default all temporary files are removed

    verbose is the verbose flag
"""
function extract_factors(outfile::String,
                         dimensions::Array{Int, 1};
                         phcbin::String="phc",
                         tmpdir::String="/tmp",
                         debug::Bool=false,
                         verbose::Bool=true)
    if verbose
        println("Opening $outfile ...")
    end

    result = []
    for dim in dimensions
        resultfactor = Dict([("dimension", dim), ("factors", [])])
        push!(result, resultfactor)
    end

    outf_id = open(outfile, "r")
    output = String(read(outf_id))
    close(outf_id)

    factorstr = "FACTOR"
    factoridx = findall(factorstr, output)

    writedimstr = "Writing the factors of dimension"
    writedimidx = findall(writedimstr, output)
 
    lenfac = length(factoridx)

    currentdim = 0

    if lenfac == 0
        if verbose
            println("-> found no irreducible factors")
        end
    else
        if verbose
            println("-> found ", lenfac, " irreducible factors")
        end
        first = factoridx[1][1]
        if output[first:first+length(factorstr) + 2] == "FACTOR 1 "
            currentdim = parse(Int,output[first-8:first-6])
            # println("The current dimension : ", currentdim)
        end
        for i=2:lenfac
            second = factoridx[i][1]
            facset = extract_factor(output[first:second],verbose=false)
            # push!(result, facset)
            for resfac in result
                if resfac["dimension"] == currentdim
                    push!(resfac["factors"], facset)
                end
            end
            first = second
            if output[second:second+length(factorstr) + 2] == "FACTOR 1 "
                currentdim = parse(Int,output[first-8:first-6])
                # println("The current dimension : ", currentdim)
            end
        end
        #if output[first:first+length(factorstr) + 2] == "FACTOR 1 "
        #    currentdim = parse(Int,output[first-8:first-6])
        #    println("The current dimension : ", currentdim)
        #end
        lastidx = findall("THE ISOLATED SOLUTIONS :", output)
        if length(lastidx) == 0
            facset = output[first:length(output)]
        else
            rng = lastidx[1]
            facset = output[first:rng[1]-2]
        end
        # push!(result, facset)
        for resfac in result
            if resfac["dimension"] == currentdim
                push!(resfac["factors"], facset)
            end
        end
    end

    return result
end
