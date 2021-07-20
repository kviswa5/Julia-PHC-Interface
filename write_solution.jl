using Printf
"""
Writes a solution in character format to a phc Pack format, with an associated filename.
"""
function write_solution(filename,solution)
    f = open(filename, "w")
    temp_sol = extract_sols(solution)
    solution = deepcopy(temp_sol)
    # temp solution contains key values only associated with the variable names
    for i = 1:length(temp_sol)
        delete!(temp_sol[i], "time")
        delete!(temp_sol[i], "multiplicity")
        delete!(temp_sol[i], "err")
        delete!(temp_sol[i], "rco")
        delete!(temp_sol[i], "res")
    end
    
    var_names = []
    names = keys(temp_sol[1])
    for i in names
        push!(var_names,i)
    end
    n_var = length(var_names)
    sort!(var_names)
    
    temp_sol_str = "=========================\n"
    varstr = ""
    for k = 1:length(solution)
        str_1 = "solution "* string(k) * ": \n"
        str_2 = "t : "* @sprintf("%17.15e",real(solution[k]["time"]))* @sprintf("%17.15e",imag(solution[k]["time"]))*"\n"
        str_3 = "m : "* @sprintf("%17.15e",solution[k]["multiplicity"]) * "\n"
        varstr = "the solution for t: \n"
        for i in 1:n_var
            temp_2 = " " * var_names[i] * " : " * @sprintf("%17.15e",real(temp_sol[k][var_names[i]])) * " " * @sprintf("%17.15e",imag(temp_sol[k][var_names[i]])) * "\n"
            varstr = varstr * temp_2
        end
        str_4 = "==err : " * @sprintf("%17.15e",solution[k]["err"]) * " rco : " * @sprintf("%17.15e",solution[k]["rco"]) *" res : " * @sprintf("%17.15e",solution[k]["res"]) *  " == \n"
        temp_sol_str  = temp_sol_str *str_1*str_2*str_3*varstr*str_4
    end
    sol_string =  temp_sol_str
    write(f,sol_string)
    close(f)
end
