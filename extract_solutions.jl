"""
    extract_solutions(char_sols::String;
                      precision=0, verbose=true)::Array{Dict,1}

Extracts the string representations of solutions into a dictionaries.

The input string is a list of lists, with brackets as separators.

Each solution is represented as a list of equations.

    Example:

    charsols = \"\"\"
    [[time = 1.0 + 0*I,
      multiplicity = 1,
      x = -3.23606797749979 + 0*I,
      y = 0 - 1.27201964951407*I,
      err =  1.174E-15,  rco =  1.079E-01,  res =  0.000E+00],
     [time = 1.0 + 0*I,
      multiplicity = 1,
      x = -3.23606797749979 + 0*I,
      y = 0 + 1.27201964951407*I,
      err =  1.174E-15,  rco =  1.079E-01,  res =  0.000E+00],
     [time = 1.0 + 0*I,
      multiplicity = 1,
      x = 1.23606797749979 + 0*I,
      y = -7.86151377757423E-1 - 9.95682444457783E-60*I,
      err =  3.476E-16,  rco =  1.998E-01,  res =  4.441E-16],
     [time = 1.0 + 0*I,
      multiplicity = 1,
      x = 1.23606797749979 + 0*I,
      y = 7.86151377757423E-1 + 9.95682444457783E-60*I,
      err =  3.476E-16,  rco =  1.998E-01,  res =  4.441E-16]]\"\"\";

There are two optional input arguments:

    precision allows to change the floating point type from the default
    Float64 to double double or quad double precision,
    respectively by precision=2 or precision=4

    verbose is the verbose flag.
"""
function extract_solutions(char_sols::String;
                           precision=0, verbose=true)::Array{Dict,1}
    sol_list = split(char_sols, r"[[]", keepempty=false)
    dict_list = []
    for i in 1:length(sol_list)
        if verbose
            println("extracting solution ", i, " ...")
            println(sol_list[i])
        end
        dict = extract_solution(String(sol_list[i]),
                                precision=precision, verbose=verbose)
        sort(collect(dict), by=x->x[1])
        push!(dict_list, dict)
    end
    return dict_list
end
