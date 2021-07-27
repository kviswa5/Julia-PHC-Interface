"""
    testcyclic8()

Tests solving the cyclic 8-roots problem ...
"""
function testcyclic8()
    version = version_string(verbose=false)
    println("Running $version")
    p1 = "z0 + z1 + z2 + z3 + z4 + z5 + z6 + z7;"
    p2 = "z0*z1 + z1*z2 + z2*z3 + z3*z4 + z4*z5 + z5*z6 + z6*z7 + z7*z0;"
    p3 = string("z0*z1*z2 + z1*z2*z3 + z2*z3*z4 + z3*z4*z5 + z4*z5*z6",
                " + z5*z6*z7 + z6*z7*z0 + z7*z0*z1;")
    p4 = string("z0*z1*z2*z3 + z1*z2*z3*z4 + z2*z3*z4*z5 + z3*z4*z5*z6",
                " + z4*z5*z6*z7 + z5*z6*z7*z0 + z6*z7*z0*z1 + z7*z0*z1*z2;")
    p5 = string("z0*z1*z2*z3*z4 + z1*z2*z3*z4*z5 + z2*z3*z4*z5*z6" ,
                " + z3*z4*z5*z6*z7 + z4*z5*z6*z7*z0 + z5*z6*z7*z0*z1" ,
                " + z6*z7*z0*z1*z2 + z7*z0*z1*z2*z3;")
    p6 = string("z0*z1*z2*z3*z4*z5 + z1*z2*z3*z4*z5*z6 + z2*z3*z4*z5*z6*z7" ,
                " + z3*z4*z5*z6*z7*z0 + z4*z5*z6*z7*z0*z1" ,
                " + z5*z6*z7*z0*z1*z2 + z6*z7*z0*z1*z2*z3" ,
                " + z7*z0*z1*z2*z3*z4;")
    p7 = string("z0*z1*z2*z3*z4*z5*z6 + z1*z2*z3*z4*z5*z6*z7",
                " + z2*z3*z4*z5*z6*z7*z0 + z3*z4*z5*z6*z7*z0*z1",
                " + z4*z5*z6*z7*z0*z1*z2 + z5*z6*z7*z0*z1*z2*z3",
                " + z6*z7*z0*z1*z2*z3*z4 + z7*z0*z1*z2*z3*z4*z5;")
    p8 = "z0*z1*z2*z3*z4*z5*z6*z7 - 1;"
    p = [p1, p2, p3, p4, p5, p6, p7, p8]
    println("Solving ", p, " ...")
    sols = solve(p,topdim=1,nthreads=Inf) # use all available threads
    println("Found ", length(sols), " solutions")
end
