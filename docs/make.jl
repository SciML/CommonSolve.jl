using Documenter, CommonSolve

include("pages.jl")

makedocs(
    sitename = "CommonSolve.jl",
    authors = "Chris Rackauckas",
    modules = [CommonSolve],
    clean = true,
    doctest = false,
    format = Documenter.HTML(
        analytics = "UA-90474609-3",
        assets = ["assets/favicon.ico"],
        canonical = "https://commonsolve.sciml.ai/stable/",
    ),
    pages = pages,
)

deploydocs(repo = "github.com/SciML/CommonSolve.jl.git"; push_preview = true)
