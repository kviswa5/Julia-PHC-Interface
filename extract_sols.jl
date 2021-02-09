include("str2cmplx.jl")
"""
    extract_sols(char_sols)

Take a string representation of the solution system
Preconditions - (1) The solutions are separated by "[]", as formatted by phc
                (2) Within solutions, attributes are separated by ","
Arguments - (1) char_sols - string output representation of solution system

Outputs a list of dictionaries that contain the solution systems

Example:

    charsols = \"\"\"
    [[time = 1.0 + 0*I,
      multiplicity = 1,
      x = 1.0 + 3.29443685725954E-83*I,
      y = -2.69520334646112E-17 - 3.29443685725954E-83*I,
      err =  2.961E-16,  rco =  7.346E-02,  res =  2.471E-83],
     [time = 1.0 + 0*I,
      multiplicity = 1,
      x = 5.0E-1 + 8.66025403784439E-1*I,
      y = 5.0E-1 - 8.66025403784439E-1*I,
      err =  0.000E+00,  rco =  2.275E-01,  res =  0.000E+00],
     [time = 1.0 + 0*I,
      multiplicity = 1,
      x = 5.0E-1 - 8.66025403784439E-1*I,
      y = 5.0E-1 + 8.66025403784439E-1*I,
      err =  0.000E+00,  rco =  2.275E-01,  res =  0.000E+00]]\"\"\";

    extract_sols(charsols)

"""
function extract_sols(char_sols)
    sol_list = split(char_sols ,r"[[]")
    println(length(sol_list))
    deleteat!(sol_list, 1)
    deleteat!(sol_list, 1)
    dict_list = []
    println(length(sol_list))
    for i in 1:length(sol_list)
        dict = Dict()
        attr_list = split(sol_list[i],r"[,]")
        deleteat!(attr_list, length(attr_list)) # deletes last element
        for j in 1:length(attr_list)
            indiv_list = split(attr_list[j],r"[=]")
            indiv_list[1] = replace(indiv_list[1],"\n"=>"")
            indiv_list[1] = lstrip(indiv_list[1])
            indiv_list[1] = rstrip(indiv_list[1])
            if (length(indiv_list) > 1)
                indiv_list[2] = replace(indiv_list[2],"\n"=>"")
                indiv_list[2] = lstrip(indiv_list[2])
                indiv_list[2] = rstrip(indiv_list[2])
                cpx_num = replace(indiv_list[2],"*I"=>"im")
                cpx_result = str2cmplx(cpx_num)
                push!(dict, indiv_list[1] => cpx_result)
            end
        end
        #if i > 1
        sort(collect(dict), by=x->x[1])
        push!(dict_list, dict)
        #end
    end
    return dict_list
end
