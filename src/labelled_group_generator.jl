"""
    label_generators(generators::Array{T}; alphabet::Vector{Char}) -> labelled_generators::Bijection{String, T}

Labels the given `generators` using the given `alphabet`, a vector of characters and returns the labelled generators.
The `alphabet` can be bigger than the number of generators, only the first `Ω = length(generators)` characters are used.
"""
function label_generators(generators::Array{T}; alphabet = default_alphabet())::Bijection{String, T} where T
    Ω = length(generators)
    labelled_generators = Bijection(Dict(map(=>, alphabet[1:Ω] .* "", generators)))
    return labelled_generators
end

"""
    default_alphabet()

Defines a default list of characters that are used to label the generators. Maximum is currently 103 symbols.
The default alphabet consists of `'a':'z'`, `'A':'Z'`, `'𝒜':'𝒵'` and `'α':'ω'`.
"""
function default_alphabet()::Vector{Char}
    latin_lc = collect('a':'z')   # 26 symbols
    latin_uc = collect('A':'Z')  # 26 symbols
    scr_uc = collect('𝒜':'𝒵')   # 26 symbols
    greek_lc = collect('α':'ω')   # 25 symbols
    return union(latin_lc, latin_uc, scr_uc, greek_lc)
end



"""
    labelled_group_generator_simple(labelled_generators::Bijection{String, T}, num_max_elements::Int64; prnt = false) -> labelled_group::Bijection{String, T}

Naive Method: Generates all group elements and labels them with the first occuring label. It stops after generating `num_max_elements` elements. The resulting label may not be the shortest possible label.
The generators can be given to the function either as a labelled `Bijection{String, T}` or as an unlabelled `Array{T}` that will automatically labelled.

"""
function labelled_group_generator_simple(labelled_generators::Bijection{String, T}, num_max_elements::Int64; prnt = false)::Bijection{String, T} where T
    labelled_group = Bijection(copy(labelled_generators))
    while length(labelled_group) < num_max_elements
        for one in sort(String.(keys(labelled_group))), two in sort(String.(keys(labelled_group)))
            # calculate element
            el = labelled_group[one] * labelled_group[two]
            
            # create the new label
            el_label = one * two

            # create the Pair
            el = el_label => el

            # try to store the Pair in the Bijection, fails if key or value is already in Bijection
            try push!(labelled_group, el) catch end
            
            # break if all elements are labelled
            if length(labelled_group) == num_max_elements
                break
            end
        end
    end
    return labelled_group
end

function labelled_group_generator_simple(generators::Array{T}, num_max_elements::Int64; prnt = false)::Bijection{String, T} where T
    labelled_generators = label_generators(generators)
    return labelled_group_generator_simple(labelled_generators, num_max_elements; prnt)
end

"""
    labelled_group_generator_shortest(labelled_generators::Bijection{String, T}; prnt = false)::Tuple{Bijection{String, T}, Int64} -> labelled_group::Bijection{String, T}, num_all_mult::Int64

For the general method and description of `prnt` see `group_generator_basic()`.
This method generates all other elements of the closed group and labels them using the lexicographically first appearing (and shortest) label.
As Bijections are slower than Sets, this method can be really slow compared to `group_generator_basic()`.
"""
function labelled_group_generator_shortest(labelled_generators::Bijection{String, T}; prnt = false)::Tuple{Bijection{String, T}, Int64} where T

    # arrays to store generated elements in different levels of generation
    group_prev_level = Bijection{String, T}()
    group_current_level = Bijection(copy(labelled_generators))
    group_next_level = [1]

    level = 0
    size_after = 0
    new_elements = 0

    num_all_mult = 0

    labelled_generators_keys = sort(String.(keys(labelled_generators)))

    while length(group_current_level) > 0
        level += 1
        num_multiplications = 0

        # calculate the number of multiplications in this level
        num_max_mult = length(group_current_level) * length(labelled_generators)

        if prnt
            prog = Progress(num_max_mult)
        end
        
        # empty next for new iteration
        group_next_level = Bijection{String, T}()
        
        # multiplicate current with the generators and save new elements to next
        for one in labelled_generators_keys
            for two in sort(String.(keys(group_current_level)))
                num_multiplications += 1
                
                # calculate element
                el = labelled_generators[one] * group_current_level[two]
                # create the new label
                el_label = one * two

                # create the Pair
                el_pair = el_label => el

                # try to store the Pair in the Bijection, fails if key or value is already in Bijection
                try push!(group_next_level, el_pair) catch end

                if prnt
                    size_next_level = length(group_next_level)
                    update!(prog, num_multiplications; showvalues = [(:i,"$num_multiplications/$num_max_mult"),(:level, level),(:size,size_after),(:new_elements, new_elements),(:size_next_level, "$size_next_level ($(size_next_level/num_multiplications * 100)%)")])
                end
            end
        end
        
        if prnt print("current → prev...") end
        
        # current is now done, move to previous
        # union!() doesn't work for Bijections
        for (el_label, el) in group_current_level
            try push!(group_prev_level, el_label => el) catch end
        end
        
        if prnt println(" done.") end
        
        if prnt print("next → current...") end

        # move all from next to current that are not in previous
        # group_current_level = setdiff(group_next_level, group_prev_level)
        group_current_level = Bijection{String, T}()
        for (el_label, el) in group_next_level
            vals = values(group_prev_level)
            if !(el in vals)
                # element not in previous, store in current
                push!(group_current_level, el_label => el)
            end # element is in previous with shorter label
        end
        
        if prnt println(" done.") end
        
        # some stats to display
        size_after = length(group_prev_level)
        new_elements = length(group_current_level)
        num_all_mult += num_multiplications
        println("level #",level," size ", size_after, " and ", new_elements," new elements (",num_multiplications," multiplications)")
        if prnt
            println("level #",level," size ", size_after, " and ", new_elements," new elements (",num_multiplications," multiplications)")
            # countdown to prevent directly overwriting with progressbar
            print("5..."); sleep(1); print("4..."); sleep(1); print("3..."); sleep(1); print("2..."); sleep(1); println("1..."); sleep(1);
        end
    end
    
    println("\nEnded after ", level, " iterations. \nThe resulting group has ", size_after, " elements.")
    
    # returns the final group and the number of multiplications needed
    return group_prev_level, num_all_mult
end

function labelled_group_generator_shortest(generators::Array{T}; prnt = false)::Tuple{Bijection{String, T}, Int64} where T
    labelled_generators = label_generators(generators)
    return labelled_group_generator_shortest(labelled_generators; prnt)
end