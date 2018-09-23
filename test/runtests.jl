t1 = time_ns() 
include("test_examples.jl")
include("stats_utils_tests.jl")
include("staircase_tests.jl")
t2 = time_ns() 
println("Tests completed in ", float(t2-t1)*1e9, " seconds")

