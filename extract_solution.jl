include("str2cmplx.jl") # is helper function, not exported, must be included
"""
    extract_solution(sol::String; precision=0, verbose=true)::Dict

On input is a string representation of a solution.

On output is a dictionary with the values for the coordinates,

the last value of the continuation parameter (time), the multiplicity,

estimates for the forward errror (err),

inverse of the condition number (rco),

and the backward error(res).

There are two optional arguments:

    precision allows to change the floating point type from the default
    Float64 to double double or quad double precision,
    respectively by precision=2 or precision=4

    verbose is the verbose flag.


    Example

    charsol = \"\"\"
    time = 1.0 + 0*I,
    multiplicity = 1,
    x = 1.23606797749979 + 0*I,
    y = -7.86151377757423E-1 - 9.95682444457783E-60*I,
    err =  3.476E-16,  rco =  1.998E-01,  res =  4.441E-16],\"\"\";

    dsol = extract_solution(charsol, verbose=false)
"""
function extract_solution(charsol::String; precision=0, verbose=true)::Dict
    result = Dict()
    attr_list = split(charsol,r"[,]")
    for j in 1:length(attr_list)
        if verbose
            println("processing equation ", attr_list[j], " ...")
        end
        indiv_list = split(attr_list[j],r"[=]")
        indiv_list[1] = replace(indiv_list[1],"\n"=>"")
        indiv_list[1] = lstrip(indiv_list[1])
        indiv_list[1] = rstrip(indiv_list[1])
        if(length(indiv_list) > 1)
            indiv_list[2] = replace(indiv_list[2],"\n"=>"")
            indiv_list[2] = lstrip(indiv_list[2])
            indiv_list[2] = rstrip(indiv_list[2])
            cpx_num = replace(indiv_list[2],"*I"=>"im")
            # remove trailing square brackets
            cpx_num = replace(cpx_num,"]"=>"")
            # remove trailing semicolon
            cpx_num = replace(cpx_num,";"=>"")
            cpx_result = str2cmplx(cpx_num, precision=precision)
            push!(result, indiv_list[1] => cpx_result)
        end
    end
    sort(collect(result), by=x->x[1])
    return result
end
