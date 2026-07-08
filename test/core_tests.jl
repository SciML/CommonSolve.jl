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

    public_api = (:solve, :solve!, :init, :step!)
    for name in public_api
        binding = Base.Docs.Binding(CommonSolve, name)
        @test haskey(Base.Docs.meta(CommonSolve), binding)
    end

    @static if VERSION >= v"1.11.0-DEV.469"
        for name in public_api
            @test Base.ispublic(CommonSolve, name)
        end
    end
end
