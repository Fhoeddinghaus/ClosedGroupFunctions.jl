module ClosedGroupFunctions

    using ProgressMeter
    using Serialization
    using Bijections

    export 
        group_generator_basic,

        label_generators,
        labeled_group_generator_simple,
        labeled_group_generator_shortest,

        calculate_conjugacy_classes,
        
        is_invariant,
        apply_invariant_to_all_in_class,
        apply_invariant_to_first_in_class,
        apply_invariant_to_first_in_all_classes,
        
        store_group,
        load_group,

        group_element_calculate

    include("group_generator_basic.jl")
    include("labeled_group_generator.jl")
    include("calculate_conjugacy_classes.jl")
    include("conjugacy_classes_invariants.jl")
    include("storage.jl")
    include("helpers.jl")



end # module
