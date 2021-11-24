push!(LOAD_PATH,"../src/")

using Documenter, ClosedGroupFunctions

makedocs(sitename="ClosedGroupFunctions.jl")

deploydocs(
    repo = "github.com/Fhoeddinghaus/ClosedGroupFunctions.jl.git",
)