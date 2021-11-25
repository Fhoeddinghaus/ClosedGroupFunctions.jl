# Generating and Labelling

```@meta
CurrentModule = ClosedGroupFunctions
DocTestSetup = quote
    using ClosedGroupFunctions
end
```

Assuming you already have a list of generators of a **finite** group, the group under closure can be calculated with the following functions.

## Basic generator
The basic group generator takes an array of generators of type `T` and yields a tuple with a `Set` of all group elements of type `T` and the number of multiplications that were needed to calculate the whole group.

```@docs
group_generator_basic(generators::Array{T}; prnt = false, commutes=false) where T
```

## Labelling
### Labelling of the generators

A given array of generators of type `T` can be converted to a labeled `Bijection` using

```@docs
label_generators(generators::Array{T}; alphabet = default_alphabet()) where T
```

> There the `default_alphabet()` returns an alphabet with 103 possible characters that can be used for labelling (For bigger generator-lists, please use your own character list). The default alphabet consists of `'a':'z'`, `'A':'Z'`, `'𝒜':'𝒵'` and `'α':'ω'`.

### Labelling of the group
There are two functions, that can be used to label the whole group.

The 'simple' generator is fast and stores the first occuring label of every element. It stops if every element is calculated - for this to work, the final number of elements (from the result of the basic generator) has to be provided.

```@docs
labeled_group_generator_simple(labeled_generators::Bijection{String, T}, num_max_elements::Int64; prnt = false, commutes=false) where T
```

The 'shortest' method works analogous to the basic generator - it calculates every element and every possible multiplication and stores only the shortest occuring label of every element. This method can be quite slow because the difference in the storage: while the basic generator uses a `Set{T}` that automatically only keeps one copy of every element, the labeled generators use a `Bijection{String, T}` that is a bit slower. Aside from that, every time an element is calculated the function needs to check, if the new label is shorter than the stored one and switch the entries if so.

```@docs
labeled_group_generator_shortest(labeled_generators::Bijection{String, T}; prnt = false, commutes=false) where T
```