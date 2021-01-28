"""
    str2cmplxx(str)

Take a string and converts it to Complex format

Input: String of the form a+bI,a-bI

Outputs a complex double format, 
unless the string does not contain an imaginary component
"""
function str2cmplx(str)
    if (occursin("]",str) && length(str) > 1)
        str = str[1:end-1]
    end
    if (occursin("im", str))
        cpx = parse(Complex{Float64}, str)
    else
        cpx = parse(Float64,str)
    end
    return cpx
end
