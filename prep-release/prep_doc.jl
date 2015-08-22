using AudioUtils, Lexicon


Lexicon.save("../docs/API.md", AudioUtils)
cd("../")
run(`mkdocs build`)
cd("prep-release")
