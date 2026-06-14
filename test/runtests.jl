using Pkg
using CommonSolve
using SafeTestsets
using Test

const GROUP = get(ENV, "GROUP", "All")

function activate_qa_env()
    Pkg.activate(joinpath(@__DIR__, "qa"))
    # On Julia < 1.11 the [sources] section in the qa Project.toml is not honored,
    # so Pkg.develop the package root path explicitly to test the PR branch code.
    if VERSION < v"1.11.0-DEV.0"
        Pkg.develop(PackageSpec(path = dirname(@__DIR__)))
    end
    return Pkg.instantiate()
end

if GROUP == "All" || GROUP == "Core"
    @safetestset "CommonSolve.jl" begin
        using CommonSolve
        # CommonSolve is a pure interface package: it defines the function stubs
        # `solve`, `solve!`, `init`, and `step!`. There is no behavior to exercise
        # beyond confirming the package loads and the stubs are defined.
        @test isdefined(CommonSolve, :solve)
        @test isdefined(CommonSolve, :solve!)
        @test isdefined(CommonSolve, :init)
        @test isdefined(CommonSolve, :step!)
    end
end

if GROUP == "QA"
    activate_qa_env()
    @testset "Quality Assurance" begin
        include(joinpath(@__DIR__, "qa", "qa.jl"))
    end
end
