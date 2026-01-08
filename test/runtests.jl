using SafeTestsets

@time @safetestset "Quality Assurance" begin
    include("qa.jl")
end

@time @safetestset "JET Static Analysis" begin
    include("jet.jl")
end

@time @safetestset "ExplicitImports" begin
    include("explicit_imports.jl")
end
