"""
    test()

Runs a simple test on the solve_system ...
"""
function test()
    p = ["x^3 + 2*x*y - 1;", "x + y - 1;"];
    name = "example.txt"
    runphc.write_system(name, p)
    println("A test polynomial system :")
    for i=1:size(p, 1)
        println(p[i])
    end
    n, q = runphc.read_system("example.txt")
    println(n, " polynomials read from file $name :")
    for i=1:size(q, 1)
        println(q[i])
    end
    sols = runphc.solve_system(p)
    println("The solutions :")
    for i=1:size(sols, 1)
        println("Solution ", i, " :")
        println(sols[i])
    end
end