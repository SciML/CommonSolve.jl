using CommonSolve
using Test

@testset "CommonSolve.jl" begin
    # CommonSolve is a pure interface package: it defines the function stubs
    # `solve`, `solve!`, `init`, and `step!`. There is no behavior to exercise
    # beyond confirming the package loads and the stubs are defined.
    @test isdefined(CommonSolve, :solve)
    @test isdefined(CommonSolve, :solve!)
    @test isdefined(CommonSolve, :init)
    @test isdefined(CommonSolve, :step!)
end
