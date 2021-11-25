"""
    is_invariant(class::Vector{Set{String}}, group::Bijection{String, T}, invariant) -> (is_invariant::Bool, values::Vector)

Verifies that the given function `invariant` is an invariant for a given (conjugacy) class.
The `class` is given by labels that match the corresponding elements in the Bijection `group`.
"""
function is_invariant(class::Set{String}, group::Bijection{String, T}, invariant; prnt=true)::Tuple{Bool, Vector} where T
    if prnt println("The calculated values of the function '$invariant' are: ") end
    values = apply_invariant_to_all_in_class(class, group, invariant; prnt)
    cond = false
    if length(values) == 1
        cond = true
    end
    return (cond, values)
end

"""
    apply_invariant_to_all_in_class(class::Set{String}, group::Bijection{String, T}, invariant; prnt=true) -> values::Vector

Calculates the values of `invariant` for every element of a given `class`.
The `class` is given by labels that match the corresponding elements in the Bijection `group`.
"""
function apply_invariant_to_all_in_class(class::Set{String}, group::Bijection{String, T}, invariant; prnt=true)::Vector where T
    values = []
    for k in class
        v = invariant(group[k])
        if !(v in values)
            if prnt print(v, ", ") end
            push!(values, v)
        end
    end
    return values
end


"""
    apply_invariant_to_first_in_class(class::Set{String}, group::Bijection{String, T}, invariant) -> value

Calculates the value of `invariant` for the first element of a given `class`.
The `class` is given by labels that match the corresponding elements in the Bijection `group`.
"""
function apply_invariant_to_first_in_class(class::Set{String}, group::Bijection{String, T}, invariant) where T
    k = first(class)
    value = invariant(group[k])
    return value
end

"""
    apply_invariant_to_first_in_all_classes(conjugacy_classes::Vector{Set{String}}, group::Bijection{String, T}, invariant; prnt=true) -> values::Vector

Calculates the values of `invariant` for the first element of all given *classes*.
The `conjugacy_classes` are given by Sets of labels that match the corresponding elements in the Bijection `group`.
"""
function apply_invariant_to_first_in_all_classes(conjugacy_classes::Vector{Set{String}}, group::Bijection{String, T}, invariant; prnt=true)::Vector where T
    values = []
    for i in 1:length(conjugacy_classes)
        class = conjugacy_classes[i]
        v = apply_invariant_to_first_in_class(class, group, invariant)
        if prnt println("Class #$i: \t$invariant(g) = $v") end
        push!(values, v)
    end
    return values
end