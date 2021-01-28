"""
    check_semicolon(s::String)

Returns the number of semicolons in a string s.
"""
function check_semicolon(s::String)
    ncolon = 0
    for i = 1:length(s)
        if string[i] == ';'
            ncolon = ncolon + 1
        end
    end
    return ncolon
end
