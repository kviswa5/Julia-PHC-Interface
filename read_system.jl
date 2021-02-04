include("check_semicolon.jl")
"""
    read_system(filename::String, verbose::Bool=false)

Input: The name of a file with polynomials in PHCpack format.

Output: The number of polynomials and a string array of polynomials.

Example:

    # See the documentation for write_system,
    # to make the file example.txt.
    dim, pols = read_system(\"example.txt\")
"""
function read_system(filename::String, verbose::Bool=false)
    count = 0;
    polyCount = 0;
    polynomial = [""]
    
    colcnt = 0
    ncolon = 0
    neq = 0
    nvar = 0
    for word in eachline(filename)
        word = lstrip(word)
        word = rstrip(word)
        if count == 0
            t  = split(word, r" *")
            neq = parse(Int,t[1])
            nvar = neq
            if length(t) == 2
                nvar = parse(Int,t[2])
            end
        # Note the first line      
        else
            ncolon = check_semicolon(word)
            colcnt = colcnt + ncolon
            if ncolon == 1
                push!(polynomial,word)
            else
                poly_list = split(word,";")
                for i = 1:length(poly_list)
                    word = rstrip(lstrip(poly_list[i]))
                    push!(polynomial,word)
                end
            end
        end
        count = count + 1
        if count > neq
            break
        end
    end
    
    if colcnt != neq
        println("number of colons != number of equations")
    end
    
    polynomial = setdiff(polynomial, [""])
    if verbose
        print(neq)
        print(" polynomials in the given system")
        println("")
        println(polynomial)
    end
    return nvar, polynomial
end
