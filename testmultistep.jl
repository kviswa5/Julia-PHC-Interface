"""
    testmultistep()

Illustration of a multistep cascade on a simple system with

   one 3-dimensional linear factor,

   one 2-dimensional linear factor,
 
   twelve lines, and 4 isolated solutions.
"""
function testmultistep()
    version = version_string(verbose=false)
    println("Running $version")
    p1 = "(x1-1)*(x1-2)*(x1-3)*(x1-4);"
    p2 = "(x1-1)*(x2-1)*(x2-2)*(x2-3);"
    p3 = "(x1-1)*(x1-2)*(x3-1)*(x3-2);"
    p4 = "(x1-1)*(x2-1)*(x3-1)*(x4-1);"
    p = [p1, p2, p3, p4]
    println("Solving ", p, " ...") # using all available threads
    sols = solve(p,topdim=3,nthreads=Inf,verbose=false)
    println("Found ", length(sols), " components :")
    for solution in sols
        if solution["dimension"] > 0
            println("-> ", length(solution["factors"]),
                    " factors of dimension ", solution["dimension"])
        else
            println("-> ", length(solution["factors"][1]),
                    " isolated solutions")
        end
    end
end
