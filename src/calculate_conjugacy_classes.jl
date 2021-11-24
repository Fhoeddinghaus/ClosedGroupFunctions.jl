"""
    calculate_conjugacy_classes(group::Bijection{String, T}; inverse=inv, prnt=true) -> conjugacy_classes::Vector{Set{String}}

Calculate all conjugacy classes {Cl(g) = {h * g * h^{-1} | h ∈ 𝒢} for a given finite, closed group, given the *inverse* function for elements of type *T* in 𝒢.
The *inverse* function defaults to the Julia *inv* function.
*prnt* enables/disables output of the class-sizes and remaining elements while computing the classes.
"""
function calculate_conjugacy_classes(group::Bijection{String, T}; inverse=inv, prnt=true)::Vector{Set{String}} where T
    # store the labels of the conjugacy classes in an Array/Vector of Sets
    conj = Vector{Set{String}}([Set([])])
    
    # for performance reasons, we don't directly iterate over the keys
    all_keys = sort(collect(keys(group)))
    max_key_idx = length(all_keys)
    
    #= 
    Direct iteration over the keys makes the function slow down at the last few conjugacy classes, 
    because for large groups >95% of the elements where already calculated and are unnecessary to check again.
    Instead, we remove all keys that are already found from the all_keys array and check only the remaining ones.
    =#
    while max_key_idx > 0
        k = all_keys[1]
        
        g = group[k]
        g_conj = Set([k])

        # calculate all conjugate elements to g
        for λ in keys(group)
            h = group[λ]
            el = h * g * inverse(h)
            push!(g_conj, group(el))
        end
        if prnt print("Cl($k): \t|", length(g_conj), "|") end
        # store g_conj
        push!(conj, g_conj)
        
        # delete all keys in g_conj from all_keys and reset the maximum index
        setdiff!(all_keys, g_conj)
        max_key_idx = length(all_keys)
        if prnt println("\t remaining elements: $max_key_idx") end
    end

    # remove empty set from first position
    popfirst!(conj)
    # return all conjugacy classes
    return conj
end