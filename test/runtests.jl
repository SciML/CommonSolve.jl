using SafeTestsets

@time @safetestset "Quality Assurance" begin
    include("qa.jl")
end

@time @safetestset "Explicit Imports" begin
    include("explicit_imports.jl")
end

@time @safetestset "JET Static Analysis" begin
    include("jet.jl")
end
