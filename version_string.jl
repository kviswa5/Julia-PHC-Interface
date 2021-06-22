using Dates
using Random

"""
    version_string(phcbin::String=\"phc\";
                   tmpdir::String=\"/tmp\",
                   verbose::Bool=true)::String

Returns the version string of executable phc.

The input arguments are

    phcbin is the location of the binary phc

    tmpdir is the folder for temporary files

    verbose is the verbose flag

By default, phc is assumed to be in the execution path.
If phc is not in the execution path, then phcbin needs
to define the absolute path name of the executable.

The default location of the output file is /tmp.
Run version_string(tmpdir=".") to change the output
folder to the current folder.

Run version_string(verbose=false) to turn off the verbose mode.
"""
function version_string(phcbin::String="phc";
                        tmpdir::String="/tmp",
                        verbose::Bool=true)::String
    moment = Dates.now()
    seed = Dates.value(moment)
    rng = MersenneTwister(seed)
    sr = string(abs(round(rand(rng, Int64)))) 

    outfile = tmpdir * "/out" * sr
    if verbose
         println("Writing the output $outfile ...")
    end
    cmd_b = `$phcbin --version $outfile`
    run(cmd_b)

    if verbose
         println("Extracting the version string from $outfile ...")
    end

    versionFile = open(outfile, "r")
    versionString = String(read(versionFile))
    close(versionFile)

    result = versionString[1:length(versionString)-1]

    if verbose
        println("The version string : $result")
    end

    return result
end
