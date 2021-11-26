# Conjugacy Classes

```@meta
CurrentModule = ClosedGroupFunctions
DocTestSetup = quote
    using ClosedGroupFunctions
end
```

For some groups (particularly matrix groups) the concept of conjugacy classes is important. 

The conjugacy class of an element ``g \in \mathscr{G}`` is defined as
```math
Cl(g) = \{h \cdot g \cdot h^{-1} | h \in \mathscr{G}\}
```

where ``h^{-1}`` is the inverse element `inv(h)` to `h` with ``h\cdot h^{-1} = e`` where ``e`` is the identity element of the group.

This package provides some functions to handle conjugacy classes.

## Calculating all conjugacy classes

The conjugacy classes can be calculated either using Julia's internal `inv()` function, or by providing a function as the `inverse` parameter.

```@docs
calculate_conjugacy_classes(group::Bijection{String, T}; inverse=inv, prnt=true) where T
```

!!! info
    Every element occurs only in *one* conjugacy classes. A disjoint union (``\dot\cup``) of all conjugacy classes of ``\mathscr{G}`` yields again ``\mathscr{G}``.


## Investigating classes
Conjugacy classes or any other sub-list of labeled elements of a labeled group can be investigated further by applying functions, here called an `invariant` because of the connection with conjugacy classes and functions, that are constant for a given class (but every function that expects only a group element of type `T` can be used).

### Is function invariant?
```@docs
is_invariant(class::Set{String}, group::Bijection{String, T}, invariant; prnt=true) where T
```

### Applying a function to the class(es)
#### To every element of one class
```@docs
apply_invariant_to_all_in_class(class::Set{String}, group::Bijection{String, T}, invariant; prnt=true) where T
```

#### To the first element of one class
```@docs
apply_invariant_to_first_in_class(class::Set{String}, group::Bijection{String, T}, invariant) where T
```

#### To the first element of every given class
```@docs
apply_invariant_to_first_in_all_classes(conjugacy_classes::Vector{Set{String}}, group::Bijection{String, T}, invariant; prnt=true) where T
```