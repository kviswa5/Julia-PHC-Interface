"""
    write_system(filename::String, polynomials::Array{String,1})

Writes a polynomial system to file.

Input: filename is the name of the file to write the polynomials to.
       The array polynomials is the string representation of a system.

Example:

     pols = [\"x^3 + 2*x*y - 1;\", \"x + y - 1;\"];
     write_system(\"example.txt\", pols)
"""
function write_system(filename::String, polynomials::Array{String,1})
    sys_nvar = size(polynomials)[1]
    sys_npoly = sys_nvar
    f = open(filename, "w")
    s = "$sys_npoly"
    write(f,s)
    write(f,"\n")
    for i in 1:sys_nvar
        str = polynomials[i]
        write(f,str)
        write(f,"\n")
    end
    close(f)
end
