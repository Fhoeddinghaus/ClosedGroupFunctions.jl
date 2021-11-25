"""
    group_generator_basic(generators::Array{T}; prnt=false, commutes=false) -> Set(group), num_all_mult

Calculate all other elements of this closed group by simply multiplying all elements and storing new elements and doing all new multiplications.
Not very efficient but works. Limit is at above 50_000 elements (one night to calculate).

The `prnt` variable can be used to specify if the programm should output the progressbar. This can slow things down.

The `commutes` variable tells the programm if the elements (matrices, numbers, ...) always commute (true) or if the reversed multiplication should be tried (false). 
By default the programm does not expect the elements to commute (x2 multiplications)
"""
function group_generator_basic(generators::Array{T}; prnt = false, commutes=false)::Tuple{Set{T},Int64} where T

    # arrays to store generated elements in different levels of generation
    group_prev_level = Set([])
    group_current_level = Set(copy(generators))
    group_next_level = [1]

    level = 0
    size_after = 0
    new_elements = 0

    num_all_mult = 0

    while length(group_current_level) > 0
        level += 1
        num_multiplications = 0

        # calculate the number of multiplications in this level
        num_max_mult = length(group_current_level) * (length(group_current_level) + length(group_prev_level))
        if !commutes
            num_max_mult *= 2
        end

        if prnt
            prog = Progress(num_max_mult)
        end
        
        # empty next for new iteration
        group_next_level = Set([])
        
        # 1. multiplicate current with previous and save new elements to next
        for M in group_prev_level
            for N in group_current_level
                num_multiplications += 1
                el = M * N
                if !commutes
                    el_reverse = N * M
                    num_multiplications += 1
                end
                
                #union!(group_next_level, [el]) # slower alternative
                push!(group_next_level, el)
                if !commutes && el_reverse != el
                    push!(group_next_level, el_reverse)
                end

                # space optimization was replaced by switching to the Set data-type.
                #if num_multiplications % 1_000_000 == 0
                    # free up some space every 1 000 000 iterations (decrease RAM usage from 20+ GB to 2-3 GB)
                    #unique!(group_next_level)
                #end

                if prnt
                    size_next_level = length(group_next_level)
                    update!(prog, num_multiplications; showvalues = [(:i,"$num_multiplications/$num_max_mult"),(:level, level),(:size,size_after),(:new_elements, new_elements),(:size_next_level, "$size_next_level ($(size_next_level/num_multiplications * 100)%)")])
                end
            end
        end
        
        # 2. multiplicate current with itself
        for M in group_current_level
            for N in group_current_level
                num_multiplications += 1
                el = M * N
                if !commutes
                    el_reverse = N * M
                    num_multiplications += 1
                end
                
                #union!(group_next_level, [el]) # slower alternative
                push!(group_next_level, el)
                if !commutes && el_reverse != el
                    push!(group_next_level, el_reverse)
                end
                
                # space optimization was replaced by switching to the Set data-type.
                #if num_multiplications % 1_000_000 == 0
                    # free up some space every 1 000 000 iterations (decrease RAM usage from 20+ GB to 2-3 GB)
                    #unique!(group_next_level)
                #end

                if prnt
                    size_next_level = length(group_next_level)
                    update!(prog, num_multiplications; showvalues = [(:i,"$num_multiplications/$num_max_mult"),(:level, level),(:size,size_after),(:new_elements, new_elements),(:size_next_level, "$size_next_level ($(size_next_level/num_multiplications * 100)%)")])
                end
            end
        end
        
        if prnt print("current → prev...") end
        
        # current is now done with itself and previous, move to previous
        union!(group_prev_level, group_current_level)
        
        if prnt println(" done.") end
        
        if prnt print("next → current...") end

        # move all from next to current that are not in previous
        group_current_level = setdiff(group_next_level, group_prev_level)
        
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