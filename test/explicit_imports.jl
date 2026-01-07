using ExplicitImports
using CommonSolve
using Test

@testset "ExplicitImports" begin
    @test check_no_implicit_imports(CommonSolve) === nothing
    @test check_no_stale_explicit_imports(CommonSolve) === nothing
end
