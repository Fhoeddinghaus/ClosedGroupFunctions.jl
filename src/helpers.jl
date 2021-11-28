"""
    group_element_calculate(expr::String, group::Bijection{String, T}, identity_element::T) -> key::String

Calculate the expression `expr` using the labels defined in `group`. The group `identity_element` is necessary.

Usage:
1. Let `G` be a labelled group.
2. Let `I` be the identity element from `G`.
3. Define a shorthand: 
    `Gcalc(expr::String) = group_element_calculate(expr, G, I)`
4. Use `Gcalc()``.
"""
function group_element_calculate(expr::String, group::Bijection{String, T}, identity_element::T)::String where T
    # if the identifier expr is already a key, return expr
    if expr in keys(group)
        return expr
    end
    # split expr, calculate element and return identifier from keys
    ks = split(expr, "")
    el = identity_element
    for k in ks
        el *= group[k]
    end
    return group(el)
end