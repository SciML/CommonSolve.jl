using Pkg

Pkg.develop(PackageSpec(path = dirname(@__DIR__)))
Pkg.instantiate()

using Documenter, CommonSolve

cp("./docs/Manifest.toml", "./docs/src/assets/Manifest.toml", force = true)
cp("./docs/Project.toml", "./docs/src/assets/Project.toml", force = true)

include("pages.jl")

makedocs(
    sitename = "CommonSolve.jl",
    authors = "Chris Rackauckas",
    modules = [CommonSolve],
    clean = true, linkcheck = true,
    format = Documenter.HTML(
        assets = ["assets/favicon.ico"],
        canonical = "https://docs.sciml.ai/CommonSolve/stable"
    ),
    pages = pages
)

deploydocs(repo = "github.com/SciML/CommonSolve.jl.git"; push_preview = true)
