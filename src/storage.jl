"""
    store_group(identifier, group; filename_prefix = "closed_group_", filename_suffix = "")

Stores a given group as a serialized array in a file.
The identifier could be something like `"n"` where `n` is a characteristic number.
"""
function store_group(identifier, group; filename_prefix = "closed_group_", filename_suffix = "")
    filename = filename_prefix * identifier * filename_suffix
    serialize(filename, group)
end



"""
    load_group(identifier; filename_prefix = "closed_group_", filename_suffix = "") -> group

Loads a serialized group from a given file and returns the group.
"""
function load_group(identifier; filename_prefix = "closed_group_", filename_suffix = "")
    filename = filename_prefix * identifier * filename_suffix
    return deserialize(filename)
end