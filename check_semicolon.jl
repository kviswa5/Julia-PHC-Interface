"""
    check_semicolon(s::SubString{String})

Returns the number of semicolons in a string s.
"""
function check_semicolon(s::SubString{String})
    ncolon = 0
    for i = 1:length(s)
        if s[i] == ';'
            ncolon = ncolon + 1
        end
    end
    return ncolon
end
