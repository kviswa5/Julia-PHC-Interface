"""
    test()

Runs a simple test on the solve_system ...
"""
function test()
    version = version_string(verbose=false)
    println("Running $version")
    p = ["x^3 + 2*x*y - 1;", "x + y - 1;"];
    name = "example.txt"
    write_system(name, p)
    println("A test polynomial system :")
    for i=1:size(p, 1)
        println(p[i])
    end
    n, q = read_system("example.txt")
    println(n, " polynomials read from file $name :")
    for i=1:size(q, 1)
        println(q[i])
    end
    sols, startsys, startsols = solve_system(p,startsys=true)
    println("The start system :")
    for i=1:size(startsys, 1)
        println(startsys[i])
    end
    println("The start solutions :")
    for i=1:size(sols, 1)
        println("Start solution ", i, " :")
        println(startsols[i])
    end
    println("The solutions :")
    for i=1:size(sols, 1)
        println("Solution ", i, " :")
        println(sols[i])
    end
end
