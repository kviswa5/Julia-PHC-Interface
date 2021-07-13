"""
    testkatsura6()

Tests the stable mixed volume on a version of katsura6 ...
"""
function testkatsura6()
    version = version_string(verbose=false)
    println("Running $version")
    p1 = "x1+2*x2+2*x3+2*x4+2*x5+2*x6+2*x7-1;"
    p2 = "x4*x3+2*x5*x2+2*x6*x1+2*x7*x2-1*x6;"
    p3 = "x3^2+2*x4*x2+2*x5*x1+2*x6*x2+2*x7*x3-1*x5;"
    p4 = "x3*x2+2*x4*x1+2*x5*x2+2*x6*x3+2*x7*x4-1*x4;"
    p5 = "x2^2+2*x3*x1+2*x4*x2+2*x5*x3+2*x6*x4+2*x7*x5-1*x3;"
    p6 = "x2*x1+2*x3*x2+2*x4*x3+2*x5*x4+2*x6*x5+2*x7*x6-1*x2;"
    p7 = "x1^2+2*x2^2+2*x3^2+2*x4^2+2*x5^2+2*x6^2+2*x7^2-1*x1;"
    p = [p1, p2, p3, p4, p5, p6, p7]
    println("Computing the mixed volume of ", p, " ...")

    # mv, smv = juliaPHC.mixed_volume(p,stable=true,startsys=true,debug=true)
    mv, smv, q, qsols = juliaPHC.mixed_volume(p,stable=true,startsys=true)
    println("The mixed volume : ", mv)
    println("The stable mixed volume : ", smv)
    println("The start system ", q)
    println("The number of start solutions : ", length(qsols))
end
