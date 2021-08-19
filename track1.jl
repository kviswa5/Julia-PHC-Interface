"""
    track1(t,S,startsolution)

applies a posteriori step size control via phc -p
to track solution paths.
"""
function track1(t,S,startsolution)
    moment = Dates.now()          # use time to generate random string
    seed = Dates.value(moment)
    sr = string(MersenneTwister(seed))
    startfile = phctemp * "start" * sr
    targetfile = phctemp * "target" * sr
    startsolfile = phctemp * "startsols" * sr
    tracktemp = phctemp * "tracktemp" * sr
    trackphcout = phctemp * "trackphcout" * sr
    outfile = phctemp * "outfile" * sr
    solsfile = phctemp * "solsfile" * sr
    phczsolsfile = phctemp * "phczsols" * sr
    
    num_sols = size(startsolution,1)
    for k in 1:num_sols
        if startsolution[k]["time"] == 1
            flag = 1;
        end
    end
    
    if (flag)
        println("\n By. default the continuation parameter goes from time = 0.0 to 1.0 \n Please reset the time fields of the start solution")
    end
    
    write_solution(startsolsfile,startsolution);
    write_system(startfile,s)
    write_system(targetfile,s)
    
    tempstr = phctemp * "target" * sr * "\ny\n" * phctemp * "sols" * sr * "\n" * phctemp * "startsols" * sr * "\n0\n0\n0\n"
    
    tracktemp_id = open(tracktemp,'w')
    println(tracktemp_id, tempstr)
    close(tracktemp_id)

    
    run(pipeline(`cat $tracktemp`,pipeline(`$phcbin -p`,stdout = "$trackphcout")))
    
    run(pipeline(`cat $solsfile`,pipeline(`$phcbin -z`,stdout = "$phczsolsfile")))
    
    phczsols_id = open(phczsolsfile,'r')
    sols = String(read(phczsols_id))
    close(solf_id)
    
    L = extract_solutions(sols)
end
    
