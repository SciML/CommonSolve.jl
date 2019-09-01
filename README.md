# CommonSolve

This holds the common `solve` command. The rules are that you must dispatch
on one of your own types. That's it. No pirates.

Oh and there're `init` and `solve!` as well.

## General recommendation

`solve` function has the default definition

```julia
solve(args...; kwargs...) = solve!(init(args...; kwargs...))
```

So, we recommend defining

```julia
init(::ProblemType, args...; kwargs...) :: SolverType
solve!(::SolverType) :: SolutionType
```

where `ProblemType`, `SolverType`, and `SolutionType` are the types defined in
your package.

To avoid method ambiguity, the first argument of `solve`, `solve!`, and `init`
_must_ be dispatched on the type defined in your package.  For example, do
_not_ define a method such as

```julia
init(::AbstractVector, ::AlgorithmType)
```
