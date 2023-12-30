using CommonSolve, Aqua
@testset "Aqua" begin
    Aqua.find_persistent_tasks_deps(CommonSolve)
    Aqua.test_ambiguities(CommonSolve, recursive = false)
    Aqua.test_deps_compat(CommonSolve)
    Aqua.test_piracies(CommonSolve)
    Aqua.test_project_extras(CommonSolve)
    Aqua.test_stale_deps(CommonSolve)
    Aqua.test_unbound_args(CommonSolve)
    Aqua.test_undefined_exports(CommonSolve)
end
