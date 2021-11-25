push!(LOAD_PATH,"../src/")

using Documenter, ClosedGroupFunctions

makedocs(
    sitename="ClosedGroupFunctions.jl",
    pages = [
        "index.md",
        "Generating and Labelling" => "gens.md",
        "Conjugacy Classes" => "conj.md",
        "storage.md",
        "other.md",
    ],
)