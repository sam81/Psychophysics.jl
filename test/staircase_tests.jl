using CSV, DataFrames, Psychophysics, Test

#test_data_dir = "../../Psychophysics_test_data/"
test_data_dir = "Psychophysics_test_data/"
## run(`rm master.zip`)
## run(`rm -r Psychophysics_test_data/`)
## run(`rm -r Psychophysics_test_data-master/`)
run(`wget https://github.com/sam81/Psychophysics_test_data/archive/master.zip`)
run(`unzip master.zip`)
run(`mv Psychophysics_test_data-master/ Psychophysics_test_data/`)

pyResTrialFile = test_data_dir * "pychoacoustics_data/transformed_up-down/res_arithmetic_table_trial.csv"
pyResBlockFile = test_data_dir * "pychoacoustics_data/transformed_up-down/res_arithmetic_table.csv"
pyResBlockData = CSV.read(pyResBlockFile, delim=';')

for bln=1:2
    TUD = initTUD(paradigm="transformed up-down",
                  nCorrectNeeded=2,
                  nIncorrectNeeded=1,
                  stepSizes=[4,2],
                  turnpointsXStepSizes=[4,12],
                  procedure="arithmetic",
                  corrTrackDir="down",
                  terminationRule="turnpoints",
                  nTurnpointsToRun=16)
    pyResTrialData = CSV.read(pyResTrialFile, delim=';')
    pyResTrialData = pyResTrialData[pyResTrialData[!,:block] .== bln,:]

    update!(TUD, pyResTrialData[!, :adaptive_difference][1], pyResTrialData[!,:response][1])
    for i=2:length(pyResTrialData[!,:response])
        update!(TUD, TUD.adaptiveParam, pyResTrialData[!,:response][i])
    end

    @test isapprox(round(TUD.turnpointAverage; digits=3), round(pyResBlockData[!,:threshold_arithmetic][bln]; digits=3))
    @test isapprox(round(TUD.turnpointSD; digits=3), round(pyResBlockData[!,:SD][bln]; digits=3))

    ## for tn=1:length(pyResTrialData[:response])
    ##     @test pyResTrialData[:response][tn] .== TUD.responses[tn]
    ##     @test pyResTrialData[:adaptive_difference][tn] .== TUD.levels[tn]
    ## end

end


pyResTrialFile = test_data_dir * "pychoacoustics_data/transformed_up-down/res_geometric_table_trial.csv"
pyResBlockFile = test_data_dir * "pychoacoustics_data/transformed_up-down/res_geometric_table.csv"
pyResBlockData = CSV.read(pyResBlockFile, delim=';')

for bln=1:2
    TUD = initTUD(paradigm="transformed up-down",
                  nCorrectNeeded=2,
                  nIncorrectNeeded=1,
                  stepSizes=[2,1.414],
                  turnpointsXStepSizes=[4,12],
                  procedure="geometric",
                  corrTrackDir="down",
                  terminationRule="turnpoints",
                  nTurnpointsToRun=16)
    pyResTrialData = CSV.read(pyResTrialFile, delim=';')
    pyResTrialData = pyResTrialData[pyResTrialData[!,:block] .== bln,:]

    update!(TUD, pyResTrialData[!,:adaptive_difference][1], pyResTrialData[!,:response][1])
    for i=2:length(pyResTrialData[!,:response])
        update!(TUD, TUD.adaptiveParam, pyResTrialData[!,:response][i])
    end

    @test isapprox(round(TUD.turnpointAverage; digits=3), round(pyResBlockData[!,:threshold_geometric][bln]; digits=3))
    @test isapprox(round(TUD.turnpointSD; digits=3), round(pyResBlockData[!,:SD][bln]; digits=3))

    ## for tn=1:length(pyResTrialData[:response])
    ##     @test pyResTrialData[:response][tn] .== TUD.responses[tn]
    ##     @test pyResTrialData[:adaptive_difference][tn] .== TUD.levels[tn]
    ## end

end


pyResTrialFile = test_data_dir * "pychoacoustics_data/weighted_up-down/res_arithmetic_table_trial.csv"
pyResBlockFile = test_data_dir * "pychoacoustics_data/weighted_up-down/res_arithmetic_table.csv"
pyResBlockData = CSV.read(pyResBlockFile, delim=';')

for bln=1:2
    TUD = initTUD(paradigm="weighted up-down",
                  nCorrectNeeded=1,
                  nIncorrectNeeded=1,
                  stepSizes=[4,2],
                  turnpointsXStepSizes=[4,12],
                  procedure="arithmetic",
                  corrTrackDir="down",
                  percCorrTracked=75,
                  terminationRule="turnpoints",
                  nTurnpointsToRun=16)
    pyResTrialData = CSV.read(pyResTrialFile, delim=';')
    pyResTrialData = pyResTrialData[pyResTrialData[!,:block] .== bln,:]

    update!(TUD, pyResTrialData[!,:adaptive_difference][1], pyResTrialData[!,:response][1])
    for i=2:length(pyResTrialData[!,:response])
        update!(TUD, TUD.adaptiveParam, pyResTrialData[!,:response][i])
    end

    @test isapprox(round(TUD.turnpointAverage; digits=3), round(pyResBlockData[!,:threshold_arithmetic][bln]; digits=3))
    @test isapprox(round(TUD.turnpointSD; digits=3), round(pyResBlockData[!,:SD][bln]; digits=3))
                   
end


pyResTrialFile = test_data_dir * "pychoacoustics_data/weighted_up-down/res_geometric_table_trial.csv"
pyResBlockFile = test_data_dir * "pychoacoustics_data/weighted_up-down/res_geometric_table.csv"
pyResBlockData = CSV.read(pyResBlockFile, delim=';')

for bln=1:2
    TUD = initTUD(paradigm="weighted up-down",
                  nCorrectNeeded=1,
                  nIncorrectNeeded=1,
                  stepSizes=[2,1.414],
                  turnpointsXStepSizes=[4,12],
                  procedure="geometric",
                  corrTrackDir="down",
                  percCorrTracked=75,
                  terminationRule="turnpoints",
                  nTurnpointsToRun=16)
    pyResTrialData = CSV.read(pyResTrialFile, delim=';')
    pyResTrialData = pyResTrialData[pyResTrialData[!,:block] .== bln,:]

    update!(TUD, pyResTrialData[!,:adaptive_difference][1], pyResTrialData[!,:response][1])
    for i=2:length(pyResTrialData[!,:response])
        update!(TUD, TUD.adaptiveParam, pyResTrialData[!,:response][i])
    end

    @test isapprox(round(TUD.turnpointAverage; digits=3), round(pyResBlockData[!,:threshold_geometric][bln]; digits=3))
    @test isapprox(round(TUD.turnpointSD; digits=3), round(pyResBlockData[!,:SD][bln]; digits=3))
                   
end
