using Psychophysics, Lexicon
include("extract_docstrings.jl")

extract_docstrings(["../src/Psychophysics.jl"], "../docs/API.md")

#Lexicon.save("../docs/API.md", Psychophysics)
cd("../")
run(`mkdocs build`)
cd("prep-release")
