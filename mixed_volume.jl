using Dates
using Random

"""
    mixed_volume(pols::Array{String,1};
                 phcbin::String="phc",
                 tmpdir::String="/tmp",
                 startsys::Bool=false,
                 stable::Bool=false,
                 debug::Bool=false,
                 verbose::Bool=false)

Takes on input a list of string representations of polynomial
and returns the mixed volume as its first argument on return.

By default, only the mixed volume is returned.

If the start system is requested, then polyhedral homotopies
solve a random coefficient system.  This system may serve as
a start system to solve the original polynomials on input.

By default, solutions with zero coordinates are not counted.

If the stable mixed volume is requested, then the second output
argument is the upper bound on the number of affine solutions.
If both the start system and stable mixed volume are requested,
then the last argument on return are the solutions with zero coordinates.
In case the mixed volume equals the stable mixed volume,
then this last list may be empty.

The other optional input arguments are

    phcbin is the location of the binary phc

    tmpdir is the folder for temporary files

    startsys is the flag to run polyhedral homotopies

    stable is the flag to request the stable mixed volume

    if debug is true, then temporary files are not removed

    verbose is the verbose flag
"""
function mixed_volume(pols::Array{String,1};
                      phcbin::String="phc",
                      tmpdir::String="/tmp",
                      startsys::Bool=false,
                      stable::Bool=false,
                      debug::Bool=false,
                      verbose::Bool=false)
    
    moment = Dates.now()          # use time to generate random string
    seed = Dates.value(moment)
    rng = MersenneTwister(seed)
    sr = string(abs(round(rand(rng, Int64)))) 
    
    infile = tmpdir * "/" * "mixedvolsysfile" * sr
    outfile = tmpdir * "/" *  "mixedvolout" * sr
    solfile = tmpdir * "/" * "mixedsols" * sr
    axsolfile = tmpdir * "/" * "mixedaxsols" * sr
    startfile = tmpdir * "/" * "mixedstart" * sr
    temp = tmpdir * "/" * "mixedvoltemp" * sr
    session = tmpdir * "/" * "session" * sr
    
    write_system(infile, pols)
    
    if startsys && stable
        tempstr =  "y" * "\n" *infile * "\n" * outfile * "\n" * "4\n" * "1\n" * "y\n" * "n\n" * startfile * "\n" * "0\n0\n"
    end
        
    if startsys && !stable
        tempstr = "y" * "\n" * infile * "\n" * outfile * "\n" * "4\n" * "1\n" * "n\n"* "n\n" * startfile * "\n" * "0\n0\n"
    end
    
    if !startsys && stable
        tempstr =  "y" * "\n" *  infile * "\n" * outfile * "\n" * "4\n" * "0\n" * "y\n" * "n\n"* "y\n" 
    end
    
    if !startsys && !stable
        tempstr =  "y" * "\n" *  infile * "\n" * outfile * "\n" * "4\n" * "0\n" * "n\n"* "n\n"
    end
            
    temp_id = open(temp, "w")
    println(temp_id,tempstr)
    close(temp_id)
    
    run(pipeline(`cat $temp`,pipeline(`$phcbin -m`,stdout = "$session")))
    
    solf_id = open(outfile, "r")
    sols = String(read(solf_id))
    close(solf_id)
    
    # Find the mixed volume
    mixedvol_str = "common mixed volume"
    lenvolstr = length(mixedvol_str)
    volstart = findall(mixedvol_str,sols)
    volend = volstart[1][1]-1
    
    timing_str = "TIMING INFORMATION for Volume"
    vollast = findall(timing_str,sols)
    end_val = vollast[1][1]-length(timing_str)+2
    vollast = vollast[1][1]
    end_index = findall("\n",sols[volend+4+lenvolstr:vollast-1])
    end_index = end_index[1][1]
    solpos1 = volend+4+lenvolstr
    solpos2 = volend+2+length("stable mixed volume")+end_index
    mixed_vol = parse(Int64,sols[solpos1:solpos2])

    if stable
        stablevol_str = "stable mixed volume"
        lenstablestr = length(stablevol_str)
        volstart = findall(stablevol_str,sols)
        volend = volstart[1][1]-1
        vollast = findall("TIMING INFORMATION for Volume",sols)
        end_val = vollast[1][1]-length("TIMING INFORMATION for Volume")+2
        vollast = vollast[1][1]
        end_index = findall("\n",sols[volend+4+lenstablestr:vollast-1])
        end_index = end_index[1][1]
        solpos1 = volend+4+lenstablestr
        solpos2 = volend+2+lenstablestr+end_index
        stable_vol = parse(Int64,sols[solpos1:solpos2])
    end
    
    if startsys
        if verbose
             println("Reading the start system from $startfile ...")
        end
        dim, startpols = read_system(startfile, verbose)
        if verbose
             println("Extracting solutions from $solfile ...")
        end
        cmd_z = `$phcbin -z $startfile $solfile`
        run(cmd_z)
        solf_id = open(solfile, "r")
        sols = String(read(solf_id))
        close(solf_id)
        if verbose
            println("The solutions :")
            print(sols)
        end
        solutions = extract_sols(sols)
        if stable
            if stable_vol > mixed_vol
                cmd_z = `$phcbin -z $outfile $axsolfile`
                run(cmd_z)
                axsolf_id = open(axsolfile, "r")
                axsols = String(read(axsolf_id))
                close(axsolf_id)
                if verbose
                    println("The solutions with zero coordinates :")
                    print(axsols)
                end
                axsolutions = extract_sols(axsols)
            end
        end
    end

    if !debug
        if verbose
            println("Removing $infile ...")
        end
        rm(infile)
        if verbose
            println("Removing $outfile ...")
        end
        rm(outfile)
        if verbose
            println("Removing $session ...")
        end
        rm(session)
        if verbose
            println("Removing $temp ...")
        end
        rm(temp)
        if startsys
            if verbose
                println("Removing $startfile ...")
            end
            rm(startfile)
            if verbose
                println("Removing $solfile ...")
            end
            rm(solfile)
        end
    end

    if !startsys
        if stable
            return mixed_vol, stable_vol
        else
            return mixed_vol
        end
    else
        if stable
            if stable_vol > mixed_vol
                return mixed_vol, stable_vol, startpols, solutions, axsolutions
            else
                return mixed_vol, stable_vol, startpols, solutions
            end
        else
            return mixed_vol, startpols, solutions
        end
    end
end
