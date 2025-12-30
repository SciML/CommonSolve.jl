using CommonSolve, JET

@testset "JET static analysis" begin
    # CommonSolve is an interface package with function stubs (init, solve!, step!)
    # The default solve(args...) = solve!(init(args...)) will report "no matching method"
    # because init has no methods - this is expected for an interface package.
    #
    # We verify that:
    # 1. The only reports are the expected "no matching method" for init
    # 2. No other static analysis issues exist
    rep = JET.report_package("CommonSolve")
    reports = JET.get_reports(rep)

    # Filter to find unexpected reports (not related to the expected init stub)
    unexpected = filter(reports) do r
        msg = sprint(show, r)
        # Expected: no matching method for `init` (the interface stub)
        !occursin("init", msg)
    end

    @test isempty(unexpected)
end
