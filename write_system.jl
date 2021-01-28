"""
    write_system(filename,system)

Input: filename - name of file to write the system
       system - A polynomial system (array of strings of polynomials),

Output: The polynomial system written to a file.

Example:

     pols = [\"x^3 + 2*x*y - 1;\", \"x + y - 1;\"];
     write_system(\"example.txt\", pols)
"""
function write_system(filename,system)
    sys_nvar = size(system)[1]
    sys_npoly = sys_nvar
    f = open(filename, "w")
    s = "$sys_npoly"
    write(f,s)
    write(f,"\n")
    for i in 1:sys_nvar
        str = system[i]
        write(f,str)
        write(f,"\n")
    end
    close(f)
end
