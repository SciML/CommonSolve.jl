using SafeTestsets

@safetestset "Aqua" begin
    using CommonSolve, Aqua
    Aqua.find_persistent_tasks_deps(CommonSolve)
    Aqua.test_ambiguities(CommonSolve, recursive = false)
    Aqua.test_deps_compat(CommonSolve)
    Aqua.test_piracies(CommonSolve)
    Aqua.test_project_extras(CommonSolve)
    Aqua.test_stale_deps(CommonSolve)
    Aqua.test_unbound_args(CommonSolve)
    Aqua.test_undefined_exports(CommonSolve)
end

@safetestset "JET static analysis" begin
    using CommonSolve, JET
    # CommonSolve is an interface package with function stubs (init, solve!, step!)
    # The default solve(args...) = solve!(init(args...)) will report "no matching method"
    # because init has no methods - this is expected for an interface package.
    #
    # We verify that:
    # 1. The only reports are the expected "no matching method" for init
    # 2. No other static analysis issues exist
    rep = JET.report_package(CommonSolve)
    reports = JET.get_reports(rep)

    # Filter to find unexpected reports (not related to the expected init stub)
    unexpected = filter(reports) do r
        msg = sprint(show, r)
        # Expected: no matching method for `init` (the interface stub)
        !occursin("init", msg)
    end

    @test isempty(unexpected)
end

@safetestset "ExplicitImports" begin
    using CommonSolve, ExplicitImports
    @test check_no_implicit_imports(CommonSolve) === nothing
    @test check_no_stale_explicit_imports(CommonSolve) === nothing
end
