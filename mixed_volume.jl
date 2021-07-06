using Dates
using Random
using Pipe: @pipe
"""
If stable = true, return both stable/common
"""
function mixed_volume(pols::Array{String,1};
                      phcbin::String="phc",
                      tmpdir::String="/Users/kv/Desktop/tmp",
                      startsys::Bool=true,
                      stable::Bool=false,
                      debug::Bool=false,
                      verbose::Bool=true)
    
    moment = Dates.now()          # use time to generate random string
    seed = Dates.value(moment)
    rng = MersenneTwister(seed)
    sr = string(abs(round(rand(rng, Int64)))) 
    
    
    infile = tmpdir * "/" * "mixedvolsysfile" * sr
    outfile = tmpdir * "/" *  "mixedvolout" * sr
    solsfile = tmpdir * "/" * "mixedsols" * sr
    startfile = tmpdir * "/" * "mixedstart" * sr
    temp = tmpdir * "/" * "mixedvoltemp" * sr
    #phcout = tmpdir * "/" * "mixedvolphcout" * sr
    session = tmpdir * "/" * "output" * sr
    
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
    # Call phc
    #@pipe `$phcbin -m $temp $phcout` |> run(_)
    
    run(pipeline(`cat $temp`,pipeline(`$phcbin -m`,stdout = "$session")))
    
    solf_id = open(outfile, "r")
    sols = String(read(solf_id))
    close(solf_id)
    
    # Find the stable mixed volume
    if stable
        mixedvol_str = "stable mixed volume"
    else
        mixedvol_str = "common mixed volume"
    end
    volstart = findall(mixedvol_str,sols)
    #print(volstart[1][1])
    volend = volstart[1][1]-1
    #print(sols)
    
    if stable
        vollast = findall("TIMING INFORMATION for Volume",sols)
        end_val = vollast[1][1]-length("TIMING INFORMATION for Volume")+2
        vollast = vollast[1][1]
        end_index = findall("\n",sols[volend+4+length("stable mixed volume"):vollast-1])
        end_index = end_index[1][1]
        mixed_vol = parse(Int64,sols[volend+4+length("stable mixed volume"):volend+4+length("stable mixed volume")+end_index])
    else
        vollast = findall("TIMING INFORMATION for Volume",sols)
        end_val = vollast[1][1]-length("TIMING INFORMATION for Volume")+2
        vollast = vollast[1][1]
        end_index = findall("\n",sols[volend+4+length("common mixed volume"):vollast-1])
        end_index = end_index[1][1]
        mixed_vol = parse(Int64,sols[volend+4+length("common mixed volume"):volend+4+length("stable mixed volume")+end_index])
    end
    
    
    print(mixed_vol)
    
    close(solf_id)
    solutions = extract_sols(sols)
   
end
