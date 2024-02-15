using SafeTestsets

@time @safetestset "Quality Assurance" begin
    include("qa.jl")
end
