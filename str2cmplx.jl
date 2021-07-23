"""
    str2cmplx(str::String; precision::Int=0)

Take a string and converts it to Complex format

Input: String of the form a+bI,a-bI

Outputs a complex double format, 
unless the string does not contain an imaginary component

The optional argument is

    precision, to change the default Float64 type,

    precision=0 parses numbers to 64-bit floats (the default),

    precision=2 parses numbers to precision of 104 bits,
    precision=4 parses numbers to precision of 208 bits,
    the latter two corresponding respectively to
    double double and quad double precision.

"""
function str2cmplx(str::String; precision::Int=0)
    if (occursin("]",str) && length(str) > 1)
        str = str[1:end-1]
    end
    if precision == 2
        setprecision(BigFloat, 104)
        if (occursin("im", str))
            result = parse(Complex{BigFloat}, str)
        else
            result = parse(BigFloat,str)
        end
    elseif precision == 4
        setprecision(BigFloat, 208)
        if (occursin("im", str))
            result = parse(Complex{BigFloat}, str)
        else
            result = parse(BigFloat,str)
        end
    else
        if (occursin("im", str))
            result = parse(Complex{Float64}, str)
        else
            result = parse(Float64,str)
        end
    end
    return result
end
