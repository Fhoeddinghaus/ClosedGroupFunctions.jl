# Storage

```@meta
CurrentModule = ClosedGroupFunctions
DocTestSetup = quote
    using ClosedGroupFunctions
end
```

This package provides a simple interface for `(de)serialize` for convenience.
If you want to use a specific file extension, just use the `filename_suffix` parameter, e.g. for `.dat` use `filename_suffix = ".dat"`.

## Storing a group
```@docs
store_group(identifier, group; filename_prefix = "closed_group_", filename_suffix = "")
```

!!! info
    The stored object doesn't need to be a group. It can be used to store specific elements of the group, the labelled group or other arbitrary objects.

## Loading a group
```@docs
load_group(identifier; filename_prefix = "closed_group_", filename_suffix = "")
```